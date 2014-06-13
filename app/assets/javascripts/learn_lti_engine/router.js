// For more information see: http://emberjs.com/guides/routing/

LearnLtiEngine.Router.map(function() {
  this.resource('assignment', { path: '/:assignment_name' }, function() {
    this.route('step', { path: '/:name' });
  });
//  this.route('step', { path: '/:name' });
//  this.route('post_param', { path: '/post_param/:step' });
//    this.route('lti_message_type');
//    this.route('lti_version');
//    this.route('resource_link_id');
//    this.route('context_id');
//    this.route('user_id');
//    this.route('roles');
//    this.route('oauth_consumer_key');
//    this.route('oauth_nonce');
//    this.route('oauth_timestamp');
//    this.route('oauth_signature');
//  });
});
