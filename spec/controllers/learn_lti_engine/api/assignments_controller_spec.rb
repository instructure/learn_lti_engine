require 'spec_helper'

module LearnLtiEngine
  describe Api::AssignmentsController do
    before :each do
      @user = User.where(lti_user_id: "testing-1").first_or_create!
      @assignment = Assignment.create!(
          user_id: @user.id,
          lti_assignment_id: "307-1-96-1-012db6ed32f43301cf43611a919cd0b39957ce7d",
          lti_launch_params: { foo: "bar" },
          name: "post_param",
          completed_tasks: ["lti_message_type", "lti_version"]
      )
    end

    context "show" do
      it "with incomplete tasks" do
        get :show, lti_user_id: @user.lti_user_id, lti_assignment_id: @assignment.lti_assignment_id, name: @assignment.name, use_route: :learn_lti_engine
        json = JSON.parse(response.body)
        expect(json['assignment']['lti_user_id']).to eq(@user.lti_user_id)
        expect(json['assignment']['name']).to eq(@assignment.name)
        expect(json['assignment']['completed_tasks']).to eq(@assignment.completed_tasks)
        expect(json['assignment']['is_completed']).to be(false)
      end

      it "with completed tasks" do
        @assignment.completed_tasks = Assignment::ASSIGNMENTS["post_param"]
        @assignment.save!
        get :show, lti_user_id: @user.lti_user_id, lti_assignment_id: @assignment.lti_assignment_id, name: @assignment.name, use_route: :learn_lti_engine
        json = JSON.parse(response.body)
        expect(json['assignment']['is_completed']).to be(true)
      end
    end
  end
end
