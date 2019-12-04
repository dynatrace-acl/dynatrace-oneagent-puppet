# Dynatrace OneAgent module for puppet

## Description

This module installs the OneAgent on Linux, Windows and AIX Operating Systems

## Requirements

Requires [puppet/archive](https://forge.puppet.com/puppet/archive)

Requires [puppet-labs/reboot](https://forge.puppet.com/puppetlabs/reboot) for Windows reboots

## Installation

Available from GitHub (via cloning) or via Puppet forge [dynatrace/dynatraceoneagent](https://forge.puppet.com/dynatrace/dynatraceoneagent)

Refer to the customize OneAgent installation documentation on [Dynatrace Supported Operating Systems](https://www.dynatrace.com/support/help/technology-support/operating-systems/)

## Usage

Default OneAgent install parameters defined in params.pp as a hash map: INFRA_ONLY=0, APP_LOG_CONTENT_ACCESS=1

Sample OneAgent installation using a managed tenant with a specific version. The required version of the OneAgent must be in 1.155.275.20181112-084458 format.

    class { 'dynatraceoneagent':
        tenant_url  => 'https://{your-domain}/e/{your-environment-id}',
        paas_token  => '{your-paas-token}',
        version     => '1.181.63.20191105-161318',
    }

Sample latest OneAgent version installation using a SAAS tenant

    class { 'dynatraceoneagent':
        tenant_url  => 'https://{your-environment-id}.live.dynatrace.com',
        paas_token  => '{your-paas-token}',
    }

## Advanced configuration

Download to custom directory with additional OneAgent install parameters and reboot server after install should be defined as follows (will override default params):

    class { 'dynatraceoneagent':
        tenant_url            => 'https://{your-environment-id}.live.dynatrace.com',
        paas_token            => '{your-paas-token}',
        version               => '1.181.63.20191105-161318',
        download_dir          => 'C:\\Download Dir\\',
        reboot_system         => true,
        oneagent_params_hash  => {
            'INFRA_ONLY'             => '0',
            'APP_LOG_CONTENT_ACCESS' => '1',
            'HOST_GROUP'             => 'PUPPET_WINDOWS',
            'INSTALL_PATH'           => 'C:\Test Directory',
        }
    }

For Windows, because download_dir is a string variable, 2 backslashes are required.

Since the oneagent install parameter INSTALL_PATH is defined within a hash map, no escaping is needed for Windows file paths.

For further information on how to handle file paths on Windows, visit [Handling file paths on Windows](https://puppet.com/docs/puppet/4.10/lang_windows_file_paths.html)