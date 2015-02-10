# cf-postgresql-broker
CF PostgreSQL broker provides PostgreSQL databases as a Cloud Foundry service. This uses Service Broker API v2.4.

## Usage

1. Install the `cf` command line tool.
2. Push this broker app in the desired org + space.
3. Register the broker with CF. ([API Documentation](http://docs.cloudfoundry.org/services/managing-service-brokers.html))
4. Give users access to your service. ([API Documentation](http://docs.cloudfoundry.org/services/access-control.html#enable-access))

## Development
This broker is a work in progress. Currently it just implements the `/v2/catalog` end-point, which advertises the service and its plans offered in CF marketplace.
