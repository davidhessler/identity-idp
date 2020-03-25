module Px
  module Flows
    class DocAuthFlow < Flow::BaseFlow
      # TODO: Finish migrating these
      STEPS = {
        welcome: Px::Steps::WelcomeStep,
        upload: Px::Steps::UploadStep,
        send_link: Px::Steps::SendLinkStep,
        link_sent: Px::Steps::LinkSentStep, # TODO Polling is broken on this step
        email_sent: Px::Steps::EmailSentStep,
        front_image: Px::Steps::FrontImageStep,
        back_image: Px::Steps::BackImageStep,
        # mobile_front_image: Px::Steps::MobileFrontImageStep,
        # mobile_back_image: Px::Steps::MobileBackImageStep,
        # ssn: Px::Steps::SsnStep,
        # verify: Px::Steps::VerifyStep,
        # doc_success: Px::Steps::DocSuccessStep,
      }.freeze

      ACTIONS = {
        reset: Px::Actions::ResetAction,
      #   redo_ssn: Px::Actions::RedoSsnAction,
      }.freeze

      attr_reader :idv_session # this is needed to support (and satisfy) the current LOA3 flow

      def initialize(controller, session, name)
        @idv_session = self.class.session_idv(session)
        super(controller, STEPS, ACTIONS, session[name])
      end

      def self.session_idv(session)
        session[:idv] ||= { params: {}, step_attempts: { phone: 0 } }
      end
    end
  end
end