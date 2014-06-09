LearnLtiEngine.BasePostParamsController = Ember.Controller.extend({
  needs: ['post_params'],
  postParams: Ember.computed.alias('controllers.post_params.postParams')
});
