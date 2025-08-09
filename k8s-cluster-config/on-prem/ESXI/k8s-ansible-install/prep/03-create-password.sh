#!/bin/bash

IPS=(
172.31.3.212
172.31.8.89     
172.31.11.120   
172.31.13.234   
172.31.14.41    
172.31.12.93    
172.31.8.44
)

for IP in "${IPS[@]}"; do
  echo "Updating password on $IP"
  ssh -o StrictHostKeyChecking=no -i ~/.ssh/ansible ubuntu@$IP "echo 'ubuntu:ubuntu' | sudo chpasswd"
done
