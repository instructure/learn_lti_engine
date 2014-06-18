module LearnLtiEngine
  module Assignments
    module SignatureVerifications
      class TimestampCheck
        attr_accessor :assignment

        STEP_NAME = 'timestamp_check'

        def initialize(assignment)
          @assignment = assignment
        end

        def post_params(options)
          step_data = assignment.step_data_for_step(STEP_NAME)

          timestamps = [
              Time.now - 5.minutes,
              Time.now - 1.day,
              nil
          ]
          ts = timestamps.sample
          step_data.data['valid_timestamp'] = (ts && ts >= Time.now - 10.minutes)
          step_data.data['successes'] ||= 0
          step_data.save!

          tc = assignment.tool_consumer(options[:key], options[:secret], options[:launch_url])
          tc.timestamp = ts

          tc.generate_launch_data
        end

        def validation_fields
          [{
             name: 'timestamp_check',
             label: 'Is this oauth timestamp valid?',
             boolean: true
          }]
        end

        def validation(options)
          step_data = assignment.step_data_for_step(STEP_NAME)
          if ((options['timestamp_check'] == '1' && step_data.data['valid_timestamp']) ||
              (options['timestamp_check'] == '0' && !step_data.data['valid_timestamp']))
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
