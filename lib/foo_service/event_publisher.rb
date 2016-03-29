require "sneakers"
require "json"

module FooService
  ## == Provides a method of publishing lifecyle events
  ##
  ## Other parts of the system need to take action based on lifecycle events
  ## that occur in this application without becoming overly coupled.
  ##
  ## For example Tableau may need to know which clients should be able to access
  ## graphs and whatnot.
  ##
  ## The messages published by this module are intentionaly sparse and only
  ## include the UUID of the entity in question.
  ## It will normaly be neccesary for the consumer to query the API to get
  ## the curent state, the event should only act as a initiator for other
  ## Services to take whatever action they see fit.
  module EventPublisher
    extend self

    Sneakers.configure(
      amqp: ENV["AMQP_URI"],
      exchange_type: :topic,
      exchange: :'reevoo-platform',
      heartbeat: 2,
    )

    # Publishes an event to the appropriate topic
    #
    # @param entity[#id] the entity in question
    # @param action[String] the action that occured e.g. update
    def publish(entity:, action:)
      fail ArgumentError, "missing value: entity" unless entity
      fail ArgumentError, "missing value: action" unless action && !action.empty?
      fail ArgumentError, "entity must have: id" unless entity.respond_to?(:id) && entity.id
      publisher.publish(
        { id: entity.id, name: entity.name }.to_json,
        routing_key: "my_reevoo.admin.#{name_for(entity)}.#{action}",
      )
    end

    attr_writer :publisher

    private

    def name_for(entity)
      entity.class.to_s.split("::").last.downcase
    end

    def publisher
      @publisher ||= Sneakers::Publisher.new
    end

    module Hooks
      def after_create
        EventPublisher.publish(
          action: "created",
          entity: self,
        )
        super
      end

      def after_update
        action = deleted_at ? "deleted" : "updated"

        EventPublisher.publish(
          action: action,
          entity: self,
        )
        super
      end
    end
  end
end
