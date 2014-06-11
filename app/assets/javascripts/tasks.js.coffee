# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.

$ ->
  $(".mark-complete").click (e) ->
    e.stopPropagation()

    parent_li = $(this).closest "li"
    id = parent_li.attr("id").match /\d+/

    $.ajax ->
      async: true
      url: "/tasks/" + id + "/complete"
      type: "POST"
      dataType: "script"
      success: ->
        $(this).parentsUntil('ul').fadeOut()
      error:
        console.log("That asynchronous thing didn't work out so well")

  $('li.todo-list-item').click (e) ->
    e.preventDefault()
    details = $(this).find "div.task-details"
    details.toggleClass "visible"
    details.slideToggle()

  $('.ajax-edit-link').click (e) ->
    e.stopPropagation()
    $(this).parents('.task-info').hide
    $(this).siblings('.edit-form').show