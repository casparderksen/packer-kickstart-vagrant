# Tips

## Validation of Kickstart files

Install the following package to validate Kickstart files.

    # yum install pykickstart

To validate a file:

    $ ksvalidator /path/to/kickstart.ks

## Encrypt root password in Kickstart file

Use 'grub-crypt --sha-512' to encrypt the root password. In the Kickstart file:

    rootpw --iscrypted <CRYPTED_PASSWD>
