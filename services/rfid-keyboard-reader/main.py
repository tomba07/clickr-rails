import evdev
import os

def parse_usb_id(id):
    return tuple(map(lambda x: int(x, 16), id.split(':')))

def parse_usb_ids(env_var):
    return [parse_usb_id(id) for id in env_var.split(',')]

def is_device_of_interest(path, usb_ids):
    device = evdev.InputDevice(path)
    return (device.info.vendor, device.info.product) in usb_ids

def main(env_var):
    usb_ids = parse_usb_ids(env_var)
    all_devices = [evdev.InputDevice(dev) for dev in evdev.util.list_devices()]
    selected_devices = [dev for dev in all_devices if is_device_of_interest(dev, usb_ids)]

if __name__ == '__main__':
    main(env_var = os.environ['RFID_KEYBOARD_READER_USB_IDS'])