const Zigbee = require('./zigbee')
// TODO Read config from env vars
const zigbee = new Zigbee()
// TODO Post events to clickr API
zigbee.on('battery', ({ deviceId, battery }) => console.log('battery', deviceId, battery))
zigbee.on('click', ({ deviceId }) => console.log('click', deviceId))
zigbee.start()

process.on('SIGINT', handleQuit)
process.on('SIGTERM', handleQuit)

let stopping = false

function handleQuit() {
    if (!stopping) {
        stopping = true
        zigbee.stop()
    }
}
