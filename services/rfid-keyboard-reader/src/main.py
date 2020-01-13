import asyncio
import evdev
import logging, os, sys

from Device import Device
from ApiClient import ApiClient

logging.basicConfig(stream=sys.stdout, level=logging.INFO)
log = logging.getLogger(__name__)


def parse_usb_id(id):
    return tuple(map(lambda x: int(x, 16), id.split(":")))


def parse_usb_ids(env_var):
    return [parse_usb_id(id) for id in env_var.split(",") if id]


def get_device(path, usb_ids, debounce_seconds, token_id_handler):
    device = evdev.InputDevice(path)
    if (device.info.vendor, device.info.product) not in usb_ids:
        return None
    return Device(
        ev_device=device,
        debounce_seconds=debounce_seconds,
        token_id_handler=token_id_handler,
    )


def main():
    usb_ids_raw = os.getenv("RFID_KEYBOARD_READER_USB_IDS", "")
    debounce_seconds_raw = os.getenv("RFID_KEYBOARD_READER_DEBOUNCE_SECONDS", "3")
    post_endpoint = os.getenv("CLICKR_POST_ENDPOINT", "http://localhost:3000/clicks")
    log.info(
        f"Params (raw):\n  USB_IDS: {usb_ids_raw}\n  DEBOUNCE_SECONDS: {debounce_seconds_raw}\n  POST_ENDPOINT: {post_endpoint}"
    )
    usb_ids = parse_usb_ids(usb_ids_raw)
    debounce_seconds = int(debounce_seconds_raw)
    log.info(
        f"Params (parsed):\n  USB_IDS: {usb_ids}\n  DEBOUNCE_SECONDS: {debounce_seconds}\n  POST_ENDPOINT: {post_endpoint}"
    )

    if not usb_ids:
        log.error("USB_IDS was empty. Exiting.")
        sys.exit(1)
        return

    token_id_handler = ApiClient(post_endpoint=post_endpoint).submit_token_id
    all_devices = [
        get_device(path, usb_ids, debounce_seconds, token_id_handler)
        for path in evdev.util.list_devices()
    ]
    selected_devices = [dev for dev in all_devices if dev]

    log.info(
        f"Watching {len(selected_devices)} devices: {[dev.ev_device.path for dev in selected_devices]})"
    )

    for device in selected_devices:
        asyncio.ensure_future(device.async_handle_event())
    loop = asyncio.get_event_loop()
    loop.run_forever()
    # TODO clean stop https://www.roguelynn.com/words/asyncio-graceful-shutdowns/


if __name__ == "__main__":
    main()
