const ZigbeeHerdsman = require('zigbee-herdsman')
const events = require('events')
const utils = require('./utils')
const devices = require('./devices')

const data = {
  joinPath: p => `${__dirname}/../data/${p}`,
}

/**
 * https://github.com/Koenkk/zigbee2mqtt/blob/master/lib/zigbee.js
 * Emits events: click, battery
 */
class Zigbee extends events.EventEmitter {
  constructor({ devicePath = '/dev/ttyACM0', permitJoin = true }) {
    super()

    this.devices = devices.map(Device => new Device())
    this.permitJoin = permitJoin
    this.herdsmanSettings = {
      network: {
        // TODO Generate random PID and EPID and extract to env var
        panID: 0x1a63,
        extendedPanID: [0xdd, 0xdd, 0xdd, 0xdd, 0xdd, 0xdd, 0xdd, 0xdd],
        channelList: [11],
        // TODO Extract network key to env var
        networkKey: [
          118,
          116,
          39,
          62,
          118,
          218,
          10,
          73,
          97,
          190,
          103,
          196,
          154,
          246,
          135,
          114,
        ],
      },
      databasePath: data.joinPath('database.db'),
      databaseBackupPath: data.joinPath('database.db.backup'),
      backupPath: data.joinPath('coordinator_backup.json'),
      serialPort: {
        baudrate: 115200,
        rtscts: true,
        path: devicePath,
      },
    }
  }

  async start() {
    console.info(`Starting zigbee-herdsman...`)
    console.debug(
      'Herdsman settings',
      JSON.stringify(this.herdsmanSettings, null, 2)
    )

    try {
      this.herdsman = new ZigbeeHerdsman.Controller(this.herdsmanSettings)
      await this.herdsman.start()
    } catch (error) {
      console.error(`Error while starting zigbee-herdsman`, error)
      throw error
    }

    this.herdsman.on(
      'adapterDisconnected',
      this.onZigbeeAdapterDisconnected.bind(this)
    )

    this.herdsman.on(
      'deviceJoined',
      msg => console.debug('Device joined', msg.device.ieeeAddr)
    )

    this.herdsman.on(
      'deviceLeave',
      msg => console.debug('Device left', msg.ieeeAddr)
    )

    this.registerDevices()
    this.herdsman.on('message', msg => console.debug('New message from', msg.device.ieeeAddr, msg.data))

    if (this.permitJoin) {
      console.warn(
        'Allowing devices to join network (disable after setup phase is complete)'
      )
    }
    // TODO Disable permit join based on env var
    await this.herdsman.permitJoin(this.permitJoin)
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

  registerDevices() {
    // TODO Log which device listeners are registered
    console.log(`Registering ${this.devices.length} device listeners`)
    this.devices.forEach(device => {
      this.herdsman.on('message', device.onMessage.bind(device))
      // Forward events
      device.on('click', msg => this.emit('click', msg))
      device.on('battery', msg => this.emit('battery', msg))
    })
  }
}

module.exports = Zigbee
