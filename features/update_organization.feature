@organizations
Feature: Update organization
  
  Since organizations often change addresses, staff, and even names, as a
  Canto admin, in order to maintain my customer base, I need functionality
  to update organization information.

  Scenario: Admin updates organization
    Given there is an organization
    When the client submits a PUT request to its individual endpoint with admin credentials and:
      """json
      {"contact_name":"Shelley Goldschmidt"}
      """
    Then the organization's contact_name should be "Shelley Goldschmidt"
    And the response should indicate the organization was updated successfully

  Scenario: Regular user attempts to update organization
    Given there is an organization
    When the client submits a PUT request to its individual endpoint with user credentials and:
      """json
      {"contact_name":"Shelley Goldschmidt"}
      """
    Then the organization's contact_name should not be "Shelley Goldschmidt"
    And the response should indicate the request was unauthorized