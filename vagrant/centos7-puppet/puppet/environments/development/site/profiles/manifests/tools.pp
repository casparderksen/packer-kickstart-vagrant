# Installs tools and utilities.

class profiles::tools {
    notice("applying profiles::tools")

    $packages = [
        'bash-completion',
        'git-core',
        'git-extras',
        'git-lfs',
        'git-tools',
        'gitflow',
        'man',
        'man-pages',
        'rsync',
        'screen',
        'vim-enhanced',
        'wget',
        'zip',
        'unzip',
    ]

    $packages.each |$package| {
        package { $package:
            ensure => present,
        }
    }
}
