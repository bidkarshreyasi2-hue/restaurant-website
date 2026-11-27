#!/bin/bash
# Usage: deploy.sh <ec2-public-ip> <path-to-ssh-key>
# Copies the website to EC2 and restarts Nginx (Amazon Linux 2023, user ec2-user)
set -e
HOST="$1"; KEY="$2"; USER_NAME="ec2-user"
SSH="ssh -o StrictHostKeyChecking=no -o ConnectTimeout=20 -i $KEY $USER_NAME@$HOST"

tar czf /tmp/site.tgz index.html menu.html order.html css js
scp -o StrictHostKeyChecking=no -i "$KEY" /tmp/site.tgz $USER_NAME@$HOST:/tmp/site.tgz
$SSH "sudo rm -rf /usr/share/nginx/html/* && sudo tar xzf /tmp/site.tgz -C /usr/share/nginx/html && sudo chown -R nginx:nginx /usr/share/nginx/html && sudo systemctl restart nginx"
echo "Deployed to http://$HOST"
