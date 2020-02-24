const chunk = require('lodash/chunk')

function parseHexString(hexString, chunkSize = 2) {
  const withoutPrefix = hexString.replace(/^0x/, '')
  const chars = withoutPrefix.split('')
  const arrayChunks = chunk(chars, chunkSize)
  const stringChunks = arrayChunks.map(a => a.join(''))
  const intChunks = stringChunks.map(s => Number.parseInt(`0x${s}`))
  return intChunks
}

module.exports = parseHexString
