

USERNAME=ubuntu
for ip in 
172.31.3.212
172.31.8.89     
172.31.11.120   
172.31.13.234   
172.31.14.41    
172.31.12.93    
172.31.8.44; do ssh-copy-id -i ~/.ssh/ansible $USERNAME@$ip; done