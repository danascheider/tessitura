@churches @organizations
Feature: View churches

  Scenario: Logged-in user views single church
    When the client submits a GET request to /churches/2 with user credentials
    Then the JSON response should include the church's profile information
    And the response should return status 200

  Scenario: Unregistered user attempts to view single church
    When the client submits a GET request to /churches/2 with no credentials
    Then the response should not include any data
    And the response should indicate the request was unauthorized

  Scenario: Logged-in user views all churches
    Given there are 3 churches
    When the client submits a GET request to /churches with user credentials
    Then the JSON response should include all the churches
    And the response should return status 200

  Scenario: Unregistered user attempts to view all churches
    Given there are 3 churches
    When the client submits a GET request to /churches with no credentials
    Then the response should not include any data
    And the response should indicate the request was unauthorized