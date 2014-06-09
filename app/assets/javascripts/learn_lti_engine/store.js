LearnLtiEngine.ApplicationStore = DS.Store.extend({

});

// Override the default adapter with the `DS.ActiveModelAdapter` which
// is built to work nicely with the ActiveModel::Serializers gem.
LearnLtiEngine.ApplicationAdapter = DS.ActiveModelAdapter.extend({
  namespace: 'learn_lti_engine/api'
});

LearnLtiEngine.ArrayTransform = DS.Transform.extend({
  serialize: function(value) {
    if (Em.typeOf(value) === 'array') {
      return value;
    } else {
      return [];
    }
  },
  deserialize: function(value) {
    switch (Em.typeOf(value)) {
      case 'array':
        return value;
      case 'string':
        return value.split(',').map(function(item) {
          return jQuery.trim(item);
        });
      default:
        return [];
    }
  }
});