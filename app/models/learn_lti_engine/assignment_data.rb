module LearnLtiEngine
  class AssignmentData < ActiveRecord::Base
    belongs_to :assignment
    serialize :data, Hash
  end
end
