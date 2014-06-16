LearnLtiEngine.MultiButtonSelectComponent = Ember.Component.extend({
  value: null,

  layout: Ember.Handlebars.compile('<div class="button-bar">' +
    '<ul class="button-group radius">' +
    '  <li><a href="#" {{action "choose" 1}} {{bind-attr class=":tiny :button isTrue:success:secondary"}}>Yes</a></li>' +
    '  <li><a href="#" {{action "choose" 0}} {{bind-attr class=":tiny :button isFalse:success:secondary"}}>No</a>' +
    '      <input type="hidden" {{bind-attr name=name value=value}} /></li>' +
    '</ul>' +
  '</div>'),

  isTrue: function() {
    return this.get('value') === 1;
  }.property('value'),

  isFalse: function() {
    return this.get('value') === 0;
  }.property('value'),

  actions: {
    choose: function(val) {
      this.set('value', val);
    }
  }
});
