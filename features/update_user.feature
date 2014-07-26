Feature: Update user profile

  Background:
    Given there are users with the following attributes:
      | secret_key  | admin | 
      | 12345abcde1 | true  |
      | 12345abcde2 | nil   |
      | 12345abcde3 | nil   |
  
  Scenario: User updates their profile with valid attributes
    When the client submits a PUT request to /users/2 with:
      """json
      { "secret_key":"12345abcde2", "first_name":"Jacob", "email":"jakeman32@example.com" }
      """
    Then the 2nd user should have the following attributes:
      |         email         | first_name |
      | jakeman32@example.com |   Jacob    |
    And the response should indicate the user was updated successfully

  Scenario: User updates their profile with invalid attributes
    When the client submits a PUT request to /users/2 with:
      """json
      { "secret_key":"12345abcde2", "email":"null" }
      """
    Then the 2nd user's profile should not be updated
    And the response should indicate the user was not updated successfully

  Scenario: User attempts to update other user's account
    When the client submits a PUT request to /users/2 with:
      """json
      { "secret_key":"12345abcde3", "email":"joebob@example.com" }
      """
    Then the 2nd user's profile should not be updated
    And the response should indicate the request was unauthorized

  Scenario: Admin updates user's account
    When the client submits a PUT request to /users/2 with:
      """json
      { "secret_key":"12345abcde1", "email":"jakeman32@example.com" }
      """
    Then the 2nd user's email should be changed to 'jakeman32@example.com'
    And the response should indicate the user was updated successfully