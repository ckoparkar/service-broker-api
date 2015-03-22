Feature: As a user I can bind my apps to service instances

  Scenario: I unbind my app
    When I create a service instance with :instance_id "1"
    Then the response status should be "201"
    And I bind app with :binding_id "1" to a service_instance with :instance_id "1"
    Then the response status should be "201"
    And I unbind app with :binding_id "1" and :instance_id "1"
    Then the response status should be "200"

  Scenario: I try to delete a non-existant binding
    When I unbind app with :binding_id "1" and :instance_id "1"
    Then the response status should be "410"

  Scenario: PostgreSQL server is not reachable
    When the server is not reachable
    And I unbind app with :binding_id "1" and :instance_id "1"
    Then the response status should be "500"
