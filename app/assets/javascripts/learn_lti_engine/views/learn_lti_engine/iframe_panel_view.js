LearnLtiEngine.IframePanelView = Ember.View.extend({
  populateLaunchUrl: function() {
    var url = $.cookie('iframeLaunchUrl');
    if (Ember.isEmpty(url)) {
      url = LearnLtiEngine.get('lastLaunchUrl');
    }
    this.get('controller').set('launchUrl', url);
  }.on('didInsertElement')
});
