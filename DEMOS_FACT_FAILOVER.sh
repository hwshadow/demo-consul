#!/bin/bash
for i in "5500" "6500" "7500" "8500"; do
  docker_id=$(docker ps | grep "$i->" | awk '{print $1}')
  if [ -z "$docker_id" ]
  then
    echo -e "$i unavaliable, skipping\n"
    continue;
  fi
  docker_name=$(docker ps | grep "$i->" | grep -Eo '\S+$')
  docker_ip=$(docker inspect $docker_id | jq '.[].NetworkSettings.Networks[].IPAddress' | head -n1)
  echo -e "$docker_name\n #docker_ip=$docker_ip local_port=$i docker_ip=$docker_id";
  path='/v1/kv/test/new'
  valuecurl="$(curl --max-time 3 -sk http://localhost:$i$path; exit $?)";
  exitcode=$?
  valuelookup="$(echo $valuecurl | jq -r '.[].Value' | base64 -D)";
  echo "--curl($exitcode): $path = $valuelookup";
  echo '';
done
