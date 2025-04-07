# SPDX-FileCopyrightText: 2025 Philipp Grassl <philyg@linandot.net>
# SPDX-License-Identifier: MIT

DC := @docker compose --progress plain

define MAKEFILEUSAGE

This is a dockercomposemk v0.1.0 Makefile. For more information see:
https://github.com/philyg/dockercomposemk

dockercomposemk is Copyright (c) 2025 Philipp Grassl
and released under the MIT license.


Available implemented targets:

up:             Create and start containers in background
fup:            Create and start containers in foreground
down:           Stop and remove containers and remove orphans

start:          Start stopped containers
stop:           Stop started containers
restart:        Restart containers

pause:          Pause containers
unpause:        Unpause containers

shell:          Open shell to first container if running
run:            Open shell to first container image

stats:          Show running status information
ps:             Show container list
logs:           Display and follow logs

build:          Build any buildable images
pull:           Pull any non-buildable images
rebuild:        Build any buildable images (no-cache)


Targets to be implemented by overriding in Makefile-custom as real-[NAME]:

reload:         Reload the service(s)
clean:          Cleanup any superfluous files
backup:         (Prepare for) backup of service data


All targets call pre-[NAME] and post-[NAME] targets for additional hooks in overriding
Makefile-custom files. The actual actions can also be changed by overriding real-[NAME].

Additionally, the following veriables can be defined in Makefile-custom:

SVC          The service to interact with when using the run and shell
             targets (uses first one in docker-compose.y*ml if undefined)

endef
export MAKEFILEUSAGE


all:
	@echo "$$MAKEFILEUSAGE"
.PHONY: all

-include Makefile-custom

ifeq ($(SVC),)
SVCPAT := "^[ \t]*(services:)?$$"
SVC := $(shell cat docker-compose.y*ml | grep -Ev ${SVCPAT} | head -n 1 | cut -d ":" -f 1 | awk '{ print $1 }')
endif
real-%: phony real-%-default
	@true

phony: ;
.PHONY: phony

# Implemented targets
real-up-default:
	${DC} up -d

real-fup-default:
	${DC} up

real-down-default:
	${DC} down --remove-orphans

real-start-default:
	${DC} start

real-stop-default:
	${DC} stop

real-restart-default:
	${DC} restart

real-pause-default:
	${DC} pause

real-unpause-default:
	${DC} unpause

real-shell-default:
	${DC} exec ${SVC} bash || true

real-run-default:
	${DC} run --rm ${SVC} bash || true

real-stats-default:
	${DC} stats || true

real-ps-default:
	${DC} ps -a || true

real-logs-default:
	${DC} logs --tail 1000 -f || true

real-build-default:
	${DC} build

real-pull-default:
	${DC} pull --ignore-buildable

real-rebuild-default:
	${DC} build --no-cache



# Hooks for implemented targets
pre-up:
post-up:
up: pre-up real-up post-up
.PHONY: up pre-up real-up-default post-up

pre-fup:
post-fup:
fup: pre-fup real-fup post-fup
.PHONY: fup pre-fup real-fup-default post-fup

pre-down:
post-down:
down: pre-down real-down post-down
.PHONY: down pre-down real-down-default post-down

pre-start:
post-start:
start: pre-start real-start post-start
.PHONY: start pre-start real-start-default post-start

pre-stop:
post-stop:
stop: pre-stop real-stop post-stop
.PHONY: stop pre-stop real-stop-default post-stop

pre-restart:
post-restart:
restart: pre-restart real-restart post-restart
.PHONY: restart pre-restart real-restart-default post-restart

pre-pause:
post-pause:
pause: pre-pause real-pause post-pause
.PHONY: pause pre-pause real-pause-default post-pause

pre-unpause:
post-unpause:
unpause: pre-unpause real-unpause post-unpause
.PHONY: unpause pre-unpause real-unpause-default post-unpause

pre-shell:
post-shell:
shell: pre-shell real-shell post-shell
.PHONY: shell pre-shell real-shell-default post-shell

pre-run:
post-run:
run: pre-run real-run post-run
.PHONY: run pre-run real-run-default post-run

pre-stats:
post-stats:
stats: pre-stats real-stats post-stats
.PHONY: stats pre-stats real-stats-default post-stats

pre-ps:
post-ps:
ps: pre-ps real-ps post-ps
.PHONY: ps pre-ps real-ps-default post-ps

pre-logs:
post-logs:
logs: pre-logs real-logs post-logs
.PHONY: logs pre-logs real-logs-default post-logs

pre-build:
post-build:
build: pre-build real-build post-build
.PHONY: build pre-build real-build-default post-build

pre-pull:
post-pull:
pull: pre-pull real-pull post-pull
.PHONY: pull pre-pull real-pull-default post-pull

pre-rebuild:
post-rebuild:
rebuild: pre-rebuild real-rebuild post-rebuild
.PHONY: rebuild pre-rebuild real-rebuild-default post-rebuild


# Forward-define targets for custom actions
pre-reload:
real-reload:
post-reload:
reload: pre-reload real-reload post-reload
.PHONY: reload pre-reload real-reload post-reload

pre-clean:
real-clean:
post-clean:
clean: pre-clean real-clean post-clean
.PHONY: clean pre-clean real-clean post-clean

pre-backup:
real-backup:
post-backup:
backup: pre-backup real-backup post-backup
.PHONY: backup pre-backup real-backup post-backup


