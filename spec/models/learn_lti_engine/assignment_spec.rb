require 'spec_helper'

module LearnLtiEngine
  describe Assignment do
    it { should belong_to(:user) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:lti_assignment_id) }
    it { should validate_uniqueness_of(:lti_assignment_id) }
    it { should ensure_inclusion_of(:name).in_array(Assignment::ASSIGNMENTS.keys) }
  end
end
