Feature: Update task

  In order to keep the most current information about my tasks & schedule
  I need to edit my tasks

  Background:
    Given there are users with the following attributes:
      | id | email             | username | password    | admin |
      | 1  | admin@example.com | admin1   | adminpasswd | true  |
      | 2  | user2@example.com | abc123   | abcde12345  | false |
      | 3  | user3@example.com | bcd234   | bcdef23456  | false |
    And each user has 3 tasks

  Scenario: User updates one of their tasks
    When the client submits a PUT request to the last task URL with the 3rd user's credentials and:
      """json
      { "title":"Take Out the Trash" }
      """
    Then the task's title should be changed to 'Take Out the Trash'
    And the response should indicate the task was updated successfully

  Scenario: Admin updates user's task
    When the client submits a PUT request to the last task URL with the 1st user's credentials and:
      """json
      { "title":"Feed the neighbor's cat" }
      """
    Then the task's title should be changed to 'Feed the neighbor\'s cat'
    And the response should indicate the task was updated successfully

  Scenario: User attempts to update someone else's task
    When the client submits a PUT request to the first task URL with the 3rd user's credentials and:
      """json
      { "title":"Feed the neighbor's cat" }
      """
    Then the task's title should not be changed to 'Feed the neighbor\'s cat'
    And the response should indicate the request was unauthorized

  Scenario: User attempts to update a task without authenticating
    When the client submits a PUT request to the last task URL with no credentials and:
      """json
      { "title":"Rescue Princess Peach" }
      """
    Then the task's title should not be changed to 'Rescue Princess Peach'
    And the response should indicate the request was unauthorized

  Scenario: User attempts to update a task that doesn't exist
    When the client submits a PUT request to /tasks/1000000 with admin credentials and:
      """json
      { "status":"complete" }
      """
    Then the response should indicate the task was not found

  Scenario: Attempt to update task with invalid attributes
    When the client submits a PUT request to the first task URL with the 1st user's credentials and:
      """json
      { "title":null }
      """
    Then the task's title should not be changed
    And the response should indicate the task was not updated successfully

  Scenario: Change task status to complete
    Given the 1st user's 3rd task is complete
    When the client submits a PUT request to the first task URL with the 1st user's credentials and:
      """json
      { "status":"complete" }
      """
    Then the task's status should be 'complete'
    And the task should be moved to position 2
    And the response should indicate the task was updated successfully

  Scenario: Change task status to incomplete
    Given the 1st user's 3rd task is complete
    When the client submits a PUT request to that task URL with the 1st users credentials and:
      """json
      { "status":"in_progress" }
      """
    Then the task's status should be 'in_progress'
    And the task should be moved to position 1
    And the response should indicate the task was updated successfully