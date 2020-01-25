# mqtt-video-trigger
Object-oriented Processing sketch for low-latency triggering of videos via MQTT.

### Installation
1. Clone the repository.
```sh
$ git clone https://github.com/samhorne/mqtt-video-trigger.git
```

### Setup
1. [Install Mosquito.](https://mosquitto.org/download/)
2. Install the MQTT library in the Processing Contributions Manager.
3. Place video files in the same folder as the processing sketch.
4. Change the IP address in line 45 to match your MQTT broker.
5. The sketch can be tested using a tool such as [MQTTool](https://apps.apple.com/us/app/mqttool/id1085976398).
