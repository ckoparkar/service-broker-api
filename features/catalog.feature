Feature: As a user I can access service catalog

  Scenario: I can get catlog
    When I GET request for "/v2/catalog"
    Then the status is 200

  Scenario: Catalog has atleast one service and plan
    When I GET request for "/v2/catalog"
    Then I should see "service"
    And I should see "plan"
