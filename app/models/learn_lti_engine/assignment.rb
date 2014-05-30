module LearnLtiEngine
  class Assignment < ActiveRecord::Base
    belongs_to :user
    serialize :lti_launch_params, Hash
    serialize :completed_tasks, Array

    ASSIGNMENTS = {
        "post_params" => %w( lti_message_type lti_version resource_link_id context_id user_id roles oauth_consumer_key
          oauth_nonce oauth_timestamp oauth_signature lis_person_full_name custom_params lis_outcome_service_url )
    }

    validates :user_id, presence: true
    validates :lti_assignment_id, presence: true, uniqueness: true
    validates :name, presence: true, inclusion: { in: ASSIGNMENTS.keys }

    def is_completed?
      (completed_tasks & ASSIGNMENTS[name]).length == ASSIGNMENTS[name].length
    end

    def as_json
      {
          id: id,
          name: name,
          lti_user_id: user.lti_user_id,
          lti_assignment_id: lti_assignment_id,
          completed_tasks: completed_tasks,
          is_completed: self.is_completed?
      }
    end
  end
end
