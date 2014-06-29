Feature: Return task information

  In order to know what I need to do today
  As an android
  I need to see my tasks in JSON format.

  Scenario: List tasks
    Given there are the following tasks:
      |id | title              | complete |
      | 1 | Take out the trash | false    |
      | 2 | Walk the dog       | false    |
    When the client requests GET /tasks
    Then the JSON response should be:
      """
      [
        {"id": 1, "title": "Take out the trash", "complete": false },
        {"id": 2, "title": "Walk the dog", "complete": false }
      ]
      """
