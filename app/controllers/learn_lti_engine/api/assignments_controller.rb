require_dependency "learn_lti_engine/application_controller"

module LearnLtiEngine
  class Api::AssignmentsController < ApplicationController

    def show
      user = User.where(lti_user_id: params[:lti_user_id]).first_or_create
      assignment = user.assignments.where(lti_assignment_id: params[:lti_assignment_id]).first_or_create(name: params[:name])
      render json: { assignment: assignment.as_json }
    end

  end
end
