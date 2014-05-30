$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "learn_lti_engine/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "learn_lti_engine"
  s.version     = LearnLtiEngine::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of LearnLtiEngine."
  s.description = "TODO: Description of LearnLtiEngine."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.1.0"

  s.add_development_dependency "sqlite3"

  s.add_dependency "ims-lti"


  s.add_development_dependency "rspec-rails"

  s.add_development_dependency "capybara"

  s.add_development_dependency "poltergeist"

end
