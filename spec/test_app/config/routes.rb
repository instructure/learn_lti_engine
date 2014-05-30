Rails.application.routes.draw do

  mount LearnLtiEngine::Engine => "/learn_lti_engine"
end
