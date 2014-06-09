// For more information see: http://emberjs.com/guides/routing/

LearnLtiEngine.Router.map(function() {
  this.route('assignment', { path: '/' });
  this.resource('post_params', { path: '/post_params' }, function() {
    this.route('lti_message_type');
    this.route('lti_version');
    this.route('resource_link_id');
    this.route('context_id');
    this.route('user_id');
    this.route('roles');
    this.route('oauth_consumer_key');
    this.route('oauth_nonce');
    this.route('oauth_timestamp');
    this.route('oauth_signature');
  });
});
