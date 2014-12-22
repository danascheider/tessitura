@organizations
Feature: View organizations

  Scenario: User views single organization

    As a user, in order to find information to learn about and contact
    an organization that can benefit my career, I need to view the
    organization's profile.

    Given there is an organization
    When the client submits a GET request to its individual endpoint with user credentials
    Then the JSON response should include the organization's profile information
    And the response should return status 200