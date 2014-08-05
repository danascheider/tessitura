@users
Feature: Updating user profiles
  Scenario: User updates their own profile with valid attributes
    When the client submits a PUT request to /users/3 with the 3rd user's credentials and:
      """json
      { "fach":"lyric baritone" }
      """
    Then the 3rd user's fach should be changed to 'lyric baritone'
    And the response should indicate the user was updated successfully

  Scenario: User updates their own profile with invalid attributes
    When the client submits a PUT request to /users/3 with the 3rd user's credentials and:
      """json
      { "username":null }
      """
    Then the user's username should not be changed
    And the response should indicate the user was not updated successfully

  Scenario: Admin updates user's profile
    When the client submits a PUT request to /users/3 with the 3rd user's credentials and:
      """json
      { "fach":"heldentenor" }
      """
    Then the 3rd user's fach should be changed to 'heldentenor'
    And the response should indicate the user was updated successfully

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
    When the client submits a PUT request to /users/3 with admin credentials and:
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