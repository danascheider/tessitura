Feature: Delete task
  As a user,
  in order to keep my task list clean and manageable,
  I need to delete a task.

  Scenario: User deletes a task
    Given there are the following tasks:
      | title                 | complete |
      | Call mom              | false    |
      | RSVP to Kim's wedding | false    |
    When the client sends a DELETE request to /tasks/1
    Then the 1st task should be deleted from the database
    And the response should indicate the task was deleted successfully