@organizations
Feature: View organizations

  Scenario: Logged-in user views single organization

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

  Scenario: Logged-in user views all organizations

    As a user, to identify organizations that can benefit my career, I need
    to view all the organizations.

    Given there are 3 organizations
    When the client submits a GET request to /organizations with user credentials
    Then the JSON response should include all the organizations
    And the response should return status 200

  Scenario: Unregistered user attempts to view all organizations
    Given there are 3 organizations
    When the client submits a GET request to /organizations with no credentials
    Then the response should not include any data
    And the response should indicate the request was unauthorized