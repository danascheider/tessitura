@tasks
Feature: Delete task
  As a user,
  in order to keep my task list clean and manageable,
  I need to delete a task.

  Scenario: User deletes their own task
    When the client submits a DELETE request to /tasks/9 with the 3rd user's credentials
    Then the 9th task should be deleted from the database
    And the response should indicate the task was deleted successfully

  Scenario: Admin deletes user's task
    When the client submits a DELETE request to /tasks/5 with the 1st user's credentials
    Then the 5th task should be deleted from the database
    And the response should indicate the task was deleted successfully

  Scenario: User tries to delete another user's task
    When the client submits a DELETE request to /tasks/2 with the 3rd user's credentials
    Then the 2nd task should not be deleted from the database
    And the response should indicate the request was unauthorized

  Scenario: User tries to delete task without authenticating
    When the client submits a DELETE request to /tasks/4 with no credentials
    Then the 4th task should not be deleted from the database
    And the response should indicate the request was unauthorized

  Scenario: User attempts to exist a task that doesn't exist
    When the client submits a DELETE request to /tasks/1000000 with the 1st user's credentials
    Then the response should indicate the task was not found