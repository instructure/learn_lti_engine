module LearnLtiEngine
  module Assignments
    class SignatureVerification < LearnLtiEngine::Assignment
      def step(step_name)
        "LearnLtiEngine::Assignments::SignatureVerifications::#{step_name.classify}".constantize.new(self)
      end

      def tool_consumer(key, secret, launch_url)
        tc = IMS::LTI::ToolConsumer.new(key, secret)
        tc.launch_url = launch_url
        tc.timestamp = Time.now.to_i
        tc.nonce = SecureRandom.uuid

        tc.lti_version = 'LTI-1.0'
        tc.lti_message_type = 'basic-lti-launch-request'
        tc.resource_link_id = SecureRandom.hex(32)

        tc
      end

      def post_params(options)
        step(options['step_name']).post_params(options)
      end

      def validation_fields(step_name)
        step(step_name).validation_fields
      end

      def validation(options)
        step(options['step_name']).validation(options)
      end
    end
  end
end

