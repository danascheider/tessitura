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
      {"user":2, "filters":{<filters>}}
      """
    Then the JSON response should include <resources>
    And the response should return status 200

    Examples:
      | filters                                | resources                   |
      | "priority":"high"                      | tasks 10 and 11             |
      | "priority":"high", "status":"blocking" | task 10                     |
      | "priority":["high","low"]              | the 2nd user's last 3 tasks |
      | "deadline":{"on":{"year":2014, "month":8, "day": 27 }} | task 10     |

  Scenario Outline: User filters for one-sided date range
    When the client submits a POST request to /filters with:
      """json
      {"user":2, "filters":{"deadline":{"<adv>":{"year":2014, "month":8, "day":27}}}}
      """
    Then the JSON response should include task <id>
    And the response should not include any tasks without a deadline
    And the response should return status 200

    Examples:
      | adv    | id |
      | before | 11 |
      | after  | 12 | 

  Scenario: User filters for two-sided date range
    When the client submits a POST request to /filters with:
      """json
      {"user":2, "filters":{"deadline":{"before":{"year":2014, "month":11, "day": 17}, "after":{"year":"2014","month":8,"day":19}}}}
      """
    Then the JSON response should include task 10
    And the response should not include tasks 11 or 12
    And the response should return status 200

  Scenario: There are both time conditions and categorical conditions
    When the client submits a POST request to /filters with:
      """json
      {"user":2, "filters":{"deadline":{"after":{"year":2014, "month":8, "day":20}},"priority":"high"}}
      """
    Then the JSON response should include task 10
    And the response should not include tasks 11 or 12
    And the response should return status 200