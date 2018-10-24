# Generate your own eyaml keys

For security, replace the eyaml keys with your own and don't store
the private key in version control.

To generate your own keys type:

    ```console
    $ cd /vagrant/puppet/eyaml
    $ eyaml createkeys
    ```

If your Puppet developers don't need to encrypt secrets on their local
working environments, keep the secret key on the puppet master and remove
the private key from the eyaml configuration.

# Eyaml usage

Encrypt a string:

    ```console
    $ eyaml encrypt -s '<secret>'
    ```console

Edit encrypted secrets in a file:

    ```console
    $ eyaml edit '<file>'
    ```console

See also https://github.com/voxpupuli/hiera-eyaml for using eyaml.
