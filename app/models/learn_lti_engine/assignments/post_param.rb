module LearnLtiEngine
  module Assignments
    class PostParam < LearnLtiEngine::Assignment
      VALIDATION_FIELDS = {
          'lti_message_type' => [{name: 'lti_message_type', values: ['basic-lti-launch-request']}],
          'lti_version' => [{name: 'lti_version', values: ['LTI-1.0']}],
          'resource_link_id' => [{name: 'resource_link_id', values: ['846a6b', '01c3f4', '5cc3b9']}],
          'context_id' => [{name: 'context_id', values: ['08c340', '204ecb', 'e85bd6']}],
          'user_id' => [{name: 'user_id', values: ['a89a15', '08a589', 'f854d7']}],
          'roles' => [
              {name: 'urn:lti:instrole:ims/lis/Instructor', label: 'Is a teacher?', boolean: true},
              {name: 'urn:lti:instrole:ims/lis/Learner', label: 'Is a student?', boolean: true},
              {name: 'urn:lti:instrole:ims/lis/Observer', label: 'Is an observer?', boolean: true},
              {name: 'urn:lti:role:ims/lis/ContentDeveloper', label: 'Is a designer?', boolean: true},
              {name: 'urn:lti:role:ims/lis/Administrator', label: 'Is an admin?', boolean: true},
              {name: 'urn:lti:role:ims/lis/TeachingAssistant', label: 'Is a TA?', boolean: true},
          ],
          'oauth_consumer_key' => [{name: 'oauth_consumer_key', type: 'text', values: ["40587b", "e0a91c", "7f8d9e"]}],
          'oauth_nonce' => [{name: 'oauth_nonce', type: 'text', values: ["40a16f", "d53cec", "8df529"]}],
          'oauth_timestamp' => [{name: 'oauth_timestamp', type: 'text', values: [Time.now.to_i.to_s]}],
          'oauth_signature' => [{name: 'oauth_signature', type: 'text', values: ['[C+tYpJrqoGDSMUouP/6mHvZa6nA=', 'BkTWusF86PwgUMyzSJdBw8DqkLY=', 'r71fK8a4SwCxlQww783ft6avZqY=']}],
          'lis_person_name_full' => [{name: 'lis_person_name_full', type: 'text', values: ['Spiderman', 'Wonder Woman', 'Batman']}],
          'custom_params' => [
              {name: 'custom_superpower', label: 'value for \'custom_superpower\'', type: 'text', values: ['spandex', 'deep voice', 'deflect bullets']},
              {name: 'custom_vehicle', label: 'value for \'custom_vehicle\'', type: 'text', values: ['Batmobile', 'spiderweb', 'invisible car']}
          ],
          'lis_outcome_service_url' => [{name: 'lis_outcome_service_url', type: 'text', values: ['https://example.com/0397e2', 'https://example.com/34edeb', 'https://example.com/b855ea']}]
      }

      def post_params(options)
        step_data = step_data_for_step(options['step_name'])
        extra_params = {}
        step_data.data[:fields] = []

        if options['step_name'] == 'roles'
          roles = VALIDATION_FIELDS[options['step_name']].shuffle
          enabled_roles = []
          roles.each do |role|
            if Random.rand  < (1.0/3)
              step_data.data[:fields] << { name: role[:name], value: 1 }
              role_name = role[:name]
              role_name = role_name.split('/').last if Random.rand < 0.5
              enabled_roles << role_name
            else
              step_data.data[:fields] << { name: role[:name], value: 0 }
            end
          end

          extra_params[:roles] = enabled_roles.join(',') if enabled_roles.size > 0
          extra_params[:roles] ||= 'urn:lti:sysrole:ims/lis/None'
        else
          VALIDATION_FIELDS[options['step_name']].each do |field|
            value = field[:values].sample
            extra_params[field[:name]] = value
            step_data.data[:fields] << {name: field[:name], value: value}
          end
        end

        step_data.save!

        {
            'lti_message_type' => 'basic-lti-launch-request',
            'lti_version' => 'LTI-1.0',
            'resource_link_id' => SecureRandom.hex(3),
            'oauth_consumer_key' => '647ea402eca955b8e84767da08bbbe71',
            'oauth_nonce' => 'OBkXoWQNC3OhehHb5psUs9mQZYIvmKUqKFaFExp3Xk',
            'oauth_signature' => 'GH8tkBTJ2vVA6FsDqr77dBfhNXI=',
            'oauth_signature_method' => 'HMAC-SHA1',
            'oauth_timestamp' => '1402349259',
            'oauth_version' => '1.0'
        }.merge(extra_params)
      end

      def validation_fields(step)
        VALIDATION_FIELDS[step]
      end

      def validation(options)
        # render json: { status: 'repeat', message: 'Great job! Click to relaunch (3 of 5)' }
        step_data = step_data_for_step(options['step_name'])

        if (step_data.data[:fields] || []).all? { |f| f[:value].to_s == options[f[:name]].to_s }
          result = {status: 'completed'}
        else
          result = {status: 'incorrect', message: 'You did not provide the correct value. Click to relaunch'}
        end

        step_data.destroy!

        result
      end
    end
  end
end
