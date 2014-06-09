// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function() {
  $("li.todo-list-item").click(function() {
    $(this).children(".task-details").css("display", "inherit");
  });
});