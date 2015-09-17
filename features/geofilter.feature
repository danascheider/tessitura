Feature: Geofilter
  
  Geofilter is a gem that creates basic geographic filters that can be applied to database models.
  It will be used to filter local results.

  Background:
    Given the following organizations:
      """json
      [
        {"name":"Portland Baroque Orchestra", "city":"Portland","state":"OR"},
        {"name":"Portland Opera","city":"Lake Oswego","state":"OR"},
        {"name":"Seattle Opera","city":"Seattle","state":"WA"}
      ]
      """

  Scenario: Sorted by state
    When the client submits a POST request to /geofilter with user credentials and:
      """json
      {"state":"OR"}
      """
    Then the JSON response should include 2 organizations
    And the response status should be 200

  Scenario: Sorted by city and state
    When the client submits a POST request to /geofilter with user credentials and:
      """json
      {"state":"OR", "city":"Portland"}
      """
    Then the JSON response should include 1 organization
    And the response status should be 200

  Scenario: Only city given
    When the client submits a POST request to /geofilter with user credentials and:
      """json
      {"city":"Portland"}
      """
    Then the response should indicate the filter was invalid
    And the response status should be 422