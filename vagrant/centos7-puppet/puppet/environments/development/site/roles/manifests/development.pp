# Installs Puppet development kit and misc tools

class roles::development {

    # Generic server baseline
    include profiles::base

    # Misc tools
    include profiles::tools

    # Puppet development
    include profiles::puppet
    include profiles::pdk
}
