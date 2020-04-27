# Running in production

## Hardware
- a Raspbrerry Pi
- a [ZStack compatible Zigbee USB adapter](https://www.zigbee2mqtt.io/information/supported_adapters.html)
- Zigbee buttons (currently only [Ikea Tradfi remotes](https://www.ikea.com/de/de/p/tradfri-fernbedienung-30443124/) are supported)

## Initial setup
1. Create a [balena.io](https://balena.io) account
2. Create an `clickr` app in balena
3. Flash the balena.io firmware, pre-configured for your `clickr` app, onto your Raspberry Pi
4. Check the `ZSTACK_ZIGBEE_DEVICE` on balena.io: It should match the device file of your Zigbee adapter (`ls /dev/serial/by-id` on your Rasbperry Pi).
4. `git clone https://github.com/ftes/clickr-rails && cd clickr-rails`
5. `npm run balena:push` (probably you need to `npm run balena:login` first)

## Pair buttons
- Pair your zigbee buttons (Ikea Tradfri: press pair buttons 4 times in rapid succession).
- Disable `ZSTACK_ZIGBEE_PERMIT_JOIN` env var on balena after pairing all buttons

## Use in lessons
- Ensure your computer and Raspberry Pi are in the same network (e.g. connected to the same Wifi access point)
- Open `http://<raspberry-pi-ip>` in your browser (you can find the Pi's IP address via the balena.io web dashboard)

## Additional considerations
- Can your Raspberry Pi connect to the internet (so that you can push clickrapp updates/configuration changes)?
