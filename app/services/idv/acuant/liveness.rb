module Idv
  module Acuant
    class Liveness
      include Idv::Acuant::Http

      base_uri Figaro.env.acuant_passlive_url

      attr_accessor :instance_id

      def initialize(cfg = default_cfg)
        @subscription_id = cfg.fetch(:subscription_id)
        @authentication_params = cfg.slice(:username, :password)
      end

      def liveness(body)
        url = '/api/v1/liveness'

        options = default_options.merge(
          headers: content_type_json.merge(accept_json),
          body: body,
        )
        post(url, options)
      end

      private

      def default_cfg
        {
          subscription_id: env.acuant_assure_id_subscription_id,
          username: env.acuant_assure_id_username,
          password: env.acuant_assure_id_password,
        }
      end

      def default_options
        { basic_auth: @authentication_params }
      end
    end
  end
end
