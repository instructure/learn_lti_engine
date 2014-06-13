LearnLtiEngine.BasePostParamsController = Ember.Controller.extend({
  needs: ['post_param'],
  postParams: Ember.computed.alias('controllers.post_param.postParams')
});
