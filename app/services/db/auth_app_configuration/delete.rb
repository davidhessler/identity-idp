module Db
  module AuthAppConfiguration
    class Delete
      def self.call(current_user, auth_app_cfg_id)
        UpdateUser.new(
          user: current_user,
          attributes: { otp_secret_key: nil },
        ).call
        ::AuthAppConfiguration.where(user_id: current_user.id, id: auth_app_cfg_id).delete_all
      end
    end
  end
end
