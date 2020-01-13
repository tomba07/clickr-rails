const toPercentageCR2032 = (voltage) => {
  let percentage = null

  if (voltage < 2100) {
      percentage = 0
  } else if (voltage < 2440) {
      percentage = 6 - ((2440 - voltage) * 6) / 340
  } else if (voltage < 2740) {
      percentage = 18 - ((2740 - voltage) * 12) / 300
  } else if (voltage < 2900) {
      percentage = 42 - ((2900 - voltage) * 24) / 160
  } else if (voltage < 3000) {
      percentage = 100 - ((3000 - voltage) * 58) / 100
  } else if (voltage >= 3000) {
      percentage = 100
  }

  return Math.round(percentage)
}

module.exports = {
  toPercentageCR2032
}
