module LearnLtiEngine
  class User < ActiveRecord::Base
    has_many :assignments
    validates :lti_user_id, presence: true, uniqueness: true
  end
end
