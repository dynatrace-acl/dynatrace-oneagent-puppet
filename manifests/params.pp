# Class: dynatraceoneagent::params
#
#
# Dynatrace OnaAgent default settings and according to operating system
#
class dynatraceoneagent::params {

    # OneAgent Download Parameters
    $tenant_url         = undef
    $paas_token         = undef
    $version            = 'latest'
    $arch               = 'all'
    $installer_type     = 'default'

    #OneAgent Install Parameters
    $install_dir        = undef
    $oneagent_params_hash = {
        'INFRA_ONLY'             => '0',
        'APP_LOG_CONTENT_ACCESS' => '1',
    }

    $reboot_system      = false

    if $::osfamily == 'Windows' {
        #Parameters for Windows OneAgent Download
        $os_type        = 'windows'
        $download_dir   = 'C:\\Windows\\Temp\\'
        #Parameters for Windows OneAgent Installer
        $service_name   = 'Dynatrace OneAgent'
        $provider       = 'windows'
        $default_install_dir = 'C:\\Program Files (x86)\\dynatrace\\oneagent'
    } elsif $::osfamily == 'AIX' {
        #Parameters for AIX OneAgent Download
        $os_type        = 'aix'
        $download_dir   = '/tmp/'
        #Parameters for AIX OneAgent Installer
        $service_name   = 'oneagent'
        $provider       = 'shell'
        $default_install_dir = '/opt/dynatrace/oneagent'
    } elsif $::kernel == 'Linux' {
        #Parameters for Linux OneAgent Download
        $os_type        = 'unix'
        $download_dir   = '/tmp/'
        #Parameters for Linux OneAgent Installer
        $service_name   = 'oneagent'
        $provider       = 'shell'
        $default_install_dir = '/opt/dynatrace/oneagent'
    }
}
