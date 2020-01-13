import paho.mqtt.client as mqtt
import logging, sys

# TODO Use logger
logging.basicConfig(stream=sys.stdout, level=logging.INFO)
log = logging.getLogger(__name__)

class MqttClient(mqtt.Client):
    def __init__(self, token_id_handler, broker_host='mqtt', broker_port=1883):
        super().__init__(protocol=mqtt.MQTTv31)
        self.token_id_handler = token_id_handler
        self.connect(broker_host, broker_port, 60)
        self.subscribe("#", 0)

    # TODO not connecting
    def on_connect(mqttc, obj, flags, rc):
        print("rc: " + str(rc))


    def on_message(mqttc, obj, msg):
        print(msg.topic + " " + str(msg.qos) + " " + str(msg.payload))
        # TODO Use proper token ID
        # token_id = 1
        # if callable(self.token_id_handler): self.token_id_handler(token_id)


    def on_publish(mqttc, obj, mid):
        print("mid: " + str(mid))


    def on_subscribe(mqttc, obj, mid, granted_qos):
        print("Subscribed: " + str(mid) + " " + str(granted_qos))


# Uncomment to enable debug messages
# def on_log(mqttc, obj, level, string):
#     print(string)
