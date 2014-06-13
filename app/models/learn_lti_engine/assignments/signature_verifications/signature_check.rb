module LearnLtiEngine
  module Assignments
    module SignatureVerifications
      class SignatureCheck
        attr_accessor :assignment

        STEP_NAME = 'signature_check'

        def initialize(assignment)
          @assignment = assignment
        end

        def post_params
          {}
        end

        def validation_fields
          {
              name: 'signature_check',
              multiple: true,
              label: 'Is this a valid signature?',
              values: ['yes', 'no']
          }
        end

        def validation(params)
          {
              status: 'repeat',
              message: 'Great job! Click to relaunch (1 of 5)'
          }
        end

      end
    end
  end
end
