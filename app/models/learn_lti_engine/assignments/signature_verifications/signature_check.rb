module LearnLtiEngine
  module Assignments
    module SignatureVerifications
      class SignatureCheck
        attr_accessor :assignment

        STEP_NAME = 'signature_check'

        def initialize(assignment)
          @assignment = assignment
        end

        def post_params(options)
          step_data = assignment.step_data_for_step(STEP_NAME)
          step_data.data['successes'] ||= 0

          tc = assignment.tool_consumer(options[:key], options[:secret], options[:launch_url])
          launch_data = tc.generate_launch_data

          if [1,2].sample == 1
            # valid
            step_data.data['valid_signature'] = true
            step_data.save!
          else
            # invalid
            step_data.data['valid_signature'] = false
            launch_data['oauth_signature'] = ['_bad_', nil, 'tW11GB48xV/NzenbU23322w406fc='].sample
            step_data.save!
          end

          launch_data
        end

        def validation_fields
          [{
              name: 'signature_check',
              boolean: true,
              label: 'Is this a valid signature?'
          }]
        end

        def validation(options)
          step_data = assignment.step_data_for_step(STEP_NAME)
          if ((options['signature_check'] == '1' && step_data.data['valid_signature']) ||
              (options['signature_check'] == '0' && !step_data.data['valid_signature']))
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
