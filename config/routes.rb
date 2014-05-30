LearnLtiEngine::Engine.routes.draw do
  namespace :api do
    resources :activities
  end
  post "embed" => "lti#embed", as: :lti_embed
  match  "launch" => "lti#launch", as: :launch, via: [:get, :post]
  get "config(.xml)" => "lti#xml_config", as: :lti_xml_config
  get "health_check" => "lti#health_check"
  match "/" => "lti#index", via: [:get, :post]
  root "lti#index"
  get "test/backdoor"
end
