Feature: Updating user profiles

  Scenario Outline:
    When the client submits a PUT request to /users/<id> with the <num1> user's credentials and:
      """json
      { "<attribute>":"<value>" } 
      """
    Then the <num2> user's <attr> should be changed to <new_val>
    And the response should indicate the user was updated successfully

      Examples: 
        | id | num1 | attribute | value          | num2 | attr | new_val        |
        | 3  | 3rd  | fach      | lyric baritone | 3rd  | fach | lyric baritone |
        | 3  | 1st  | fach      | heldentenor    | 3rd  | fach | heldentenor    |  

  Scenario: User updates their own profile with invalid attributes
    When the client submits a PUT request to /users/3 with the 3rd user's credentials and:
      """json
      { "username":null }
      """
    Then the user's username should not be changed
    And the response should indicate the user was not updated successfully

  Scenario Outline: Unauthorized user tries to update a profile
    When the client submits a PUT request to /users/3 with <type> credentials and:
      """json
      { "<attribute>":"<value>" }
      """
    Then the user's <attr> should not be changed
    And the response should indicate the request was unauthorized

    Examples:
      | type           | attribute  | value | attr       |
      | the 2nd user's | first_name | Jerry | first_name |
      | no             | country    | Togo  | country    |

  Scenario: User attempts to confer admin status on self
    When the client submits a PUT request to /users/3 with the 3rd user's credentials and:
      """json
      { "admin":true }
      """
    Then the 3rd user should not be an admin
    And the response should indicate the request was unauthorized

  Scenario: Admin confers admin status on user
    When the client submits a PUT request to /users/3 with the 1st user's credentials and:
      """json
      { "admin":true }
      """
    Then the 3rd user should be an admin
    And the response should indicate the user was updated successfully

  Scenario: Admin attempts to update a profile that doesn't exist
    When the client submits a PUT request to /users/1000000 with the 1st user's credentials and:
      """json
      { "city":"Mexico City" }
      """
    Then the response should return status 404