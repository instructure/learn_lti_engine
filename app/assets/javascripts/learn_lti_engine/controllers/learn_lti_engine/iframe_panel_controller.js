LearnLtiEngine.IframePanelController = Ember.ObjectController.extend({
  needs: 'assignment',
  status: null,
  launchUrl: null,
  oauthKey: null,
  oauthSecret: null,

  isCompleted: function() {
    return this.get('status') == 'completed';
  }.property('status'),

  isIncorrect: function() {
    return this.get('status') == 'incorrect';
  }.property('status'),

  isRepeat: function() {
    return this.get('status') == 'repeat';
  }.property('status'),

  saveDefaults: function() {
    $.cookie('iframeLaunchUrl', this.get('launchUrl'));
    LearnLtiEngine.set('lastLaunchUrl', this.get('launchUrl'));
    if (this.get('model.assignment.usesOauth')) {
      $.cookie('iframeOauthKey', this.get('oauthKey'));
      $.cookie('iframeOauthSecret', this.get('oauthSecret'));
      LearnLtiEngine.set('lastOauthKey', this.get('oauthKey'));
      LearnLtiEngine.set('lastOauthKey', this.get('oauthSecret'));
    }
  },

  actions: {
    launch: function() {
      if (!Ember.isEmpty(this.get('launchUrl'))) {
        this.set('status', '');
        this.saveDefaults();
        var form = $('#lti-launch-form');
        form.attr('action', this.get('launchUrl'));

        // Get post params from Rails
        this.get('model').getFormParams(this.get('launchUrl'), this.get('oauthKey'), this.get('oauthSecret')).then(function(data) {
          this.set('validationFields', data.validation_fields);
          var formData = data.post_params;
          for (var key in formData) {
            if (formData.hasOwnProperty(key)) {
              form.append('<input type="hidden" name="' + key + '" value="' + formData[key] + '"/>');
            }
          }
          form.submit();
          this.set('isSubmitted', true);
        }.bind(this));
      }
    },

    submitAssignment: function() {
      var formData = jQuery.deparam.querystring($('#submit-assignment-form').serialize());
      formData['step_name'] = this.get('model.name');

      // Submit to rails
      $.ajax({
        type: "POST",
        url: '/learn_lti_engine/api/assignments/step_validation',
        data: formData
      }).then(
        function(results) {
          var status = results.status;
          this.set('status', status);
          this.set('message', results.message);
          if (status == 'completed') {
            var assignment = this.get('controllers.assignment.model');
            assignment.completeStep(this.get('model.name'));
          }
        }.bind(this),
        function(err) {
          debugger;
        }.bind(this)
      );
    },

    goToNextStep: function() {
      var assignment = this.get('controllers.assignment.model');
      this.transitionToRoute('assignment.step', assignment.get('nextStep'));
    }
  }
});
