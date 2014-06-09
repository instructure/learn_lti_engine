$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "learn_lti_engine/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "learn_lti_engine"
  s.version     = LearnLtiEngine::VERSION
  s.authors     = ["Eric Berry"]
  s.email       = ["cavneb@gmail.com"]
  s.homepage    = "https://github.com/instructure/learn_lti_engine"
  s.summary     = "TODO: Summary of LearnLtiEngine."
  s.description = "TODO: Description of LearnLtiEngine."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_runtime_dependency "jquery-rails", "~> 3.1.0"
  s.add_runtime_dependency "shoulda-matchers", "~> 2.6.1"
  s.add_dependency "rails", "~> 4.1.0"
  s.add_dependency "ims-lti"
  s.add_dependency "ember-rails"
  s.add_dependency "ember-source", "1.5.0"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "capybara"
  s.add_development_dependency "poltergeist"
  s.add_development_dependency "sass", "~> 3.3.7"
  s.add_development_dependency "foundation-rails"
  s.add_development_dependency "jquery-rails", "~> 3.1.0"
  s.add_development_dependency "shoulda-matchers", "~> 2.6.1"
  s.add_development_dependency "quiet_assets"
end
