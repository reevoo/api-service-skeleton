require "speakeasy"

module FooService
  class Speakeasy
    class << self
      def init
        ::Speakeasy.setup(
          key_file: File.expand_path("foo_service.key",  cert_dir),
          certificate_file: File.expand_path("foo_service.crt",  cert_dir),
          server_certificate_file: File.expand_path("ca.crt",  cert_dir),
          server_uri: ENV.fetch("SPEAKEASY_SERVER_URI"),
          validate_response_hashes: ENV.fetch("SPEAKEASY_VALIDATE_RESPONSE_HASHES", false),
          key_passphrase: ENV["SPEAKEASY_SERVER_KEY_PASSPHRASE"],
        )

        @connection = ::Speakeasy.connector
      end

      def cert_dir
        ENV.fetch("SPEAKEASY_CERT_DIR")
      end

      def get_email(content_type, hash)
        response = @connection.get("/#{type_to_table(content_type)}/#{hash}")
        fail "Null response from unspeakable" unless response
        fail "Email not found in unspeakable" if response.body.empty?
        response.body
      end

    end
  end
end
