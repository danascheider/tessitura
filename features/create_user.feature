Feature: Create a new user

  Background:
    Given there are 2 users

  Scenario: Normal user creation
    When the client submits a POST request to /users with:
      """json
      { "email":"jdoe@example.com", "first_name":"John", "last_name":"Doe",
      "country":"Australia" }
      """
    Then a new user should be created with the following attributes:
      | first_name | last_name | country   | email            | admin |
      | John       | Doe       | Australia | jdoe@example.com | nil   |
    And the response should include an API key for the new user

  Scenario: Unauthorized attempt to create an admin
    When the client submits a POST request to /users with:
      """json
      { "email":"fj@example.com", "first_name":"Frank", "last_name":"Johnson", 
      "country":"Canada", "admin":"true" }
      """
    Then no user should be created
    And the response should indicate the user was not created successfully

  Scenario: Attempt to create a user without valid attributes
    When the client submits a POST request to /users with:
      """json
      { "first_name":"Erin", "last_name":"Baumgartner" }
      """
    Then no user should be created
    And the response should indicate the user was not created successfully