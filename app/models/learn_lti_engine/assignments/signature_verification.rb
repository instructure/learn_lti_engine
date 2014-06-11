module LearnLtiEngine
  module Assignments
    class SignatureVerification
      VALIDATION_FIELDS = {
        'signature_check' => [
          { name: 'signature_check', multiple: true, label: 'Is this a valid signature?', values: ['yes', 'no'] }
        ]
      }

      def post_params(step)
        # recommended_params = {
        #   :context_id => '1408bd6ddf',
        #   :context_title => 'Hippo 478',
        #   :launch_presentation_return_url => 'https://learn-lti.herokuapp.com/tool_return/post_launch/0/6614',
        #   :lis_person_name_full => 'YoussefHamza Rands',
        #   :roles => 'urn:lti:instrole:ims/lis/observer,instructor,urn:lti:instrole:ims/lis/administrator',
        #   :tool_consumer_instance_name => 'Account 696',
        #   :user_id => '2d07434d6e'
        # }

        {
          :lti_message_type => 'basic-lti-launch-request',
          :lti_version => 'LTI-1.0',
          :resource_link_id => '322e0ed3f0',
          :oauth_consumer_key => '647ea402eca955b8e84767da08bbbe71',
          :oauth_nonce => 'OBkXoWQNC3OhehHb5psUs9mQZYIvmKUqKFaFExp3Xk',
          :oauth_signature => 'GH8tkBTJ2vVA6FsDqr77dBfhNXI=',
          :oauth_signature_method => 'HMAC-SHA1',
          :oauth_timestamp => '1402349259',
          :oauth_version => '1.0'
        }
      end

      def validation_fields(step)
        VALIDATION_FIELDS[step]
      end

      def validation(step, params)
        render json: { status: 'repeat', message: 'Great job! Click to relaunch (1 of 5)' }

        # if VALIDATION_FIELDS[step].all? {|f| f[:value] == params[f[:name]] }
        #   { status: 'completed' }
        # else
        #   { status: 'incorrect', message: 'You did not provide the correct value' }
        # end
      end
    end
  end
end

