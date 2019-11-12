import asyncio
import evdev
import logging, os, sys

from Device import Device

logging.basicConfig(stream=sys.stdout, level=logging.INFO)
log = logging.getLogger(__name__)

def parse_usb_id(id):
    return tuple(map(lambda x: int(x, 16), id.split(':')))

def parse_usb_ids(env_var):
    return [parse_usb_id(id) for id in env_var.split(',') if id]

def get_device(path, usb_ids, debounce_seconds):
    device = evdev.InputDevice(path)
    if (device.info.vendor, device.info.product) not in usb_ids:
        return None
    return Device(ev_device = device, debounce_seconds = debounce_seconds)

if __name__ == '__main__':
    usb_ids_raw = os.getenv('USB_IDS', '')
    debounce_seconds_raw = os.getenv('DEBOUNCE_SECONDS', '3')
    log.info(f"Params (raw):\n  usb_ids: {usb_ids_raw}\n  debounce_seconds: {debounce_seconds_raw}")
    usb_ids = parse_usb_ids(usb_ids_raw)
    debounce_seconds = int(debounce_seconds_raw)
    log.info(f"Params (parsed):\n  usb_ids: {usb_ids}\n  debounce_seconds: {debounce_seconds}")

    all_devices = [get_device(path, usb_ids, debounce_seconds) for path in evdev.util.list_devices()]
    selected_devices = [dev for dev in all_devices if dev]

    for device in selected_devices:
        asyncio.ensure_future(device.async_handle_event())
    loop = asyncio.get_event_loop()
    loop.run_forever()
    # TODO clean stop https://www.roguelynn.com/words/asyncio-graceful-shutdowns/
