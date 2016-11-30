# Mosquitto Server Running on Openshift

Client connect via websockets

* oc new-project mosquitto
* oc new-app https://github.com/noelo/ocp-mosquitto.git
* oc create configmap mosquitto-config --from-file=ose-mosquitto.conf
* oc volume dc/ocp-mosquitto --add -t configmap --configmap-name='mosquitto-config' --mount-path=/etc/mosquitto/
* oc expose service/ocp-mosquitto --port 9001


Use HIVE MQ client to test --> https://github.com/hivemq/hivemq-mqtt-web-client
Point it to the exposed route on port 80

## Possible future enhancements
* MQTT over SSL (with SNI)
* Persistent storeage mounted onto OCP volumes
* WS over TLS
