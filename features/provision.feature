Feature: As a user I can provision service instances

  Scenario: I can create a new service instance
    When I send PUT request to "/v2/service_instances/:id" with the following:
    | id | 1 |
    Then the response status should be "200"
