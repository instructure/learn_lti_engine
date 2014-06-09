LearnLtiEngine.IframePanelController = Ember.ObjectController.extend({
  needs: 'post_params',
  status: null,

  isCompleted: function() {
    return this.get('status') == 'completed';
  }.property('status'),

  isIncorrect: function() {
    return this.get('status') == 'incorrect';
  }.property('status'),
  
  setDefaults: function() {
    this.set('launchUrl', LearnLtiEngine.get('lastLaunchUrl'));
  }.on('didInsertElement'),

  actions: {
    launch: function() {
      if (!Ember.isEmpty(this.get('launchUrl'))) {
        this.set('status', '');
        LearnLtiEngine.set('lastLaunchUrl', this.get('launchUrl'));
        var form     = $('#lti-launch-form'),
            formData = this.get('postParams');
        form.attr('action', this.get('launchUrl'));
        for (var key in formData) {
          if (formData.hasOwnProperty(key)) {
            form.append('<input type="hidden" name="' + key + '" value="' + formData[key] + '"/>');
          }
        }
        form.submit();
        this.set('isSubmitted', true);
      }
    },

    submitAssignment: function() {
      var formData = this.get('postParams'),
          validateFieldNames = this.get('validateFieldNames');
      var isValid = true;
      validateFieldNames.forEach(function(name) {
        var answer = $('form#submit-assignment-form input[name=' + name + ']').val();
        if (answer != formData[name]) {
          isValid = false;
        }
      }.bind(this));
      
      if (isValid) {
        this.set('status', 'completed');
        var assignment = this.get('controllers.post_params.model');
        assignment.completeStep(this.get('step'));
      } else {
        this.set('status', 'incorrect');
      }
    },

    goToNextStep: function() {
      this.transitionToRoute(this.get('nextRoute'));
    }
  }
});
