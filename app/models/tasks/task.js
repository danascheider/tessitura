// Create Task model in Backbone. This is connected to ActiveRecord
// to create a persistent Task model.

Task = Backbone.Model.extend({

  // FIX-ME: Obviously this can't point to localhost
  //         in production.
  urlRoot: '/tasks'
});

var TodoList = Backbone.collection.extend({model: Task});