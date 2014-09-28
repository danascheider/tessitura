@users
Feature: Delete user account

  Scenario Outline: Authorized user deletes account
    When the client submits a DELETE request to /users/<id1> with <type> credentials
    Then the <id2> user should <neg> be deleted
    And the response should indicate <outcome>

    Examples:
      | id1 | type           | id2 | neg | outcome                           |
      | 3   | the 3rd user's | 3rd | yes | the user was deleted successfully |
      | 3   | the 1st user's | 3rd | yes | the user was deleted successfully |
      | 2   | the 3rd user's | 2nd | not | the request was unauthorized      |
      | 2   | no             | 2nd | not | the request was unauthorized      |

  Scenario: Admin attempts to delete an account that doesn't exist
    When the client submits a DELETE request to /users/1000000 with the 1st user's credentials
    Then no user should be deleted
    And the response should return status 404