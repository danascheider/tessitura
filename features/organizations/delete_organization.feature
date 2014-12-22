@organizations
Feature: Delete organization 
  
  Organizations can only be created or destroyed by an admin.

  Scenario: Admin deletes an organization
    When the client submits a DELETE request to /organizations/1 with admin credentials
    Then the organization should be destroyed
    And the response should return status 204

  Scenario: Normal user attempts to delete an organization
    When the client submits a DELETE request to /organizations/1 with user credentials
    Then the organization should not be destroyed
    And the response should indicate the request was unauthorized

  Scenario: Unregistered user attempts to delete an organization
    When the client submits a DELETE request to /organizations/1 with no credentials
    Then the organization should not be destroyed
    And the response should indicate the request was unauthorized