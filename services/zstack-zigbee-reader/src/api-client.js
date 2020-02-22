const axios = require('axios')

class ApiClient {
  constructor({ postUrl }) {
    this.postUrl = postUrl
  }

  async postClick(deviceId) {
    console.info(`Posting click for ${deviceId}`)
    try {
      await axios.post(this.postUrl, {
        device_type: 'zigbee',
        device_id: deviceId,
      })
    } catch (e) {
      console.error('Failed to post click', e.name, e.message)
    }
  }
}

module.exports = ApiClient
