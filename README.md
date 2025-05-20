# changedSinceSSH
Find changed files since first ssh login

#Description
Checks /etc/ssh/ssh_host_ecdsa_key for the first SSH login to a box and then checks all files that has been changed from that date to a user specified end date. Does some filtering on uninteresting system files and binaries from a baseline (Ubuntu)
