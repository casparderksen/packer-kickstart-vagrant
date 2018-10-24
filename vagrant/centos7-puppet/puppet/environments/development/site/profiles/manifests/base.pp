# Common server configuration baseline.

class profiles::base {
    notice("applying profiles::base")

    # Install default packages

    $packages = [
        'acpid',
        'deltarpm',
        'rng-tools',
    ]

    $packages.each |$package| {
        package { $package:
            ensure => present,
        }
    }

    # Start RNGD service for sufficient entropy collection in virtual machine

    service { 'rngd':
        ensure  => running,
        require => Package['rng-tools'],
    }
}
