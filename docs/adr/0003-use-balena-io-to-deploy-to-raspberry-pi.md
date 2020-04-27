# 3. Use balena.io to deploy to Raspberry PI

Date: 2020-04-27

## Status

2020-04-27 accepted

## Context

clickr should not run or store student data in the cloud (data protection/GDPR considerations).

clickr should run on a local device, currently a Raspberry Pi.

The Pi is installed in a school classroom.

Especially during the initial development phase, updates of the clickr software running on the Pi have to be easy
and not require manual access to the Pi.
 

## Decision

Use balena.io for Raspberry Pi device management.

## Consequences

- Orchestrate clickr services using docker-compose.
- Use balena.io's cloud build service to build the docker images for aarch64 (ARM CPUs).
- Get access to device logs, web-based shell access.
