Feature: Get tasks

  In order to know what I need to do today
  As an android
  I need to see my tasks in JSON format.

  Background:
    Given there are users with the following attributes:
      | id | email             | username | password    | admin |
      | 1  | admin@example.com | admin1   | adminpasswd | true  |
      | 2  | user2@example.com | abc123   | abcde12345  | false |
      | 3  | user3@example.com | bcd234   | bcdef23456  | false |
    And each user has 3 tasks

  Scenario: User views all their tasks
    When the client submits a GET request to /users/2/tasks with the 2nd user's credentials
    Then the JSON response should include all the 2nd user's tasks
    And the response should return status 200

  Scenario: Admin views user's tasks
    When the client submits a GET request to /users/2/tasks with admin credentials
    Then the JSON response should include all the 2nd user's tasks
    And the response should return status 200

  Scenario: User attempts to view other user's tasks
    When the client submits a GET request to /users/2/tasks with the 3rd user's credentials
    Then the response should not include any data
    And the response should indicate the request was unauthorized

  Scenario: User attempts to view tasks without authenticating
    When the client submits a GET request to /users/2/tasks with no credentials
    Then the response should not include any data
    And the response should indicate the request was unauthorized

  Scenario: User views one of their own tasks
    When the client submits a GET request to the last task URL with owner credentials
    Then the JSON response should include the last task
    And the response should return status 200

  Scenario: Admin views one of a user's tasks
    When the client submits a GET request to the last task URL with admin credentials
    Then the JSON response should include the last task
    And the response should return status 200

  Scenario: User attempts to view someone else's task
    When the client submits a GET request to the first task URL with user credentials
    Then the response should not include any data
    And the response should indicate the request was unauthorized

  Scenario: User attempts to view task without authenticating
    When the client submits a GET request to the first task URL with no credentials
    Then the response should not include any data
    And the response should indicate the request was unauthorized

  Scenario: Try to get information about a task that doesn't exist
    When the client submits a GET request to /tasks/10000000 with admin credentials 
    Then the response should indicate the task was not found