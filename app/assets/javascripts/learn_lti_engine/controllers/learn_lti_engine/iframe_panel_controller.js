LearnLtiEngine.IframePanelController = Ember.ObjectController.extend({
  needs: 'assignment',
  status: null,
  launchUrl: null,

  isCompleted: function() {
    return this.get('status') == 'completed';
  }.property('status'),

  isIncorrect: function() {
    return this.get('status') == 'incorrect';
  }.property('status'),

  isRepeat: function() {
    return this.get('status') == 'repeat';
  }.property('status'),

  populateLaunchUrl: function() {
    var url = $.cookie('iframeLaunchUrl');
    if (Ember.isEmpty(url)) {
      url = LearnLtiEngine.get('lastLaunchUrl');
    }
    this.set('launchUrl', url);
  }.on('didInsertElement'),

  saveDefaults: function(launchUrl) {
    $.cookie('iframeLaunchUrl', launchUrl);
    LearnLtiEngine.set('lastLaunchUrl', launchUrl);
  },

  actions: {
    launch: function() {
      if (!Ember.isEmpty(this.get('launchUrl'))) {
        this.set('status', '');
        this.saveDefaults(this.get('launchUrl'));
        var form = $('#lti-launch-form');
        form.attr('action', this.get('launchUrl'));

        // Get post params from Rails
        this.get('model').getFormParams().then(function(data) {
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
