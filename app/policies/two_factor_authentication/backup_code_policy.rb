module TwoFactorAuthentication
  class BackupCodePolicy
    def initialize(user)
      @user = user
    end

    def configured?
      @user.backup_code_configurations.unused.any?
    end

    def enabled?
      configured?
    end

    def visible?
      true
    end

    def enrollable?
      available? && !enabled?
    end

    private

    attr_reader :user
  end
end
