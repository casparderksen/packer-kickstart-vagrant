Export all certificates in your local CA chain to .cer files in this directory.
Then adapt the certificate names in the Makefile and run make for generating
local trust stores for Java and Linux. Finally, run the Ansible tasks for
installing the trust stores.
