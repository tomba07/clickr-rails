const ZigbeeHerdsman = require('zigbee-herdsman')
const events = require('events')
const utils = require('./utils')

const data = {
  joinPath: p => `${__dirname}/../data/${p}`
}

const herdsmanSettings = {
  network: {
    // TODO Generate random PID and EPID and extract to env var
    panID: 0x1a62,
    extendedPanID: [0xDD, 0xDD, 0xDD, 0xDD, 0xDD, 0xDD, 0xDD, 0xDD],
    channelList: [11],
    // TODO Extract network key to env var
    networkKey: [118, 116, 39, 62, 118, 218, 10, 73, 97, 190, 103, 196, 154, 246, 135, 114],
  },
  databasePath: data.joinPath('database.db'),
  databaseBackupPath: data.joinPath('database.db.backup'),
  backupPath: data.joinPath('coordinator_backup.json'),
  serialPort: {
    baudrate: 115200,
    rtscts: true,
    path: '/dev/ttyACM1', // TODO Pass dynamic path
  },
}

/**
 * https://github.com/Koenkk/zigbee2mqtt/blob/master/lib/zigbee.js
 * Emits events: click, battery
 */
class Zigbee extends events.EventEmitter {
  async start() {
    console.info(`Starting zigbee-herdsman...`)

    try {
      this.herdsman = new ZigbeeHerdsman.Controller(herdsmanSettings)
      await this.herdsman.start()
    } catch (error) {
      console.error(`Error while starting zigbee-herdsman`)
      throw error
    }

    this.herdsman.on('adapterDisconnected', this.onZigbeeAdapterDisconnected.bind(this))
    this.herdsman.on('message', this.onMessageParseBattery.bind(this))
    this.herdsman.on('message', this.onMessageParseClick.bind(this))

    console.warn('Allowing devices to join network (disable after setup phase is complete)')
    // TODO Disable permit join based on env var
    await this.herdsman.permitJoin(true)
    await this.herdsman.setLED(true)

    console.info('zigbee-herdsman started')
  }

  async onZigbeeAdapterDisconnected() {
    console.error('Adapter disconnected, stopping')
    await this.stop()
  }

  async stop() {
    await this.herdsman.setLED(false)
    await this.herdsman.stop()
    console.info('zigbee-herdsman stopped')
  }

  parseDeviceId(msg) {
    return msg.device && msg.device.ieeeAddr
  }

  // https://github.com/Koenkk/zigbee-herdsman-converters/blob/307e995/converters/fromZigbee.js#L556-L576
  onMessageParseBattery(msg) {
    let voltage = null
    const { data = {} } = msg

    if (msg.data['65281']) {
      voltage = msg.data['65281']['1']
    } else if (msg.data['65282']) {
      voltage = msg.data['65282']['1'].elmVal
    }

    if (voltage) {
      this.emit('battery', {
        deviceId: this.parseDeviceId(msg),
        battery: parseFloat(utils.toPercentageCR2032(voltage)),
        voltage: voltage
      })
    }
  }

  onMessageParseClick(msg) {
    const { data = {} } = msg
    const singlePress = data.onOff === 0
    const multiplePress = '32768' in data

    if (singlePress || multiplePress) {
      this.emit('click', {
        deviceId: this.parseDeviceId(msg),
      })
    }
  }
}

module.exports = Zigbee
