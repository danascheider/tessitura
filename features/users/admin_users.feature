@users
Feature: Admin users

  Scenario Outline: Creating an admin user
    When the client submits a POST request to <url> with <type> credentials and:
      """json
      { "username":"defg4567", "password":"defgh45678", "email":"user4@example.com", "admin":"true" }
      """
    Then <article> new user should be created with the following attributes:
      | username   | password   | email             | admin |
      | defg4567   | defgh45678 | user4@example.com | true  |
    And the response should return status <status>

    Examples:
      | url          | type           | article | status |
      | /users       | the 3rd user's |    no   |  401   |
      | /admin/users | the 1st user's |    a    |  201   | 
      | /admin/users | the 3rd user's |    no   |  401   |
      | /admin/users | no             |    no   |  401   |

  Scenario Outline: Making a user an admin
    When the client submits a PUT request to /users/3 with <type> credentials and:
      """json
      { "admin":"true" }
      """
    Then the 3rd user should <negation> be an admin
    And the response should return status <status>

    Examples:
      | type           | negation | status |
      | the 1st user's |   yes    | 200    |
      | the 3rd user's |   not    | 401    |
      | no             |   not    | 401    |

  Scenario: Deleting the last admin account 
    When the client submits a DELETE request to /users/1 with the 1st user's credentials
    Then the 1st user should not be deleted
    And the response should return status 403