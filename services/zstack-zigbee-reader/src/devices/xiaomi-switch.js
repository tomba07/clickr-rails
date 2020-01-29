const Device = require('./device')

class XiaomiSwitch extends Device {
  // https://github.com/Koenkk/zigbee-herdsman-converters/blob/307e995/converters/fromZigbee.js#L556-L576
  onMessageParseBattery(msg) {
    let voltage = null
    const { data = {} } = msg

    if (data['65281']) {
      voltage = data['65281']['1']
    } else if (data['65282']) {
      voltage = data['65282']['1'].elmVal
    }

    if (voltage) {
      this.emit('battery', {
        deviceId: this.parseDeviceId(msg),
        battery: parseFloat(utils.toPercentageCR2032(voltage)),
        voltage: voltage,
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

  onMessage(message) {
    this.onMessageParseBattery(message)
    this.onMessageParseClick(message)
  }
}

module.exports = XiaomiSwitch
