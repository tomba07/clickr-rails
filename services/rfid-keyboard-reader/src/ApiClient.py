# TODO Extract into common /lib folder (used in several services)

import logging, sys
import requests

logging.basicConfig(stream=sys.stdout, level=logging.INFO)
log = logging.getLogger(__name__)


class ApiClient:
    def __init__(self, post_endpoint):
        self.post_endpoint = post_endpoint

    def submit_token_id(self, token_id):
        r = requests.post(
            self.post_endpoint, json={"device_id": token_id, "device_type": "rfid"}
        )
        if r.status_code == 200:
            log.info(f"Successfully submitted token {token_id}")
        else:
            log.error(
                f"Failed to submit token {token_id}, status: {r.status_code}, response: {r.text}"
            )
