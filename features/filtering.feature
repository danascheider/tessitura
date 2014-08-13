# There are a couple things that need to be sorted out before this scenario can be
# finished.

# The biggest issue is how to handle more complex filters: How to differentiate 
# between AND and OR, etc. For now, this simple one is good 

@tasks
Feature: Filtering resources

  Background:
    Given the 2nd user has the following tasks:
      | id | title     | status   | priority |
      | 10 | My Task 4 | blocking | high     |
      | 11 | My Task 5 | new      | high     |
      | 12 | My Task 6 | complete | low      |
    And the 2nd user is logged in

  Scenario: User filters their tasks for one criterion
    When the client submits a POST request to /filters with:
      """json
      {"user":2, "resource":"tasks", "filters":{"priority":"high"}} 
      """
    Then the JSON response should include tasks 10 and 11
    And the response should return status 200

  Scenario: User filters their tasks for an intersection of multiple criteria
    When the client submits a POST request to /filters with:
      """json
      {"user":2, "resource":"tasks", "filters":{"priority":"high", "status":"blocking"}}
      """
    When the JSON response should only include the 10th task
    And the response should return status 200