@users
Feature: Create a new user

  Scenario: Normal user creation
    When the client submits a POST request to /users with:
      """
      { "email":"jdoe@example.com", "username":"johndoe3", "password":"johnspassword", "first_name":"John", "last_name":"Doe" }
      """
    Then a new user should be created with the following attributes:
      | username  | password      | email            | first_name | last_name | admin |
      | johndoe3  | johnspassword | jdoe@example.com | John       | Doe       | false |
    And the response should indicate the user was saved successfully

  Scenario: Assigning a valid fach
    When the client submits a POST request to /users with:
      """
        {"email":"jdoe@example.com", "username":"janedoe3", "password":"janespassword", "first_name":"Jane", "last_name":"Doe", "fach":{"type":"soprano", "quality":"lyric","coloratura":true}}
      """
    Then a new user should be created with the following attributes:
      | username | password      | email            | first_name | last_name | fach_id | admin |
      | janedoe3 | janespassword | jdoe@example.com | Jane       | Doe       | 1       | false |

  Scenario: Unauthorized attempt to create an admin
    When the client submits a POST request to /users with:
      """
      { "email":"fj@example.com", "username":"frankthegreat", "password":"callmefrank", 
      "country":"Canada", "admin":"true" }
      """
    Then no user should be created
    And the response should indicate the request was unauthorized

  Scenario: Attempt to create a user without valid attributes
    When the client submits a POST request to /users with:
      """
      { "first_name":"Erin", "last_name":"Baumgartner" }
      """
    Then no user should be created
    And the response should indicate the user was not saved successfully