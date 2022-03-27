# Automate the Modification of the Sudoers File

## Problems:
$User-A requests multiple servers access and demands that it has the same sudo permission with an existing $User-B


## Solutions

* The shell script will find the user in the sudoers file (Linux, AIX, and Solaris) and try to add $User-A into the sudoers file when it finds $User-B
* An ansible-playbook will deploy this script and run it with root privilege.



Download it and have fun!
