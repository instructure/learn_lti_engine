LearnLtiEngine.PostParamsLtiVersionController = Ember.ObjectController.extend({

  iframeData: function() {
    var data = Ember.Object.create(this.getProperties('postParams', 'validateFieldNames'));
    data.set('step', 'lti_message_type');
    data.set('nextRoute', 'post_param.resource_link_id');
    return data;
  }.property('postParams', 'validateFieldNames'),

  loadPostParams: function() {
    $.getJSON('/learn_lti_engine/api/assignments/post_param?p=basic').then(function(data) {
      this.set('postParams', data);
    }.bind(this))
  }.on('init'),

  validateFieldNames: ['lti_version']
});