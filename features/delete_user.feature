Feature: Delete user account

  Background:
    Given there are users with the following attributes:
      | id | email             | username | password    | admin |
      | 1  | admin@example.com | admin1   | adminpasswd | true  |
      | 2  | user2@example.com | abc123   | abcde12345  | false |
      | 3  | user3@example.com | bcd234   | bcdef23456  | false |
    And each user has 3 tasks

  Scenario: User deletes own account
    When the client submits a DELETE request to /users/3 with the 3rd user's credentials
    Then the user should be deleted from the database
    And the response should indicate the user was deleted successfully

  Scenario: Admin deletes user's account
    When the client submits a DELETE request to /users/3 with the 1st user's credentials
    Then the user should be deleted from the database
    And the response should indicate the user was deleted successfully

  Scenario: User attempts to delete someone else's account
    When the client submits a DELETE request to /users/2 with the 3rd user's credentials
    Then the user should not be deleted from the database
    And the response should indicate the request was unauthorized

  Scenario: User attempts to delete account without authenticating
    When the client submits a DELETE request to /users/2 with no credentials
    Then the user should not be deleted from the database
    And the repsonse should indicate the request was unauthorized