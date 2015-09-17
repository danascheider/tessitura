@churches @organizations
Feature: Delete church

  At this point, churches can only be created or destroyed by an admin

  Scenario: Admin deletes a church
    When the client submits a DELETE request to /churches/2 with admin credentials
    Then the church should be destroyed
    And the response should return status 204

  Scenario: User attempts to delete a church
    When the client submits a DELETE request to /churches/2 with user credentials
    Then the church should not be destroyed
    And the response should return status 401

  Scenario: Unregistered user attempts to delete a church
    When the client submits a DELETE request to /churches/2 with no credentials
    Then the church should not be destroyed
    And the response should return status 401