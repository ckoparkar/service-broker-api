Feature: As a user I can bind my apps to service instances

  Scenario: I bind my app to a service instance
    When I create a service instance with :instance_id "1"
    Then the response status should be "201"
    And I bind app with :binding_id "1" to a service_instance with :instance_id "1"
    Then the response status should be "201"

  Scenario: I try to create a duplicate service instance
    When I create a service instance with :instance_id "1"
    Then the response status should be "201"
    And I bind app with :binding_id "1" to a service_instance with :instance_id "1"
    Then the response status should be "201"
    And I bind app with :binding_id "1" to a service_instance with :instance_id "1"
    Then the response status should be "409"

  Scenario: Consequtive bindings
    When I create a service instance with :instance_id "1"
    Then the response status should be "201"
    And I bind app with :binding_id "1" to a service_instance with :instance_id "1"
    Then the response status should be "201"
    And I bind app with :binding_id "2" to a service_instance with :instance_id "1"
    Then the response status should be "201"


  Scenario: Bind to a non-existant service_instance
    When I bind app with :binding_id "1" to a service_instance with :instance_id "1"
    Then the response status should be "410"
    When I create a service instance with :instance_id "1"
    Then the response status should be "201"
    When I bind app with :binding_id "1" to a service_instance with :instance_id "2"
    Then the response status should be "410"

  Scenario: PostgreSQL server is not reachable
    When the server is not reachable
    And I bind app with :binding_id "1" to a service_instance with :instance_id "1"
    Then the response status should be "500"
