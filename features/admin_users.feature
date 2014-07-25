Feature: Admin users
  Scenario: Create an initial user
    Given there are no users
    When the client submits a POST request to /users with:
      """json
      { "email":"user1@example.com", "first_name":"Jane", 
      "last_name":"Doe", "country":"USA" }
      """
    Then a user named 'Jane Doe' should be created
    And the user should be an admin

  Scenario: Invalid attempt to make user an admin
    Given there are 2 users
    When the client submits a PUT request to /users/2 with:
      """json
      { "secret_key":"12345abcde2", "admin":"true"}
      """
    Then the 2nd user should not be an admin
    And the response should return status 401

  Scenario: Give a user admin privileges
    Given there are 2 users
    When the client submits a PUT request to /users/2 with:
      """json
      { "secret_key":"12345abcde1", "admin":"true" }
      """
    Then the 2nd user should be an admin
    And the response should return status 200