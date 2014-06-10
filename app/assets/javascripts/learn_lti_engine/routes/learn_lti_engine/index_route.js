LearnLtiEngine.IndexRoute = Ember.Route.extend({
  setupController: function() {
    // load assignment and steps for assignment, then redirect to last incomplete step
    this.store.find('assignment', 'current').then(function(data) {
      var assignment = data;
      assignment.addSteps(Ember.ENV.ASSIGNMENT['tasks'], null);
      this.transitionTo('assignment.step', assignment, assignment.get('currentStep'));
    }.bind(this));
  }
});
