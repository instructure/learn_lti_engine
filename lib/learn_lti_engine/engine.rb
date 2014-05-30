module LearnLtiEngine
  class Engine < ::Rails::Engine
    isolate_namespace LearnLtiEngine

    config.handlebars = ActiveSupport::OrderedOptions.new
    config.ember = ActiveSupport::OrderedOptions.new

    config.handlebars.templates_root = "learn_lti_engine/templates"
    config.ember.variant = :development

    # config.before_initialize do |app|
    #   Sprockets::Engines #force autoloading
    #   Sprockets.register_engine '.handlebars', Handlebars::Template
    #   Sprockets.register_engine '.hbs', Handlebars::Template
    # end

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
