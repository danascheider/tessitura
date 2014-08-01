Feature: Admin users
  Background:
    Given there are users with the following attributes:
      | id | email             | username  | password    | admin |
      | 1  | admin@example.com | abc123    | abcde12345  | true  |
      | 2  | user2@example.com | bcd234    | bcdef23456  | false |

  Scenario Outline: Creating an admin user
    When the client submits a POST request to <url> with <type> credentials and:
      """json
      { "username":"cde345", "password":"cdefg34567", "email":"user3@example.com", "admin":"true" }
      """
    Then <article> user should be created
    And the response should return status <status>

    Examples:
    | url          | type   | article | status |
    | /users       | user   |    no   |  401   |
    | /admin/users | admin  |    a    |  201   | 
    | /admin/users | user   |    no   |  401   |
    | /admin/users | no     |    no   |  401   |

  Scenario Outline: Making a user an admin
    When the client submits a PUT request to /admin/users/2 with admin credentials and:
      """json
      { "admin":"true" }
      """
    Then the 2nd user should <negation> be an admin
    And the response should return status <status>

    Examples:
      | type  | negation | status |
      | admin |          | 200    |
      | user  |   not    | 401    |
      | no    |   not    | 401    |

  Scenario Outline: Deleting an admin account 
    And there is a user with the following attributes:
      | id | email              | username | password  |
      | 3  | admin2@example.com | admin2   | admin2pwd |
    When the client submits a DELETE request to /users/3 with the <id> user's credentials
    Then the 3rd user should be deleted
    And the response should return status 201

    Examples:
      | id  |
      | 3rd |
      | 1st |