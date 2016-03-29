require "foo_service/mailers/decorators/item_decorator"
require "foo_service/speakeasy"

module FooService
  module Mailers
    module SampleMailer
      extend self

      def send_notification_if_needed(response)
        return unless response.status == "published"
        return unless response.type == "private" || response.should_notify_customer
        FooService::Mailers::VettingMailer.new_response(response)
      end

      def new_response(response)
        content = ItemDecorator.new(FooService::Item.find_by_id(response.content_id))
        user = ClientPortalApiClient::Users.get(response.user_id)
        email = Speakeasy.get_email(content.type, content.recepient_unspeakable_email)

        opts = { to: email }
        opts[:subject] = subject_line(response)

        opts[:reply_to] = response.reply_to_address if response.reply_to_address
        FooService::Mail.send_mail(
          "new_response",
          opts,

          response: response,
          content: content,
          user: user,

        )
      end

      private

      def subject_line(response)
        response.subject_line.present? ? response.subject_line : "Reevoo: New Response"
      end
    end
  end
end
