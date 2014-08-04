Feature: Delete task
  As a user,
  in order to keep my task list clean and manageable,
  I need to delete a task.

  Background: 
    Given each user has 3 tasks

  Scenario: User deletes their own task
    When the client submits a DELETE request to the last task URL with the 3rd user's credentials
    Then the last task should be deleted from the database
    And the response should indicate the task was deleted successfully

  Scenario: Admin deletes user's task
    When the client submits a DELETE request to the last task URL with the 1st user's credentials
    Then the last task should be deleted from the database
    And the response should indicate the task was deleted successfully

  Scenario: User tries to delete another user's task
    When the client submits a DELETE request to the first task URL with the 3rd user's credentials
    Then the last task should not be deleted from the database
    And the response should indicate the request was unauthorized

  Scenario: User tries to delete task without authenticating
    When the client submits a DELETE request to the last task URL with no credentials
    Then the last task should not be deleted from the database
    And the response should indicate the request was unauthorized

  Scenario: User attempts to exist a task that doesn't exist
    When the client submits a DELETE request to /tasks/1000000 with admin credentials
    Then the response should indicate the task was not found