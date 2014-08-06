Feature: View user profile

  Scenario Outline: Authorized user views profile
    When the client submits a GET request to /users/3 with the <id> user's credentials
    Then the JSON response should include the 3rd user's profile information
    And the response should return status 200

    Examples:
      | id  |
      | 3rd |
      | 1st |

  Scenario Outline: Unauthorized user tries to view profile
    When the client submits a GET request to /users/3 with <type> credentials
    Then the response should not include any data
    And the response should indicate the request was unauthorized

    Examples:
      | type           |
      | the 2nd user's | 
      | no             |

  Scenario Outline: Viewing all users (admin only)
    When the client submits a GET request to <url> with <type> credentials
    Then the <clause>
    And the response should return status <code>

    Examples:
      | url          | type           | clause                                     | code |
      | /users       | the 3rd user's | response should not include any data       | 405  |
      | /admin/users | the 3rd user's | response should not include any data       | 401  |
      | /admin/users | no             | response should not include any data       | 401  |
      | /admin/users | the 1st user's | JSON response should include all the users | 200  |

  Scenario: Admin attempts to view user that doesn't exist
    When the client submits a GET request to /users/1000000 with the 1st user's credentials
    Then the response should not include any data
    And the response should return status 404