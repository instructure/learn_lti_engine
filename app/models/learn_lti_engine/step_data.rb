module LearnLtiEngine
  class StepData < ActiveRecord::Base
    belongs_to :assignment
    serialize :data, Hash

    before_save :set_uuid

    private

    def set_uuid
      self.uuid ||= SecureRandom.uuid
    end
  end
end
