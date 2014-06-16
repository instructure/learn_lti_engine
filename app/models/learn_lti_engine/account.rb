module LearnLtiEngine
  class Account < ActiveRecord::Base
    before_save :default_values

    has_many :assignments

    def default_values
      self.lti_key ||= SecureRandom.uuid()
      self.lti_secret ||= SecureRandom.hex(16)
    end

  end
end
