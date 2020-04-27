# 2. Use zigbee-herdsman lib as Zigbee bridge

Date: 2020-04-27

## Status

2020-04-27 accepted

## Context

[zigbee2mqtt](https://www.zigbee2mqtt.io/) is broadly used for custom zigbee stacks.

Internally, it uses [`zigbee-herdsman`](https://github.com/Koenkk/zigbee-herdsman) to interface with an adapter running the [ZStack firmware](https://github.com/Koenkk/Z-Stack-firmware).

- clickr does not require the full feature set of `zigbee2mqtt` (pulling in all its dependencies, including an MQTT broker, is overkill).

- clickr should not implement a new device driver to interface zigbee adapters (e.g. a ZStack driver). 


## Decision

Receive events from zigbee buttons via `zigbee-herdsman`.

## Consequences

- Only `ZStack` capable zigbee adapters are supported (though additional adapters could be written - they just need to consume the `clickr/web` HTTP POST endpoint)
- Custom code is required for every new type of button, as `zigbee-herdsman` does not provide an abstraction e.g. of different `button` hardware.
