# Deploying EMQX Cluster with HAProxy MQTT Load Balancing

This is a quick example to show how to deploy EMQX Cluster with HAProxy MQTT Load Balancing.

For more information like how to configure HAProxy, please see EMQX Documentation: [MQTT Load Balancing](https://docs.emqx.com/en/enterprise/v5.1/deploy/cluster/lb-haproxy.html).

## Usage

1. Prepare TLS material for your domain (for example `test.de`). You can either drop an existing PEM at `certs/<domain>.pem` or place the pair `certs/<domain>.crt` and `certs/<domain>.key`; `start.sh` concatenates the pair into the PEM HAProxy expects inside `/etc/haproxy/certs`.
2. Render the HAProxy configuration for your domain:

   ```bash
   ./start.sh test.de
   ```

   The script verifies TLS material (building the PEM from `.crt` + `.key` if needed) and generates `haproxy.cfg` from `haproxy.cfg.template`, injecting the domain so every backend points at `*.test.de`. You can also call it as `HOST_DOMAIN=test.de ./start.sh`.

3. Provide EMQX credentials via your shell (`EMQX_COOKIE`, `DASHBOARD_USERNAME`, `DASHBOARD_PASSWORD`, etc.) and start the stack while passing the domain through the environment:

   ```bash
   HOST_DOMAIN=test.de docker compose up -d
   ```

Open <http://localhost:18083> to visit the EMQX Dashboard.
