const parseHexString = require('./parse-hex-string')

describe('parseHexString', () => {
  it('parses the pan ID: one 4-char chunk', () => {
    const hexString = '0x1a63'
    const chunkSize = 4
    expect(parseHexString(hexString, chunkSize)).toEqual([0x1a63])
  })

  it('parses the extended pan ID: 8 2-char chunks', () => {
    const hexString = '0x0123456789abcdef'
    const chunkSize = 2
    expect(parseHexString(hexString, chunkSize)).toEqual([
      0x01,
      0x23,
      0x45,
      0x67,
      0x89,
      0xab,
      0xcd,
      0xef,
    ])
  })
})
