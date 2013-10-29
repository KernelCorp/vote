Feature: i18n
  In order change site's language
  I want to see site in two languages, ru and eng

  Scenario: change locale
    When I go to "/"
    And  I click to button 'change locale to en'
    Then I should see "english text"
