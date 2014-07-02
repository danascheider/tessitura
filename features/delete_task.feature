Feature: Delete task
  As a user,
  in order to keep my task list clean and manageable,
  I need to delete a task.

  Background: 
    Given there are the following tasks:
      | title                 | complete |
      | Call mom              | false    |
      | RSVP to Kim's wedding | false    |

  Scenario: User deletes a task
    When the client submits a DELETE request to /tasks/1
    Then the 1st task should be deleted from the database
    And the response should indicate the task was deleted successfully

  Scenario: User attempts to exist a task that doesn't exist
    When the client submits a DELETE request to /tasks/5
    Then the response should indicate the task was not found