LearnLtiEngine.PostParamsIndexRoute = Ember.Route.extend({
  beforeModel: function() {
    var assignment = this.modelFor('post_params');
    var step = assignment.get('steps.firstObject');
    assignment.setActiveStep(step.name);
    this.transitionTo('post_params.lti_message_type');
  }
});
