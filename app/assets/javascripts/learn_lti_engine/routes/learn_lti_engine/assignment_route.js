LearnLtiEngine.AssignmentRoute = Ember.Route.extend({
  model: function(params) {
    this.transitionTo(Ember.ENV.LAUNCH_PARAMS['assignment_name']);
    return false;
  }
});
