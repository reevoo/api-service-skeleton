require "foo_service/db"
require "foo_service/event_publisher"

module FooService
  class Item < Sequel::Model
    include EventPublisher::Hooks

    STATES = %w(enabled disabled)

    one_to_many :users

    dataset_module do
      def find_by_id(client_id)
        where(id: client_id).first
      end

      def in_range(range)
        if range
          limit(range.end - range.begin + 1).offset(range.begin)
        else
          self
        end
      end

      def search(query_string)
        like_expr = "%#{query_string}%"
        match_name = Sequel.like(:name, like_expr, case_insensitive: true)
        match_trkrefs = Sequel.like(Sequel.function(:array_to_string, :trkrefs, ","), like_expr)
        where(match_name | match_trkrefs)
      end

      def search_by_trkrefs(trkrefs)
        Sequel.extension :pg_array_ops
        where(Sequel.pg_array_op(:trkrefs).overlaps(trkrefs.split(",")))
      end

      def search_by_client_uuids(uuids)
        where([[:id, uuids]])
      end

      def not_deleted
        where(deleted_at: nil).order(:created_at)
      end
    end

    set_dataset(not_deleted)

    def soft_delete
      update(deleted_at: Time.now)
    end

    def trkref_names
      FooService::RetailerHelpers.names_by_trkref_for_client(self)
    end

    def trkref_review_tags
      FooService::RetailerHelpers.review_tags_by_trkref_for_client(self)
    end

    def entity
      Entity.new(self)
    end

    class SimpleEntity < Grape::Entity
      expose :id, documentation: { type: "string", desc: "UUID" }
      expose :name, documentation: { type: "string" }
    end

    class Entity < SimpleEntity
      expose :trkrefs, documentation: { type: "string", is_array: true, desc: "TRKREFs accessible by the client" }
      expose :trkref_names,
        documentation: { type: "string", is_array: true, desc: "Names of TRKREFs accessible by the client" }
      expose :trkref_review_tags,
        documentation: { type: "JSON", desc: "Map of tags applied on review for each TRKREF" }
      expose :contract_expiry, documentation: { type: "string", desc: "Date of the contract expiration" }
      expose :state, documentation: { type: "string", desc: "State of the client", values: STATES }
      expose :created_at, documentation: { type: "string", desc: "Date of the client record creation" }
      expose :updated_at, documentation: { type: "string", desc: "Date of the client record last update" }
      expose :accessible_modules,
        documentation: { type: "string", is_array: true, desc: "myReevoo modules accessible for client" }
      expose :accessible_dashboards,
        documentation: { type: "string", is_array: true,
                         desc: "myReevoo analytic dashboards accessible for client" }
    end
  end
end
