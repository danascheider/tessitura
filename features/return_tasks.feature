Feature: Return task information

  In order to know what I need to do today
  As an android
  I need to see my tasks in JSON format.

  Background:
    Given there are the following tasks:
      |id | title              | complete |
      | 1 | Take out the trash | false    |
      | 2 | Walk the dog       | false    |
 
  Scenario: List tasks
    When the client requests GET /tasks
    Then the JSON response should include all the tasks

  Scenario: Get information about a specific task
    When the client requests GET /tasks/1
    Then the JSON response should include only the first task
