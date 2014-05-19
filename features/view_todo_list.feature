Feature: View To-Do List
  
  In order to plan my day
  As a user
  I want to see all my to-do items

  Background:
    Given I am a user

  Scenario: To-do list is empty

    Given I have no to-do items
    When I navigate to my to-do list
    Then I should see a message that I have no to-do items
    And I should see a link to create a new to-do item

  Scenario: To-do list is not empty

    Given I have 3 to-do items
    When I navigate to my to-do list
    Then I should see all of my to-do items
    And I should not see anyone else's to-do items

  Scenario: Some tasks are complete
    Given I have 5 to-do items
    And 2 of them have been marked 'Complete'
    When I navigate to my to-do list
    Then I shouldn't see the items that have been marked 'Complete'

  Scenario: User marks task complete
    When I navigate to my to-do list
    And I click the 'Mark Completed' link on the first to-do item
    Then the status of the first to-do item should be 'Complete'
    And it should disappear from the list