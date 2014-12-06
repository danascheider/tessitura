@tasks
Feature: Get tasks

  In order to know what I need to do today
  As an android
  I need to see my tasks in a properly serialized JSON format.

  Scenario Outline: Authorized user views incomplete tasks of a single user
    When the client submits a GET request to /users/2/tasks with the <id> user's credentials
    Then the JSON response should include the 2nd user's incomplete tasks
    And the response should return status 200

    Examples:
      | id  |
      | 2nd |
      | 1st |

  Scenario Outline: Authorized user views all tasks of a single user
    When the client submits a GET request to /users/2/tasks/all with the <id> user's credentials
    Then the JSON response should include all the 2nd user's tasks
    And the response should return status 200
    
    Examples:
      | id  |
      | 2nd |
      | 1st |

  Scenario Outline: Authorized user views single task
    When the client submits a GET request to /tasks/6 with the <id> user's credentials
    Then the JSON response should include the 6th task
    And the response should return status 200

    Examples:
      | id  |
      | 2nd |
      | 1st |

  Scenario Outline: Unauthorized user attempts to view task(s)
    When the client submits a GET request to <url> with <type> credentials
    Then the response should not include any data
    And the response should indicate the request was unauthorized

    Examples:
      | url                | type           |
      | /users/2/tasks     | the 3rd user's |
      | /users/2/tasks     | no             |
      | /users/2/tasks/all | the 3rd user's |
      | /users/2/tasks/all | no             |
      | /tasks/1           | the 2nd user's |
      | /tasks/1           | no             |

  Scenario: Try to get information about a task that doesn't exist
    When the client submits a GET request to /tasks/10000000 with the 1st user's credentials 
    Then the response should indicate the task was not found

  Scenario: Authorized user has no tasks
    Given the 4th user has no tasks
    When the client submits a GET request to /users/4/tasks with the 4th user's credentials
    Then the response should include an empty JSON object
    And the response should return status 200