Feature: As a user I can provision service instances

  Scenario: I can create a new service instance
    When I send PUT request to "/v2/service_instances/:id" with the following:
    | id | 1 |
    And I dont get any errors
    Then the response status should be "201"

  Scenario: I try to create a duplicate service instance
    When I send PUT request to "/v2/service_instances/:id" with the following:
    | id | 1 |
    And it raises "DatabaseAlreadyExistsError"
    Then the response status should be "409"

  Scenario: If the postgresql server is not reachable
    When I send PUT request to "/v2/service_instances/:id" with the following:
    | id | 1 |
    And it raises "ServerNotReachableError"
    Then the response status should be "500"

  Scenario: If any other error is raised
    When I send PUT request to "/v2/service_instances/:id" with the following:
    | id | 1 |
    And it raises "StandardError"
    Then the response status should be "501"
