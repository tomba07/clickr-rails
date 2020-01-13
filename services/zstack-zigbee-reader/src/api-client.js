const axios = require('axios')

class ApiClient {
  constructor({ postUrl }) {
    this.postUrl = postUrl
  }

  async postClick(deviceId) {
    try {
      await axios.post(this.postUrl, {
        device_type: 'zigbee',
        device_id: deviceId,
      })
    } catch (e) {
      console.error('Failed to post click', e)
    }
  }
}

module.exports = ApiClient
