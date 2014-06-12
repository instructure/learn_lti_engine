LearnLtiEngine.Step = Ember.Object.extend({
  assignment: null,
  name: null,
  isCompleted: null,
  isActive: false,

  partialName: function() {
    return this.get('assignment.name') + '/' + this.get('name');
  }.property('name'),

  getFormParams: function(launchUrl, oauthKey, oauthSecret) {
    var url = "/learn_lti_engine/api/assignments/step_params?step_name=" + this.get('name')
    if (!Ember.isEmpty(launchUrl)) { url += "&launch_url=" + encodeURIComponent(launchUrl); };
    if (!Ember.isEmpty(oauthKey)) { url += "&key=" + oauthKey; };
    if (!Ember.isEmpty(oauthSecret)) { url += "&secret=" + oauthSecret; };
    return $.getJSON(url);
  }
});