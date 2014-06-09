LearnLtiEngine.PostParamsRoute = Ember.Route.extend({
  model: function(params) {
    var assignmentParams = {
      name              : 'post_params',
      lti_user_id       : Ember.ENV.LAUNCH_PARAMS['user_id'],
      lti_assignment_id : Ember.ENV.LAUNCH_PARAMS['lis_result_sourcedid']
    };

    // Transition to the correct assignment
    return this.store.find('assignment', assignmentParams).then(function(data) {
      var assignment = data.get('firstObject');
      var currentStep = this.router.get('location.location.hash').split('/').get('lastObject');
      assignment.addSteps([
        'lti_message_type', 'lti_version', 'resource_link_id', 'context_id',
        'user_id', 'roles', 'oauth_consumer_key', 'oauth_nonce',
        'oauth_timestamp', 'oauth_signature'
      ], currentStep);
      return assignment;
    }.bind(this));
  },

  actions: {
    goToStep: function(step) {
      this.get('controller.model').setActiveStep(step.name);
      this.transitionTo('post_params.' + step.name);
    }
  }
});
