module LearnLtiEngine
  class StepData < ActiveRecord::Base
    belongs_to :assignment
    serialize :data, Hash
  end
end
