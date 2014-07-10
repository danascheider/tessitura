Feature: Update task

  In order to keep the most current information about my tasks & schedule
  I need to edit my tasks

  Background:
    Given there are 3 tasks
    And the 3rd task is complete

  Scenario: Successfully change task title
    When the client submits a PUT request to /tasks/1 with:
      """json
      { "title":"Take Out the Trash" }
      """
    Then the task's title should be changed to 'Take Out the Trash'
    And the response should indicate the task was updated successfully

  Scenario: Successfully change status
    When the client submits a PUT request to /tasks/1 with:
      """json
      { "complete":true }
      """
    Then the task should be marked complete
    And the task's position should be changed to 3
    And the response should indicate the task was updated successfully

  Scenario: Attempt to update task with invalid attributes
    When the client submits a PUT request to /tasks/1 with:
      """json
      { "title":null }
      """
    Then the task's title should not be changed
    And the response should indicate the task was not updated successfully