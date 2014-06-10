LearnLtiEngine.AssignmentRoute = Ember.Route.extend({
  model: function(params) {
    return this.store.find('assignment', 'current').then(function(data) {
      var assignment = data;
      assignment.addSteps(Ember.ENV.ASSIGNMENT['tasks'], null);
      return assignment;
    }.bind(this));
  },

  serialize: function(model) {
    return Ember.Object.create({
      assignment_name: model.get('name')
    });
  },

  actions: {
    goToStep: function(step) {
      var assignment = this.get('controller.model');
      assignment.setActiveStep(step.get('name'));
      this.transitionTo('assignment.step', assignment, step);
    }
  }
});
