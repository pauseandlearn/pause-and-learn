
#!/bin/bash
servers=(
172.31.3.212
172.31.8.89     
172.31.11.120   
172.31.13.234   
172.31.14.41    
172.31.12.93    
172.31.8.44)
user="ubuntu"

for ip in "${servers[@]}"; do
  echo "Updating $ip..."
  ssh -i ~/.ssh/ansible "$user@$ip" "sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config.d/60-cloudimg-settings.conf && sudo systemctl restart ssh"
done