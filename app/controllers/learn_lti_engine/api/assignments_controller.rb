require_dependency "learn_lti_engine/application_controller"

module LearnLtiEngine
  class Api::AssignmentsController < ApplicationController
    before_action :authenticate

    # Hackery to support query requests (ember data ftw)
    def index
      render json: { assignments: [ @assignment.as_json ] }
    end

    def show
      render json: { assignment: @assignment.as_json }
    end

    # def post_param
    #   required_params = {
    #     :lti_message_type => 'basic-lti-launch-request',
    #     :lti_version => 'LTI-1.0',
    #     :resource_link_id => '322e0ed3f0',
    #     :oauth_consumer_key => '647ea402eca955b8e84767da08bbbe71',
    #     :oauth_nonce => 'OBkXoWQNC3OhehHb5psUs9mQZYIvmKUqKFaFExp3Xk',
    #     :oauth_signature => 'GH8tkBTJ2vVA6FsDqr77dBfhNXI=',
    #     :oauth_signature_method => 'HMAC-SHA1',
    #     :oauth_timestamp => '1402349259',
    #     :oauth_version => '1.0'
    #   }

    #   recommended_params = {
    #     :context_id => '1408bd6ddf',
    #     :context_title => 'Hippo 478',
    #     :launch_presentation_return_url => 'https://learn-lti.herokuapp.com/tool_return/post_launch/0/6614',
    #     :lis_person_name_full => 'YoussefHamza Rands',
    #     :roles => 'urn:lti:instrole:ims/lis/observer,instructor,urn:lti:instrole:ims/lis/administrator',
    #     :tool_consumer_instance_name => 'Account 696',
    #     :user_id => '2d07434d6e'
    #   }

    #   if params[:p] == 'basic'
    #     render json: required_params
    #   else
    #     render json: (required_params.merge(recommended_params))
    #   end
    # end

    def update
      @assignment.completed_tasks = params[:assignment][:completed_tasks]
      @assignment.save
      render json: { assignment: @assignment.as_json }
    end

    def step_params
      # params[:key], params[:secret]
      render json: {
          post_params: @assignment.post_params(params),
          validation_fields: @assignment.validation_fields(params[:step_name])
      }
    end

    def step_validation
      step = params[:step_name]
      result = @assignment.validation(params)

      if result[:status] == 'completed'
        if !@assignment.completed_tasks.include?(step)
          @assignment.completed_tasks << step
          @assignment.save!
        end
        send_grade if @assignment.is_completed?
      end
      render json: result
    end

    private

    def authenticate
      bearer = request.headers["HTTP_AUTHORIZATION"]
      bearer ||= request.headers["rack.session"].try(:[], 'Authorization')
      if bearer.present?
        lis_result_sourcedid = assignment_name = bearer.split(' ').last
        @assignment = Assignment.where(lti_assignment_id: lis_result_sourcedid).first
        if @assignment
          @user = @assignment.user
        else
          puts "Unable to find assignment!"
          render status: 401
        end
      else
        puts "Bearer is not present!"
        head 401
      end
    end

    def send_grade
      account = @assignment.account
      tp = IMS::LTI::ToolProvider.new(account.lti_key,account.lti_secret,@assignment.lti_launch_params)
      tp.extend IMS::LTI::Extensions::OutcomeData::ToolProvider
      tp.post_replace_result!(1.0)
    end

  end
end