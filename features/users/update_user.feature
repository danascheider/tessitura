@users
Feature: Updating user profiles

  Scenario Outline:
    When the client submits a PUT request to /users/<id> with the <num1> user's credentials and:
      """
      { "<attribute>":"<value>" } 
      """
    Then the <num2> user's <attribute> should be changed to <value>
    And the response should indicate the user was updated successfully

      Examples: 
        | id | num1 | attribute | value          | num2 |
        | 3  | 3rd  | fach      | lyric baritone | 3rd  |
        | 3  | 1st  | fach      | heldentenor    | 3rd  | 

  Scenario: User updates their own profile with invalid attributes
    When the client submits a PUT request to /users/3 with the 3rd user's credentials and:
      """
      { "username":null }
      """
    Then the user's username should not be changed
    And the response should indicate the user was not updated successfully

  Scenario Outline: Unauthorized user tries to update a profile
    When the client submits a PUT request to /users/3 with <type> credentials and:
      """
      { "<attribute>":"<value>" }
      """
    Then the user's <attribute> should not be changed
    And the response should indicate the request was unauthorized

    Examples:
      | type           | attribute  | value |
      | the 2nd user's | first_name | Jerry |
      | no             | country    | Togo  |

  Scenario Outline: Changing a user's admin status
    When the client submits a PUT request to /users/3 with the <id> user's credentials and:
      """
      { "admin":true }
      """
    Then the 3rd user should <neg> be an admin
    And the response should indicate <result>

    Examples:
      | id  | neg | result                            |
      | 3rd | not | the request was unauthorized      |
      | 1st | yes | the user was updated successfully |

  Scenario: Admin attempts to update a profile that doesn't exist
    When the client submits a PUT request to /users/1000000 with the 1st user's credentials and:
      """
      { "city":"Mexico City" }
      """
    Then the response should return status 404