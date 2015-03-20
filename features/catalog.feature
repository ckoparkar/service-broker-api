Feature: As a user I can access service catalog

  Scenario: I can get catlog
    When I send a GET request to "/v2/catalog"
    Then the response status should be "200"

  Scenario: Catalog has atleast one service and plan
    When I send a GET request to "/v2/catalog"
    Then I should see "service"
    And I should see "plan"
