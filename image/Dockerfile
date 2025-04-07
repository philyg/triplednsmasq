# SPDX-FileCopyrightText: 2025 Philipp Grassl <philyg@linandot.net>
# SPDX-License-Identifier: MIT

FROM alpine:latest

RUN apk add dnsmasq bind-tools tini bash \
&& mkdir -p /srv/dnsmasq/hosts /srv/dnsmasq/conf-backend

COPY triplednsmasq /
COPY reload /
COPY conf-frontend /srv/dnsmasq/conf-frontend/

ENTRYPOINT ["/sbin/tini","--"]
CMD ["/triplednsmasq"]
