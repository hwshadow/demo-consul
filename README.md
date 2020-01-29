Original https://github.com/hashicorp/consul/blob/master/demo/docker-compose-cluster/docker-compose.yml
Added: LB in-front of the servers, and physically exposed all the servers to localhost

## START
docker-compose -f hashi.yml up -d

## RAW CONSUL SERVER WEB-UI
- http://localhost:5500
- http://localhost:6500
- http://localhost:7500

## LOADBALANCED CONSUL SERVER WEB-UI
visit http://localhost:8500

## HAPPY
```
~/r/hashi-demo> ./DEMOS_FACT_FAILOVER.sh
hashi-demo_consul-server-1_1
 #docker_ip="172.26.0.3" local_port=5500 docker_ip=19df46549d41
--curl(0): /v1/kv/test/new = es

hashi-demo_consul-server-2_1
 #docker_ip="172.26.0.2" local_port=6500 docker_ip=fb5a611eeaca
--curl(0): /v1/kv/test/new = es

hashi-demo_consul-server-bootstrap_1
 #docker_ip="172.26.0.7" local_port=7500 docker_ip=95aa415169a4
--curl(0): /v1/kv/test/new = es

hashi-demo_consul-server-lb_1
 #docker_ip="172.26.0.8" local_port=8500 docker_ip=235d73bb43de
--curl(0): /v1/kv/test/new = es
```

## FAILOVER
1. create a key/value entry
2. docker stop   __random-consul-server____
3. wait for leader election
4. ./DEMOS_FACT_FAILOVER.sh
5. docker-compose -f hashi.yml up -d

```
~/r/hashi-demo> ./DEMOS_FACT_FAILOVER.sh
hashi-demo_consul-server-1_1
 #docker_ip="172.26.0.3" local_port=5500 docker_ip=19df46549d41
--curl(0): /v1/kv/test/new = es

6500 unavaliable, skipping

hashi-demo_consul-server-bootstrap_1
 #docker_ip="172.26.0.7" local_port=7500 docker_ip=95aa415169a4
--curl(0): /v1/kv/test/new = es

hashi-demo_consul-server-lb_1
 #docker_ip="172.26.0.8" local_port=8500 docker_ip=235d73bb43de
--curl(0): /v1/kv/test/new = es
```
