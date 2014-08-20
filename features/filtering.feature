# There are a couple things that need to be sorted out before this scenario can be
# finished.

# The biggest issue is how to handle more complex filters: How to differentiate 
# between AND and OR, etc. For now, this simple one is good 

@tasks
Feature: Filtering resources

  Background:
    Given the 2nd user has the following tasks:
      | id | title     | status   | priority | deadline   |
      | 10 | My Task 4 | blocking | high     | 2014-08-27 |
      | 11 | My Task 5 | new      | high     | 2014-08-19 |
      | 12 | My Task 6 | complete | low      | 2014-11-17 |
    And the 2nd user is logged in

  Scenario Outline: Simple filters
    When the client submits a POST request to /filters with:
      """json
      {"user":2, "resource":"tasks", "filters":{<filters>}}
      """
    Then the JSON response should include <resources>
    And the response should return status <status>

    Examples:
      | filters                                | resources                   | status |
      | "priority":"high"                      | tasks 10 and 11             | 200    |
      | "priority":"high", "status":"blocking" | task 10                     | 200    |
      | "priority":["high","low"]              | the 2nd user's last 3 tasks | 200    |
      | "deadline":{"on":{"year":2014, "month":8, "day": 27 }} | task 10     | 200    |

  Scenario Outline: User filters for date range
    When the client submits a POST request to /filters with:
      """json
      {"user":2, "resource":"tasks", "filters":{"deadline":{"<adv>":{"year":2014, "month":8, "day":27}}}}
      """
    Then the JSON response should include task <id>
    And the response should not include any tasks without a deadline

    Examples:
      | adv    | id |
      | before | 11 |
      | after  | 12 | 