# Installs Puppet Development Kit.

class profiles::pdk {
    notice("applying profiles::pdk")

    package { 'pdk':
        ensure => present,
    }
}
