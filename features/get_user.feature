Feature: View user profile

  Background:
    Given there are users with the following attributes:
      | id | email             | username  | password    | admin |
      | 1  | admin@example.com | abc123    | abcde12345  | true  |
      | 2  | user2@example.com | bcd234    | bcdef23456  | false |
      | 3  | user3@example.com | cde345    | cdefg34567  | false |

  Scenario: User views their own profile
    When the client submits a GET request to /users/3 with the 3rd user's credentials
    Then the JSON response should include the 3rd user's profile information
    And the response should return status 200

  Scenario: Admin views user's profile
    When the client submits a GET request to /users/3 with admin credentials
    Then the JSON response should include the 3rd user's profile information 
    And the response should return status 200

  Scenario: User tries to view another user's profile
    When the client submits a GET request to /users/3 with the 2nd user's credentials
    Then the response should return status 401

  Scenario: User tries to view a profile without credentials
    When the client submits a GET request to /users/3 with no credentials
    Then the response should return status 401