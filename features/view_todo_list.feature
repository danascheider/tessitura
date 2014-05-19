Feature: View To-Do List
  
  In order to plan my day
  As a user
  I want to see all my to-do items

  Background:
    Given I am a user

  Scenario: To-do list is empty

    Given my to-do list is empty
    When I navigate to my to-do list
    Then I should see a message that I have no to-do items
    And I should see a link to create a new to-do item

  Scenario: To-do list is not empty

    Given I have 3 to-do items
    And the to-do items are called "My Task 1", "My Task 2", and "My Task 3"
    When I navigate to my to-do list
    Then all of the to-do items should be listed