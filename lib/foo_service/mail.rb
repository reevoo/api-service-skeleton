require "ostruct"
require "pony"
require "slim"

# copy-paste from Client Portal
module FooService
  class Mail
    class << self
      def init(templates_dir = "./lib/foo_service/mail_templates")
        pony_options = {
          from: "support@reevoo.com",
          via: ENV.fetch("MAIL_DELIVERY_METHOD", :test).to_sym,
        }
        # can be useful in development
        # require "letter_opener"
        # pony_options = {
        #   via: LetterOpener::DeliveryMethod,
        #   via_options: {
        #     location: File.expand_path('../../../tmp/letter_opener', __FILE__)
        #   }
        # }
        pony_options[:via_options] = smtp_options_from_env if pony_options[:via] == :smtp
        Pony.options = pony_options
        @templates_dir = templates_dir
      end

      def send_mail(template_name, mail_params, template_params = {})
        mail_params.reverse_merge!(
          subject:    "Client Portal",
          body:       render_template(template_name + ".txt", template_params),
          html_body:  render_template(template_name, template_params),
        )

        mail = Pony.mail(mail_params)

        return mail if ENV["RACK_ENV"] == "development"
        { status: "sent" }
      end

      private

      def render_template(template_name, params = {})
        template_path = File.join(@templates_dir, "#{template_name}.slim")
        slim_template = Slim::Template.new(template_path)
        slim_template.render(OpenStruct.new(params))
      end

      def smtp_options_from_env
        {
          address:              ENV.fetch("SMTP_HOST"),
          port:                 ENV.fetch("SMTP_PORT", 25).to_i,
          user_name:            ENV.fetch("SMTP_USER"),
          password:             ENV.fetch("SMTP_PASSWORD"),
          authentication:       ENV.fetch("SMTP_AUTHENTICATION", :plain).to_sym,
          domain:               ENV.fetch("SMTP_DOMAIN", "localhost"),
          enable_starttls_auto: ENV.fetch("SMTP_ENABLE_STARTTLS_AUTO", false).present?,
        }
      end
    end
  end
end
