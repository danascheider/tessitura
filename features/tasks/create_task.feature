Feature: Create task 
  
  In order to remember what I have to get done
  As a user
  I need to create a task for my to-do list

  Background:
    Given there are 4 tasks
    And I have navigated to the 'New Task' page

  Scenario: User creates a task
    When I submit the form with the title 'Take out the trash'
    Then a new task should be created with the title 'Take out the trash'

  Scenario: User doesn't fill out the title field
    When I submit the form blank
    Then no task should be created
    And I should see a message saying that title is required