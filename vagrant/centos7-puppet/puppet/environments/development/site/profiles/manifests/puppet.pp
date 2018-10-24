# Installs r10 and hiera-eyaml modules, and makes them available on the classpath.

class profiles::puppet {
    notice("applying profiles::puppet")

    $packages = [ 
        'r10k', 
        'hiera-eyaml',
    ]

    $packages.each | $package| {
        package { $package:
            provider => 'puppet_gem',
            ensure   => present,
        }
    }

    # Shell profile for Puppet

    $puppet_profile = @(EOT)
        # /etc/profile.d/puppet.sh - Managed by Puppet - do not change
        if ! echo $PATH | grep -q /opt/puppetlabs/puppet/bin ; then
            export PATH=$PATH:/opt/puppetlabs/puppet/bin
        fi
        |EOT

    file { '/etc/profile.d/puppet.sh':
        content => $puppet_profile,
    }
}
