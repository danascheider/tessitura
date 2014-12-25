@seasons @delete
Feature: Delete season

  Scenario: Admin deletes season
    When the client submits a DELETE request to /seasons/1 with admin credentials
    Then the season should be deleted
    And the response should indicate the season was deleted successfully

  Scenario: Admin attempts to delete a nonexistent season
    Given there is no season with ID 881
    When the client submits a DELETE request to /seasons/881 with admin credentials
    Then no season should be deleted
    And the response should return status 404

  Scenario Outline: Unauthorized attempt to delete a season
    When the client submits a DELETE request to /seasons/1 with <type> credentials
    Then season 1 should not be deleted
    And the response should indicate the request was unauthorized

    Examples:
      | type |
      | user |
      | no   |