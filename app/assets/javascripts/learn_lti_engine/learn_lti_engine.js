//= require_self
//= require ./store
//= require_tree ./mixins
//= require_tree ./models
//= require_tree ./controllers
//= require_tree ./views
//= require_tree ./helpers
//= require_tree ./components
//= require_tree ./templates
//= require ./router
//= require_tree ./routes

$(document).foundation();

$.ajaxSetup({
  headers: { 'Authorization': 'Bearer ' + Ember.ENV.LAUNCH_PARAMS['lis_result_sourcedid'] }
});

// for more details see: http://emberjs.com/guides/application/
LearnLtiEngine = Ember.Application.create({
  rootElement: '#ember-app',
  lastLaunchUrl: null,

  resolver: Ember.DefaultResolver.extend({
    resolveTemplate: function(parsedName) {
      parsedName.fullNameWithoutType = "learn_lti_engine/" + parsedName.fullNameWithoutType;
      return this._super(parsedName);
    }
  })
});