# Getting info about Bluetti EB3A 268Wh via bluetooth

```code
$ pip install bluetti_mqtt

# apt-get install mosquitto mosquitto-clients

# systemctl status mosquitto

$ bluetti-mqtt --scan
Scanning....
Found EB3A2244001436852: address E3:16:48:6C:7C:8A

$ bluetti-mqtt --broker 127.0.0.1 E3:16:48:6C:7C:8A
...
INFO     Sent discovery message of EB3A-2244001436852 to Home Assistant


mosquitto_sub -t "bluetti/state/EB3A-2244001436852/total_battery_percent"
mosquitto_sub -t "bluetti/state/EB3A-2244001436852/ac_output_power"
mosquitto_sub -t "bluetti/state/EB3A-2244001436852/dc_output_power"

mosquitto_sub -t "bluetti/state/EB3A-2244001436852/ac_input_voltage"
mosquitto_sub -t "bluetti/state/EB3A-2244001436852/ac_input_power"
```

Source of MQTT Topics:  
https://github.com/warhammerkid/bluetti_mqtt/blob/6fbfb767d222a90b6af7aca1a6f16b03682be0be/bluetti_mqtt/mqtt_client.py

Info about Mosquitto:  
https://www.vultr.com/docs/install-mosquitto-mqtt-broker-on-ubuntu-20-04-server/
