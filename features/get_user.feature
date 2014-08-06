Feature: View user profile

  Scenario: User views their own profile
    When the client submits a GET request to /users/3 with the 3rd user's credentials
    Then the JSON response should include the 3rd user's profile information
    And the response should return status 200

  Scenario: Admin views user's profile
    When the client submits a GET request to /users/3 with the 1st user's credentials
    Then the JSON response should include the 3rd user's profile information 
    And the response should return status 200

  Scenario: User tries to view another user's profile
    When the client submits a GET request to /users/3 with the 2nd user's credentials
    Then the response should not include any data
    And the response should return status 401

  Scenario: User tries to view a profile without credentials
    When the client submits a GET request to /users/3 with no credentials
    Then the response should not include any data
    And the response should return status 401

  Scenario: User tries to view all users over the regular user route
    When the client submits a GET request to /users with the 3rd user's credentials
    Then the response should not include any data
    And the response should return status 405

  Scenario: User tries to view all users with inadequate credentials
    When the client submits a GET request to /admin/users with the 3rd user's credentials
    Then the response should not include any data
    And the response should return status 401

  Scenario: User tries to view all users with no credentials
    When the client submits a GET request to /admin/users with no credentials
    Then the response should not include any data
    And the response should return status 401

  Scenario: Admin views all users
    When the client submits a GET request to /admin/users with the 1st user's credentials
    Then the JSON response should include all the users
    And the response should return status 200

  Scenario: Admin attempts to view user that doesn't exist
    When the client submits a GET request to /users/1000000 with the 1st user's credentials
    Then the response should not include any data
    And the response should return status 404