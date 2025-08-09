 
 #### Set up Server

**Step 1: Install  ansible in the bastion host**

- run `sudo apt install ansible -y`


**Step 2: Create an inventory file**

- In the `inventories` directory, create a file with any name of your choice. I called mine `hosts.ini`
-  Copy the content content below and paste, edit ip addresses and save the file.

```bash
[masters]
172.31.1.202

[workers]
172.31.1.10 
172.31.1.13 
172.31.1.22 
172.31.1.14 
172.31.1.16
172.31.1.34

[kubernetes:children]
masters
workers
```
**Step 3: Create ansible config file**

Ansible, depending on the way it was installed has a default folder/directory (`etc/ansible`) where `ansible.cfg`, `hosts` file and `roles` folder are automatically created. You can create your own `ansible.cfg` in your project root directory and this will overite the default `ansible.cfg` and `hosts` file in `/etc/ansible` directory. 

- In your project root directory, create an `ansible.cfg` file and add the following content to it.

```bash

[defaults]
nocows = True
roles_path = ./roles
inventory  = ./inventories/hosts.ini

remote_tmp = $HOME/.ansible/tmp
local_tmp  = $HOME/.ansible/tmp
pipelining = True
private_key_file = ~/.ssh/ansible #path to your ssh private key of the public key you copied earlier to remote servers. NB `ansible` is name of my private key
remote_user = ubuntu
#become = True
host_key_checking = False
deprecation_warnings = False
callback_whitelist = profile_roles, timer
display_skipped_hosts = no
```
 **Step 4: Generate SSH key**

```bash
ssh-keygen -t ed25519  -C "for remote configuration"
```
*-t* is the key type and *-C* is a comment
- navigate to `.ssh` rename `ed25519` file to `ansible`

**Step 5: Create Common Password**
While in `k8s-cluste-config` directory, run `./03-create-password.sh`

**Step 6: Disbale Password Authentication**
The file path completely depends on the version of ubuntu you are using. Check if the version of your ubuntu server if `focal` or `jammy`.  You can disable password authentication *manually* or with *shell script* (prefered). 
- login to your remote servers(each of your servers) and run,

-  i. *Manual steps*
``` bash
sudo vi /etc/ssh/sshd_config.d/60-cloudimg-settings.conf #for ubuntu focal 24
```
 Look for line that says *PassordAuthentication no* and turn it to *PassordAuthentication yes* and then restart `sshd` server by runing

```bash
sudo service sshd restart
sudo service ssh restart
```

- 2. *Shellscript*
Create a script called `disable-pass-auth.sh`. Copy below and paste in it and save it.
```bash
#!/bin/bash

# List of IPs
servers=(172.31.1.202 172.31.1.10 172.31.1.13 172.31.1.22 172.31.1.14)

# SSH user
user="ubuntu"

for ip in "${servers[@]}"; do
  echo "Updating $ip..."
  ssh "$user@$ip" "sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/ssh_config.d/60-cloudimg-settings.conf && sudo systemctl restart ssh"
done
```

**Step 7:  Copy or load the key to each server**

- Run the following command to add or copy the key to all the remote servers.

```bash
ssh-copy-id -i ~/.ssh/ansible.pub username@ip
```
NB
> if the remote servers has the same username as host or ansible master server, simply run

```bash
ssh-copy-id -i ~/.ssh/ansible.pub ip
```
- Assuming that you have numerous servers up with the following IP addresses.
```bash
172.31.1.202 
172.31.1.10 
172.31.1.13 
172.31.1.22 
172.31.1.14 
172.31.1.16
172.31.1.34
```
*NB*
> You can use a single command to copy the key to all of them at once. To do so run `./load-key.sh`

**Step 8: Running ad-hoc Commands**
- Run an ad-hoc Command to test comminucation between your host and remote servers

```bash
 ansible all -i inventories/hosts.ini -m ping # -i means inventory file, -m means module
```
- list all hosts

```bash
ansible all --list-host -i inventories/hosts.ini
```
- Gather facts about hosts

```bash
ansible all -n inventories/hosts.ini -m gather_facts
```
- Gather facts about single host 

```bash
ansible all -n inventories/hosts.ini -m gather_facts --limit 172.31.1.202 #maybe control plane
```
**Step 9: Install your cluster**
- To install k8s cluster with kubeadm, run the following from `k8s-cluster-config` directory

```bash
ansible-playbook cluster-install-playbook.yaml -i inventories/hosts.ini
```