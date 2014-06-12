module LearnLtiEngine
  module Assignments
    class SignatureVerification < LearnLtiEngine::Assignment
      VALIDATION_FIELDS = {
          'nonce_check' => [
              {name: 'nonce_check', multiple: true, label: 'Is this a valid nonce?', values: ['yes', 'no']}
          ],
          'signature_check' => [
              {name: 'signature_check', multiple: true, label: 'Is this a valid signature?', values: ['yes', 'no']}
          ]
      }

      def post_params(options)
        data = self.step_data(options[:step_name])
        nonce = SecureRandom.uuid

        tc = IMS::LTI::ToolConsumer.new(options[:key], options[:secret])
        tc.launch_url = options[:launch_url]
        tc.timestamp = Time.now.to_i
        tc.nonce = nonce

        tc.lti_version = 'LTI-1.0'
        tc.lti_message_type = 'basic-lti-launch-request'
        tc.resource_link_id = SecureRandom.hex(32)

        tc.generate_launch_data
      end

      def validation_fields(step)
        VALIDATION_FIELDS[step]
      end

      def validation(step, params)

        render json: {status: 'repeat', message: 'Great job! Click to relaunch (1 of 5)'}

        # if VALIDATION_FIELDS[step].all? {|f| f[:value] == params[f[:name]] }
        #   { status: 'completed' }
        # else
        #   { status: 'incorrect', message: 'You did not provide the correct value' }
        # end
      end
    end
  end
end

