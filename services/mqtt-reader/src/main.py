import logging, os, sys

from MqttClient import MqttClient
from ApiClient import ApiClient

logging.basicConfig(stream=sys.stdout, level=logging.INFO)
log = logging.getLogger(__name__)


def main():
    post_endpoint = os.getenv('CLICKR_POST_ENDPOINT', 'http://localhost:3000/clicks')
    mqtt_host = os.getenv('MQTT_HOST', 'localhost')
    log.info(f"Params:\n  POST_ENDPOINT: {post_endpoint}\n  MQTT_HOST: {mqtt_host}")

    token_id_handler = ApiClient(post_endpoint = post_endpoint).submit_token_id
    client = MqttClient(token_id_handler, broker_host=mqtt_host)
    client.loop_forever()
    # TODO clean stop

if __name__ == '__main__':
    main()
