const events = require('events')

class Device extends events.EventEmitter {
  parseDeviceId(msg) {
    return msg.device && msg.device.ieeeAddr
  }

  onMessage(message) {
    throw new Error('Not implemented by subclass')
  }
}

module.exports = Device
