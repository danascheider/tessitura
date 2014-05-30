Feature: Create task 
  
  In order to remember what I have to get done
  As a user
  I need to create a task for my to-do list

  Background:
    Given there are 4 tasks

  Scenario: User creates a task
    Given I have navigated to the 'New Task' page
    When I submit the form with the title 'Take out the trash'
    Then a new task should be created with the title 'Take out the trash'