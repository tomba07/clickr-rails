const Zigbee = require('./zigbee')
const ApiClient = require('./api-client')

console.log(process.env.ZSTACK_ZIGBEE_DEVICE)

const zigbee = new Zigbee({
  permitJoin: process.env.ZSTACK_ZIGBEE_PERMIT_JOIN === 'true',
  devicePath: process.env.ZSTACK_ZIGBEE_DEVICE,
})
const apiClient = new ApiClient({
  postUrl: process.env.CLICKR_POST_ENDPOINT || 'http://localhost:3000/clicks',
})

zigbee.on('battery', ({ deviceId, battery }) =>
  console.log('TODO post battery status to server', deviceId, battery)
)
zigbee.on('click', ({ deviceId }) => apiClient.postClick(deviceId))
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
