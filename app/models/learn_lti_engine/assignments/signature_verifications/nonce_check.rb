module LearnLtiEngine
  module Assignments
    module SignatureVerifications
      class NonceCheck
        attr_accessor :assignment

        STEP_NAME = 'nonce_check'

        def initialize(assignment)
          @assignment = assignment
        end

        def post_params(options)
          step_data = assignment.step_data_for_step(STEP_NAME)

          new_nonce = SecureRandom.uuid
          step_data.data['used_nonces'] ||= []
          used_nonce = step_data.data['used_nonces'].sample
          nonce = [new_nonce, used_nonce].compact.sample

          step_data.data['valid_nonce'] = (nonce == new_nonce)
          step_data.data['used_nonces'] << nonce if (step_data.data['valid_nonce'])
          step_data.data['successes'] ||= 0

          step_data.save!

          tc = assignment.tool_consumer(options[:key], options[:secret], options[:launch_url])
          tc.nonce = nonce

          tc.generate_launch_data
        end

        def validation_fields
          [{
               name: 'nonce_check',
               label: 'Is this a valid nonce?',
               boolean: true
           }]
        end

        def validation(options)
          step_data = assignment.step_data_for_step(STEP_NAME)
          if ((options['nonce_check'] == '1' && step_data.data['valid_nonce']) ||
              (options['nonce_check'] == '0' && !step_data.data['valid_nonce']))
            if step_data.data['successes'] == 4
              step_data.destroy!
              {
                  status: 'completed'
              }
            else
              step_data.data['successes'] += 1
              step_data.save!
              {
                  status: 'repeat',
                  message: "Great job! Click to relaunch (#{step_data.data['successes']} of 5)"
              }
            end
          else
            step_data.destroy!
            {
                status: 'incorrect',
                message: 'Wrong! Click launch to try again'
            }
          end
        end

      end
    end
  end
end
