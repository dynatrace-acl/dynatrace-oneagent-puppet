# Class: dynatraceoneagent  See README.md for documentation.
# ============================================
#
# This module installs the dynatrace one agent on the host.
# Currently supported for Linux, AIX and Windows Operating Systems
#
#   Parameters for the OneAgent Download:
#
#   * $tenant_url                 => URL of your dynatrace Tenant - Managed https://{your-domain}/e/{your-environment-id}, SaaS 
#                                    https://{your-environment-id}.live.dynatrace.com
#   * $paas_token                 => PAAS token for downloading one agent installer
#   * $version                    => The required version of the OneAgent in 1.155.275.20181112-084458 format. Default is latest and will 
#                                     default to most recent version
#   * $arch                       => The architecture of your OS - default is all
#   * $installer_type             => The type of the installer - default is default
#
#   Parameters for the OneAgent Installer:
#   * download_dir                => OneAgent installer file download directory. Defaults are
#                                    Linux/AIX : /tmp/
#                                    Windows   : C:\Windows\Temp\
#
#   Hash map of additional parameters to pass to the installer
#   * Default OneAgent install parameters defined in params.pp as a hash map: 'INFRA_ONLY=0' 'APP_LOG_CONTENT_ACCESS=1'
#   Additional OneAgent install parameters should be defined as follows (will override default params):
#      oneagent_params_hash  => {
#          'INFRA_ONLY'             => '0',
#          'APP_LOG_CONTENT_ACCESS' => '1',
#          'HOST_GROUP'             => 'PUPPET_WINDOWS',
#          'INSTALL_PATH'           => 'C:\Test Directory',
#     }
#   Refer to the Customize OneAgent installation documentation on https://www.dynatrace.com/support/help/technology-support/operating-systems/
#   * $reboot_system                => If set to true, puppet will reboot the server after installing the OneAgent - default is false

class dynatraceoneagent (

# OneAgent Download Parameters
  $tenant_url                           = $dynatraceoneagent::params::tenant_url,
  $paas_token                           = $dynatraceoneagent::params::paas_token,
  String $version                       = $dynatraceoneagent::params::version,
  String $arch                          = $dynatraceoneagent::params::arch,
  String $installer_type                = $dynatraceoneagent::params::installer_type,
  String $os_type                       = $dynatraceoneagent::params::os_type,

#OneAgent Install Parameters
  String $download_dir                   = $dynatraceoneagent::params::download_dir,
  String $service_name                   = $dynatraceoneagent::params::service_name,
  String $provider                       = $dynatraceoneagent::params::provider,
  String $default_install_dir            = $dynatraceoneagent::params::default_install_dir,
  Hash $oneagent_params_hash             = $dynatraceoneagent::params::oneagent_params_hash,

  Boolean $reboot_system       = $dynatraceoneagent::params::reboot_system,

) inherits dynatraceoneagent::params {

    if $oneagent_params_hash['INSTALL_PATH']{
      $install_dir = $oneagent_params_hash['INSTALL_PATH']
    } else {
      $install_dir = $default_install_dir
    }

    if $version == 'latest' {
      $download_link  = "${tenant_url}/api/v1/deployment/installer/agent/${os_type}/${installer_type}/latest/?Api-Token=${paas_token}&flavor=default&arch=${arch}"
    } else {
      $download_link  = "${tenant_url}/api/v1/deployment/installer/agent/${os_type}/${installer_type}/version/${version}?Api-Token=${paas_token}&flavor=default&arch=${arch}"
    }

    if $::osfamily == 'Windows' {
      $filename                = "Dynatrace-OneAgent-${::osfamily}-${version}.exe"
      $download_path           = "${download_dir}${filename}"
      $created_dir             = "${install_dir}\\agent\\agent.state"
    } elsif ($::kernel == 'Linux') or ($::osfamily  == 'AIX') {
      $filename                = "Dynatrace-OneAgent-${::kernel}-${version}.sh"
      $download_path           = "${download_dir}${filename}"
      $oneagent_params_array   = $oneagent_params_hash.map |$key,$value| { "${key}=${value}" }
      $oneagent_unix_params    = join($oneagent_params_array, ' ' )
      $command                 = "${download_path} ${oneagent_unix_params}"
      $created_dir             = "${install_dir}/agent/agent.state"
    }

  #notify { "params hash is: ${oneagent_params_hash}": }

  contain dynatraceoneagent::install
  contain dynatraceoneagent::service

  Class['::dynatraceoneagent::install']
  ~> Class['::dynatraceoneagent::service']
}
