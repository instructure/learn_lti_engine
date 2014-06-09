LearnLtiEngine.Assignment = DS.Model.extend({
  name            : DS.attr('string'),
  isCompleted     : DS.attr('boolean'),
  completedTasks  : DS.attr('array'),
  ltiAssignmentId : DS.attr('number'),
  ltiUserId       : DS.attr('number'),
  steps           : null,

  isPostParams: function() {
    return (this.get('name') === 'post_params');
  }.property('name'),

  isSignatureVerification: function() {
    return (this.get('name') === 'signature_verification');
  }.property('name'),

  isReturnRedirects: function() {
    return (this.get('name') === 'return_redirects');
  }.property('name'),

  isXmlConfiguration: function() {
    return (this.get('name') === 'xml_configuration');
  }.property('name'),

  isReturningContent: function() {
    return (this.get('name') === 'returning_content');
  }.property('name'),

  isGradePassback: function() {
    return (this.get('name') === 'grade_passback');
  }.property('name'),

  addSteps: function(steps, currentStepName) {
    var s = [];
    steps.forEach(function(name) {
      var isCompleted = this.get('completedTasks').contains(name);
      var step = LearnLtiEngine.Step.create({ name: name, isCompleted: isCompleted });
      if (name == currentStepName) {
        step.set('isActive', true);
      }
      s.pushObject(step);
    }.bind(this));
    this.set('steps', s);
  },

  setActiveStep: function(stepName) {
    this.get('steps').forEach(function(s) {
      s.set('isActive', false);
    });
    this.get('steps').findBy('name', stepName).set('isActive', true);
  },

  completeStep: function(stepName) {
    // VERY INSECURE!!!!
    this.get('completedTasks').push(stepName);
    this.save();
  }
});