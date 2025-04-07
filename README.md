# TripleDnsmasq - Three Dnsmasq services in concert for minimal downtime

https://github.com/philyg/triplednsmasq

## Motivation

It often makes sense to have a private domain name service available. While services like _BIND_ have been around for ages, I personally dislike the configuration style and layout as it is quite complex if for example all you need is a handful of A entries to resolve. For this, _Dnsmasq_ is a comfortable alternative, saving DNS entries and configuration in simple line-wise configuration files.

However, to reload the configuration, _Dnsmasq_ has to be restarted. This could lead to a short downtime of the DNS which is undesireable. This project therefore consists of a docker image that runs three _Dnsmasq_ daemons instead of only one. One of the daemons is a simple failover for the other two. This way, while one server restarts, the other is still available to serve requests, and then the other can restart while the first serves requests.

## Requirements

The project shall implement the following docker image:
- An alpine based image with _Dnsmasq_ installed
- A script that starts three _Dnsmasq_ daemons with:
  - One front-facing load balancer and
  - Two backend servers
- A script to safely reload the configuration by restarting the backend servers in sequence

## Implementation

This project is implemented using:
- A docker image as described in `image/Dockerfile` with integrated frontend configuration, startup script and reload script
- An example compose file in `docker-compose.yml`
- An example configuration in `data/dnsmasq/`
- A [dockercomposemk](https://github.com/philyg/dockercomposemk) Makefile

## Usage

### Building

Build the image running `make build`.

### Deployment

Start the container in detached mode using `make up`.

To reload the configuration, run `make reload`.

> [!IMPORTANT]
> Many current linux systems already have _systemd-resolved_ running on port 53, so to serve the domain service using _triplednsmasq_, either disable _systemd-resolved_ entirely or only the _DNSStubListener_ component, or configure _triplednsmasq_ to use a different port than 53 in the `docker-compose.yml`. Otherwise, you will receive an `address already in use` error.
>
> Note however, that Microsoft Windows does not (easily?) allow to use DNS servers on a port other that 53!

### Configuration

Example configuration files are placed in `data/dnsmasq/`.

The subdirectory `conf` contains configuration files for _Dnsmasq_:
- `00_base.conf`: Basic configuration options about name resolution.
- `01_server.conf`: Which servers to use and which domains to resolve without forwarding.
- `02_entries.conf`: Configuration-Style DNS entries like CNAME, SRV and TXT.

The `hosts` subdirectory contains hosts files - each hosts file can contain multiple IP/hostname mappings, all hosts files are merged by _Dnsmasq_.

> [!TIP]
> It is not recommended to use `.local` as a top level domain for names to be resolved via unicast domain name services. Many implementations (including _systemd-resolved_) do not even try to resolve `.local` via DNS but instead try to look up the name using multicast DNS procotols. For (most probably) usable TLDs see [RFC 6762 Appendix G](https://www.rfc-editor.org/rfc/rfc6762#appendix-G).