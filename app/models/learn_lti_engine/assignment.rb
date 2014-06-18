module LearnLtiEngine
  class Assignment < ActiveRecord::Base
    has_many :step_data, class: StepData
    belongs_to :user
    belongs_to :account
    serialize :lti_launch_params, Hash
    serialize :completed_tasks, Array

    ASSIGNMENTS = {
      "post_param" => {
        "title" => "LTI Activity 1. POST Parameters",
        "description" => "At their simplest level LTI launches are just POST requests. There are some standard parameters that you should expect to come across on all launches, and also some option parameters you'll potentially want to look for. Let's make sure you can retrieve these correctly.",
        "tasks" => %w( lti_message_type lti_version resource_link_id context_id user_id roles oauth_consumer_key oauth_nonce oauth_timestamp oauth_signature lis_person_name_full custom_params lis_outcome_service_url )
      },
      "signature_verification" => {
        "title" => "LTI Activity 2. Signature Verification",
        "description" => "Make sure you know how to verify signatures and other security parameters.",
        "tasks" => %w( nonce_check timestamp_check signature_check ),
        "uses_oauth" => true
      },
      "return_redirect" => {
        "title" => "LTI Activity 3. Return Redirects",
        "description" => "Make sure you know how to redirect back to the LMS, potentially with success or error messages.",
        "tasks" => %w( launch_presentation_return_url lti_msg lti_log lti_errormsg lti_errorlog )
      },
      "xml_configuration" => {
        "title" => "LTI Activity 4. XML Configuration",
        "description" => "Make sure you know how to <a href=\"https://lti-examples.heroku.com/build_xml.html\">build config XML</a>.",
        "tasks" => %w( lti_message_type lti_version resource_link_id context_id user_id roles oauth_consumer_key oauth_nonce oauth_timestamp oauth_signature lis_person_full_name custom_params lis_outcome_service_url )
      },
      "returning_content" => {
        "title" => "LTI Activity 5. Returning Content",
        "description" => "Make sure you know how to use <a href=\"https://canvas.instructure.com/doc/api/file.tools_intro.html\">the content extensions in Canvas</a> to return resources.",
        "tasks" => %w( lti_message_type lti_version resource_link_id context_id user_id roles oauth_consumer_key oauth_nonce oauth_timestamp oauth_signature lis_person_full_name custom_params lis_outcome_service_url )
      },
      "grade_passback" => {
        "title" => "LTI Activity 6. Grade Passback",
        "description" => "Make sure you know how to pass grades back to the learning platform.",
        "tasks" => %w( lti_message_type lti_version resource_link_id context_id user_id roles oauth_consumer_key oauth_nonce oauth_timestamp oauth_signature lis_person_full_name custom_params lis_outcome_service_url )
      }
    }

    validates :user_id, presence: true
    validates :lti_assignment_id, presence: true, uniqueness: true

    def name
      type.split('::').last.underscore
    end

    def is_completed?
      (completed_tasks & ASSIGNMENTS[name]["tasks"]).length == ASSIGNMENTS[name]["tasks"].length
    end

    def step_data_for_step(step_name)
      self.step_data.where(step: step_name).first_or_create(data: {})
    end

    def as_json
      {
          id: id,
          name: name,
          title: ASSIGNMENTS[name]['title'],
          description: ASSIGNMENTS[name]['description'],
          tasks: ASSIGNMENTS[name]['tasks'],
          uses_oauth: ASSIGNMENTS[name]['uses_oauth'] || false,
          lti_user_id: user.lti_user_id,
          lti_assignment_id: lti_assignment_id,
          completed_tasks: completed_tasks,
          is_completed: self.is_completed?,
      }
    end
  end
end
