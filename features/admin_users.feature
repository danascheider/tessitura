Feature: Admin users
  Scenario: Invalid attempt to make user an admin
    Given there are users with the following attributes:
      | id | email             | username  | password    | admin |
      | 1  | admin@example.com | abc123    | abcde12345  | true  |
      | 2  | user2@example.com | bcd234    | bcdef23456  | false |
    When the client submits a PUT request to /users/2 with:
      """json
      { "secret_key":"12345abcde2", "admin":"true"}
      """
    Then the 2nd user should not be an admin
    And the response should return status 401

  Scenario: Give a user admin privileges
    Given there are users with the following attributes:
      | id | email             | secret_key  | admin |
      | 1  | admin@example.com | 12345abcde1 | true  |
      | 2  | user2@example.com | 12345abcde2 | false |
    When the client submits a PUT request to /users/2 with:
      """json
      { "secret_key":"12345abcde1", "admin":"true" }
      """
    Then the 2nd user should be an admin
    And the response should return status 200