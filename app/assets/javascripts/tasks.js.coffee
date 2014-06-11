# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.

toggleDisplayContent = (el1, el2) ->
  el1.hide()
  el2.show()

$ ->
  # Mark-complete functionality 
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
        console.log("That Ajax thing? Yeah, that didn't work so well.")

  # Display/hide task details when li is clicked in list view
  $('li.todo-list-item').click (e) ->
    e.preventDefault()
    details = $(this).find "div.task-details"
    details.toggleClass "visible"
    details.slideToggle()

  # Hide task details and show edit form when edit link clicked
  $('.ajax-edit-link').click (e) ->
    e.stopPropagation()
    taskInfo = $(this).parents('.task-info')
    editForm = $(this).next('.edit-form')
    toggleDisplayContent(taskInfo, editForm)