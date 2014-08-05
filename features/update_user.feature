Feature: Updating user profiles
  
  Background:
    Given there are users with the following attributes:
      | id | email             | username | password    | admin |
      | 1  | admin@example.com | admin1   | adminpasswd | true  |
      | 2  | user2@example.com | abc123   | abcde12345  | false |
      | 3  | user3@example.com | bcd234   | bcdef23456  | false |
    And each user has 3 tasks

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

  Scenario: User attempts to update someone else's profile
    When the client submits a PUT request to /users/3 with the 2nd user's credentials and:
      """json
      { "first_name":"Jerry" }
      """
    Then the user's first_name should not be changed
    And the response should indicate the request was unauthorized

  Scenario: User attempts to update profile without authenticating
    When the client submits a PUT request to /users/3 with no credentials and:
      """json
      { "country":"Togo" }
      """
    Then the user's country should not be changed
    And the response should indicate the request was unauthorized

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
    When the client submits a PUT request to /users/1000000 with admin credentials and
      """json
      { "city":"Mexico City" }
      """
    Then the response should return status 404