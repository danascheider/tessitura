@organizations
Feature: Update organization
  
  Since organizations often change addresses, staff, and even names, as a
  Tessitura admin, in order to maintain my customer base, I need functionality
  to update organization information.

  Scenario: Admin updates organization
    When the client submits a PUT request to /organizations/1 with admin credentials and:
      """json
      {"contact_name":"Shelley Goldschmidt"}
      """
    Then the organization's contact_name should be "Shelley Goldschmidt"
    And the response should indicate the organization was updated successfully

  Scenario: Admin attempts to update organization with bad attributes
    When the client submits a PUT request to /organizations/1 with admin credentials and:
      """json
      {"name":null}
      """
    Then the organization's name should not be empty
    And the response should indicate the organization was not saved successfully

  Scenario: Regular user attempts to update organization
    When the client submits a PUT request to /organizations/1 with user credentials and:
      """json
      {"contact_name":"Shelley Goldschmidt"}
      """
    Then the organization's contact_name should not be "Shelley Goldschmidt"
    And the response should indicate the request was unauthorized

  Scenario: User attempts to update organization without logging in
    When the client submits a PUT request to /organizations/1 with no credentials and:
      """json
      {"contact_name":"Shelley Goldschmidt"}
      """
    Then the organization's contact_name should not be "Shelley Goldschmidt"
    And the response should indicate the request was unauthorized

  Scenario: Attempt to update non-existent organization
    Given there is no organization with ID 100
    When the client submits a PUT request to /organizations/100 with admin credentials and:
      """json
      {"contact_name":"Shelley Goldschmidt"}
      """
    Then the response should indicate the resource was not found