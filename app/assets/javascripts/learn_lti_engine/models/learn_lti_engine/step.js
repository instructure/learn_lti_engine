LearnLtiEngine.Step = Ember.Object.extend({
  assignment: null,
  name: null,
  isCompleted: null,
  isActive: false,

  partialName: function() {
    return this.get('assignment.name') + '/' + this.get('name');
  }.property('name'),

  getFormParams: function() {
    return $.getJSON('/learn_lti_engine/api/assignments/step_params?step_name=' + this.get('name'));
  }
});