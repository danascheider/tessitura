@users
Feature: Create a new user

  Scenario: Normal user creation
    When the client submits a POST request to /users with:
      """json
      { "email":"jdoe@example.com", "username":"johndoe", "password":"johnspassword" }
      """
    Then a new user should be created with the following attributes:
      | username | password      | email            | admin |
      | johndoe  | johnspassword | jdoe@example.com | nil   |
    And the response should indicate the user was saved successfully

  Scenario: Unauthorized attempt to create an admin
    When the client submits a POST request to /users with:
      """json
      { "email":"fj@example.com", "first_name":"Frank", "last_name":"Johnson", 
      "country":"Canada", "admin":"true" }
      """
    Then no user should be created
    And the response should indicate the request was unauthorized

  Scenario: Attempt to create a user without valid attributes
    When the client submits a POST request to /users with:
      """json
      { "first_name":"Erin", "last_name":"Baumgartner" }
      """
    Then no user should be created
    And the response should indicate the user was not saved successfully