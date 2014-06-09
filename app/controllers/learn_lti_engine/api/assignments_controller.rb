require_dependency "learn_lti_engine/application_controller"

module LearnLtiEngine
  class Api::AssignmentsController < ApplicationController

    # Hackery to support query requests (ember data ftw)
    def index
      user = User.where(lti_user_id: params[:lti_user_id]).first_or_create
      assignment = user.assignments.where(lti_assignment_id: params[:lti_assignment_id]).first_or_create(name: params[:name])
      render json: { assignments: [ assignment.as_json ] }
    end

    def show
      user = User.where(lti_user_id: params[:lti_user_id]).first_or_create
      assignment = user.assignments.where(lti_assignment_id: params[:lti_assignment_id]).first_or_create(name: params[:name])
      render json: { assignment: assignment.as_json }
    end

    def post_params
      required_params = {
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

      recommended_params = {
        :context_id => '1408bd6ddf',
        :context_title => 'Hippo 478',
        :launch_presentation_return_url => 'https://learn-lti.herokuapp.com/tool_return/post_launch/0/6614',
        :lis_person_name_full => 'YoussefHamza Rands',
        :roles => 'urn:lti:instrole:ims/lis/observer,instructor,urn:lti:instrole:ims/lis/administrator',
        :tool_consumer_instance_name => 'Account 696',
        :user_id => '2d07434d6e'
      }

      if params[:p] == 'basic'
        render json: required_params
      else
        render json: (required_params.merge(recommended_params))
      end
    end

    def update
      
    end

  end
end
