Feature: Create task
  In order to stay on top of my tasks
  As a user
  I need to create a new task

  Background:
    Given there are users with the following attributes:
      | id | email             | username | password    | admin |
      | 1  | admin@example.com | admin1   | adminpasswd | true  |
      | 2  | user2@example.com | abc123   | abcde12345  | false |
      | 3  | user3@example.com | bcd234   | bcdef23456  | false |
    And each user has 3 tasks

  Scenario: User creates a valid task
    When the client submits a POST request to users/2/tasks with the 2nd user's credentials and:
      """json
      { "title":"Water the plants" }
      """
    Then a new task should be created on the 2nd user's task list 
    And the new task should have the following attributes:
      | title            | status | deadline | priority | description |
      | Water the plants | new    | nil      | normal   | nil         |
    And the response should indicate the task was saved successfully

  Scenario: User attempts to create an invalid task
    When the client submits a POST request to users/2/tasks with the 2nd user's credentials and:
      """json
      { "status":"blocking" }
      """
    Then no task should be created
    And the response should indicate the task was not saved successfully

  Scenario: User attempts to create a task for someone else
    When the client submits a POST request to users/2/tasks with the 3rd user credentials and:
      """json
      { "title":"Water the plants" }
      """
    Then no task should be created
    And the response should indicate the request was unauthorized

  Scenario: User attempts to create a task without a secret key
    When the client submits a POST request to users/2/tasks with:
      """json
      { "title":"Water the plants" }
      """
    Then no task should be created
    And the response should indicate that the request was unauthorized

  Scenario: Admin creates a task for a user
    When the client submits a POST request to users/3/tasks with:
      """json
      { "secret_key":"12345abcde1", "title":"Water the plants" }
      """
    Then a new task should be created on the 3rd user's task list
    And the task should have the following attributes:
      | user_id | title            | status | deadline | priority | description |
      | 3       | Water the plants | new    | nil      | normal   | nil         |
    And the response should indicate the task was saved successfully