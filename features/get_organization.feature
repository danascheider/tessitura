@organizations
Feature: View organizations

  Scenario: User views single organization

    As a user, in order to find information to learn about and contact
    an organization that can benefit my career, I need to view the
    organization's profile.

    When the client submits a GET request to /organizations/1 with user credentials
    Then the JSON response should include the organization's profile information
    And the response should return status 200

  Scenario: Unregistered user attempts to view single organization

    Organizations may be viewed by any registered user, but not by unregistered users

    When the client submits a GET request to /organizations/1 with no credentials
    Then the response should not include any data
    And the response should indicate the request was unauthorized