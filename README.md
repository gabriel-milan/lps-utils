# LPS Cluster

## Setting up a node
In order to set up a new node, you will need to have a just-formatted machine running CentOS (preferably) and root privileges.

### The main script
This step should be done on the node machine.

The script on `new_node/` will make most of the stuff needed to set up the node, as downloading dependencies and disabling firewall, for example. This should be ran before anything else.

#### Option 1 - without git
* Get root privileges:
	```
	sudo -i
	```
* Just copy and paste the command lines inside the script to your CLI.

#### Option 2 - with git
* Clone this repository:
	```
	git clone https://github.com/gabriel-milan/lps-utils
	```
* Go to the script directory:
	```
	cd lps-utils/new_node/
	```
* Run it:
	```
	bash initial_setup.sh
	```

### Last steps
This was made to be as simple as it could be, so here we are at the last steps:

#### Disabling SELinux
This step should be done on the node machine.

To assure the system will work fine with Rancher/Kubernetes, SELinux must be disabled. The steps are shown below:

* Open the `/etc/selinux/config` file and set the `SELINUX` mod to `disabled`, the content of the file will look like this:
	```
	# This file controls the state of SELinux on the system.
	# SELINUX= can take one of these three values:
	#       enforcing - SELinux security policy is enforced.
	#       permissive - SELinux prints warnings instead of enforcing.
	#       disabled - No SELinux policy is loaded.
	SELINUX=disabled
	# SELINUXTYPE= can take one of these two values:
	#       targeted - Targeted processes are protected,
	#       mls - Multi Level Security protection.
	SELINUXTYPE=targeted
	```	

#### Enable sudo privileges without password
This step should be done on the node machine.

* Edit the `sudoers` file:
	```
	sudo visudo
	```
* At the end of the file, add this line:
	```
	rancher ALL=(ALL) NOPASSWD:ALL
	```
#### Copy SSH credentials into the node
This step should be done on the **front-end** machine.

* On the **front-end** machine, run
	```
	ssh-copy-id -i ~/.ssh/id_rsa.pub rancher@<node-ip>
	```

### Final considerations
After these steps, the node machine is ready for joining the Rancher cluster, you could just run the command Rancher will provide you and wait for it.