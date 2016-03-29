module ApiHelpers
  def self.included(base)
    base.include Rack::Test::Methods

    base.class_eval do
      def app
        FooService::API
      end

      def authenticate_user(user = ClientPortalApiClient::User.new(SecureRandom.uuid, client_id: SecureRandom.uuid))
        allow(ClientPortalApiClient::User).to receive(:from_jwt).and_return(user)
        user
      end
    end
  end


  def post_json(path, params)
    post(
      path,
      params.is_a?(String) ? params : JSON.dump(params),
      "CONTENT_TYPE" => "application/json",
    )
  end

  def put_json(path, params)
    put(
      path,
      params.is_a?(String) ? params : JSON.dump(params),
      "CONTENT_TYPE" => "application/json",
    )
  end

  def response_json
    JSON.load(last_response.body)
  end
end
