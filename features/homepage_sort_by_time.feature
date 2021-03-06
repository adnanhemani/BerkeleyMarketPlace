# id 151972883
Feature: buyer can filter by category on homepage
 
  As a buyer,
  I want to see latest posts,
  I can sort by time
  
Background:
  Given I am on the home page
  Then I login with correct normal email
  
Scenario: select latest time first
  Given there is an item with the release time "Jan 1 2016 00:00:00" and the title "item 1 title"
  Given there is an item with the release time "Jan 1 2017 00:00:00" and the title "item 2 title"
  When I go to the home page
  Then I follow "New posts"
  Then I wait for a while
  Then I should see "item 2 title" before "item 1 title"
  