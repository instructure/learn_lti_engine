LearnLtiEngine.PostParamsLtiMessageTypeController = Ember.ObjectController.extend({
  iframeData: function() {
    var data = Ember.Object.create(this.getProperties('postParams', 'validateFieldNames'));
    data.set('step', 'lti_message_type');
    data.set('nextRoute', 'post_params.lti_version');
    return data;
  }.property('postParams', 'validateFieldNames'),

  loadPostParams: function() {
    $.getJSON('/learn_lti_engine/api/assignments/post_params?p=basic').then(function(data) {
      this.set('postParams', data);
    }.bind(this))
  }.on('init'),

  validateFieldNames: ['lti_message_type', 'lti_version']
});