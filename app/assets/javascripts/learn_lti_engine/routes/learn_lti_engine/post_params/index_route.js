LearnLtiEngine.PostParamsIndexRoute = Ember.Route.extend({
  beforeModel: function() {
    var assignment = this.modelFor('post_param');
    var step = assignment.get('steps.firstObject');
    assignment.setActiveStep(step.name);
    this.transitionTo('post_param.lti_message_type');
  }
});
