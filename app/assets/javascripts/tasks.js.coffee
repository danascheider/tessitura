# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.

$ ->
  $('.mark-complete').click (e) ->
    e.stopPropagation()
    this.parentsUntil(ul).fadeOut()

  $('li.todo-list-item').click (e) ->
    e.preventDefault()
    details = $(this).find('tr.task-details')
    details.toggleClass('visible')
    details.toggle()