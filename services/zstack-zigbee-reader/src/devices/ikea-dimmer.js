const Device = require('./device')

class IkeaDimmer extends Device {
  onMessage(message) {
    const { data = {} } = message
    const leftClick = data.value === 257
    const rightClick = data.value === 256

    if (leftClick) {
      this.emit('click', {
        deviceId: `${this.parseDeviceId(message)}/left`
      })
    }

    if (rightClick) {
      this.emit('click', {
        deviceId: `${this.parseDeviceId(message)}/right`
      })
    }
  }
}

module.exports = IkeaDimmer
