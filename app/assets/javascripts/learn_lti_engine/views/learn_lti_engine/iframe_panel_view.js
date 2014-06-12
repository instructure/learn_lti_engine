LearnLtiEngine.IframePanelView = Ember.View.extend({
  populateDefaults: function() {
    var url    = $.cookie('iframeLaunchUrl'),
        key    = $.cookie('iframeOauthKey'),
        secret = $.cookie('iframeOauthSecret');
    if (Ember.isEmpty(url)) { url = LearnLtiEngine.get('lastLaunchUrl'); }
    if (Ember.isEmpty(key)) { key = LearnLtiEngine.get('lastOauthKey'); }
    if (Ember.isEmpty(secret)) { secret = LearnLtiEngine.get('lastOauthSecret'); }
    this.get('controller').set('launchUrl', url);
    this.get('controller').set('oauthKey', key);
    this.get('controller').set('oauthSecret', secret);
  }.on('didInsertElement')
});
