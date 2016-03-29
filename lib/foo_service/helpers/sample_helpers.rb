module FooService
  module ResponseHelpers
    extend Grape::API::Helpers

    params :items do # shared params definition
      requires :content_id, type: String, desc: "Content id",  valid_uuid: true

      requires(
        :content_type,
        type: String, desc: "Content type",
        values: FooService::Response.db_schema.fetch(:content_type).fetch(:enum_values),
      )

      requires :text, type: String, desc: "Response text"

      requires(
        :type,
        type: String,
        desc: "Type of the response",
        values: FooService::Response.db_schema.fetch(:type).fetch(:enum_values),
      )

      requires :should_notify_customer, type: String, desc: "Whether or not to notify the customer"
      optional :note, type: String, desc: "Response note (not visible to clients)"
    end


    def check_foo(foo)
      # reusable code for multiple api endpoints
      error!("Cannot find foo", 404) # can terminate request with error
    end

  end
end
