import evdev
import logging, os, sys

logging.basicConfig(stream=sys.stdout, level=logging.INFO)
log = logging.getLogger(__name__)

# http://blog.ssokolow.com/archives/2017/11/02/usb-rfid-reader-on-linux-proof-of-concept/
# https://python-evdev.readthedocs.io/en/latest/tutorial.html
class Device:
    def __init__(self, ev_device, debounce_seconds):
        ev_device.grab()
        self.accumulator = []
        self.ev_device = ev_device
        self.last_seen = {}
        self.debounce_seconds = debounce_seconds

    def __del__(self):
        self.ev_device.ungrab()

    def handle_token_id(self, timestamp, token_id):
        # Debounce
        last_seen = self.last_seen.get(token_id, 0)
        if timestamp - last_seen < self.debounce_seconds:
            return
        self.last_seen[token_id] = timestamp

        if len(token_id) != 10:
            log.error("Invalid token ID (len != 10)")
            return

        log.info(f"Token: {token_id}")

    def handle_event(self, event):
        if event.type != evdev.ecodes.EV_KEY:
            return  # Ignore non-key events

        keyboard_event = evdev.categorize(event)
        if keyboard_event.keystate != keyboard_event.key_down:
            return  # Ignore key release events

        keyname = keyboard_event.keycode[4:]
        if keyname == 'ENTER':
            self.handle_token_id(int(event.sec), ''.join(self.accumulator))
            self.accumulator = []
        elif len(keyname) == 1 and keyname in '1234567890':
            self.accumulator.append(keyname)

    async def async_handle_event(self):
        async for event in self.ev_device.async_read_loop():
            self.handle_event(event)
