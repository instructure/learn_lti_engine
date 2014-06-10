LearnLtiEngine.AssignmentStepRoute = Ember.Route.extend({
  model: function(params) {
    return this.modelFor('assignment').get('steps').findBy('name', params.name);
  },

  setupController: function(controller, model) {
    this._super.apply(this, arguments);
    this.modelFor('assignment').setActiveStep(model.get('name'));
  }
});
