require 'ember-rails'
require 'ims/lti'
require 'oauth/request_proxy/rack_request'

module LearnLtiEngine
  class Engine < ::Rails::Engine
    isolate_namespace LearnLtiEngine

    config.ember = ActiveSupport::OrderedOptions.new
    config.ember.variant = :development

    config.handlebars = ActiveSupport::OrderedOptions.new
    config.handlebars.templates_root = 'learn_lti_engine/templates'
    config.handlebars.precompile = false
    config.handlebars.templates_path_separator = '/'
    config.handlebars.output_type = :global

    config.before_initialize do |app|
      Sprockets::Engines #force autoloading
      Sprockets.register_engine '.handlebars', Ember::Handlebars::Template
      Sprockets.register_engine '.hbs', Ember::Handlebars::Template
      Sprockets.register_engine '.hjs', Ember::Handlebars::Template
    end

    config.generators do |g|
      g.test_framework :rspec
    end

    initializer "learn_lti_engine.assets.precompile" do |app|
      app.config.assets.precompile += %w( learn_lti_engine/ember-app.js )
    end

  end
end
