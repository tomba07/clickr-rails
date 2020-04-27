# Configuration

## Environment variables
| Name | Default | Description |
|------|---------|-------------|
| `RAILS_MASTER_KEY` |  | decryption key for secrets |
| `CLICKR_SUGGEST_NEW_LESSON_AFTER_MINUTES` | `120` | |
| `CLICKR_SHOW_VIRTUAL_BUTTONS_LINK` | `false` | (in `RAILS_ENV=development`: default `true`) |
| `CLICKR_BENCHMARK_BUFFER` | `5` | how high you can set the lesson benchmark compared to the best student |
| `CLICKR_INITIAL_STUDENT_RESPONSE_PERCENTAGE` | `77` | influences the grade, practically a virtual first lesson |
| `CLICKR_STUDENT_ABSENT_IF_LESSON_SUM_LESS_THAN_OR_EQUAL_TO` |  | threshold when to consider student absent <ul><li>absent students are ignored in the class lesson average</li><li>lessons in which the student was absent are ignored in his average grade</li></ul> |
| `CLICKR_ROLL_THE_DICE_DURATION_MS` | `3000` | How long should the animation for selecting a student (roll the dice) take overall in milliseconds |
| `ZSTACK_ZIGBEE_DEVICE` | `/dev/ttyACM0` |  |
| `ZSTACK_ZIGBEE_PERMIT_JOIN` | `true` |  |
| `ZSTACK_ZIGBEE_PAN_ID` | `0x1a63` |  |
| `ZSTACK_ZIGBEE_EXTENDED_PAN_ID` | `0x62c089def29a0295` |  |
| `ZSTACK_ZIGBEE_NETWORK_KEY` | `0x44a6a5fbe41d8844ac7f0778a261f9c5` |  |
| `ZSTACK_ZIGBEE_CHANNEL` | `11` | Use a ZLL channel (11, 15, 20, or 25) to avoid Problems |
