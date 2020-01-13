jest.mock('zigbee-herdsman')

test('smoke test: runs without error for 1 second', async () => {
  require('./main')
  await new Promise(resolve => setTimeout(resolve, 1000))
})
