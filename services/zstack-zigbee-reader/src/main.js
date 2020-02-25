const Zigbee = require('./zigbee')
const ApiClient = require('./api-client')
const parseHexString = require('./utils/parse-hex-string')

function _try(fn) {
  try {
    return fn()
  } catch (e) {
    console.error(e)
    return undefined
  }
}

const parseOptionalHexString = (hexString, chunkSize) =>
  hexString ? _try(() => parseHexString(hexString, chunkSize)) : undefined

const zigbee = new Zigbee({
  permitJoin: process.env.ZSTACK_ZIGBEE_PERMIT_JOIN === 'true',
  devicePath: process.env.ZSTACK_ZIGBEE_DEVICE,
  panID: (parseOptionalHexString(process.env.ZSTACK_ZIGBEE_PAN_ID, 4) || [
    undefined,
  ])[0],
  extendedPanID: parseOptionalHexString(
    process.env.ZSTACK_ZIGBEE_EXTENDED_PAN_ID,
    2
  ),
  networkKey: parseOptionalHexString(process.env.ZSTACK_ZIGBEE_NETWORK_KEY, 2),
  channel: _try(() => Number.parseInt(process.env.ZSTACK_ZIGBEE_CHANNEL)),
})
const apiClient = new ApiClient({
  postUrl: process.env.CLICKR_POST_ENDPOINT || 'http://localhost:3000/clicks',
})

process.on('SIGINT', handleQuit)
process.on('SIGTERM', handleQuit)

zigbee.on('battery', ({ deviceId, battery }) =>
  console.log('TODO post battery status to server', deviceId, battery)
)
zigbee.on('click', ({ deviceId }) => apiClient.postClick(deviceId))
zigbee.start().catch(e => {
  console.error('Unexpected error. Quitting!', e)
  handleQuit()
  process.exit(1)
})

let stopping = false
function handleQuit() {
  if (!stopping) {
    stopping = true
    zigbee.stop()
  }
}
