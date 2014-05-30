require 'spec_helper'

module LearnLtiEngine
  describe User do
    it { should have_many(:assignments) }
    it { should validate_presence_of(:lti_user_id) }
    it { should validate_uniqueness_of(:lti_user_id) }
  end
end
