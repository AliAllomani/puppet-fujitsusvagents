# == Class: fujitsusvagents
#
# Install Fujitsu ServerView Agents
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
#
# === Authors
#
# Ali Allomani <ali.allomani@ts.fujitsu.com>
#
# === Copyright
#
# Copyright 2015 Ali Allomani, unless otherwise noted.
#
class fujitsusvagents (

$primequest_partition_mgmt_ip = undef,
$primequest_partition_id = undef,

){

#exec { 'yum-clean-metadata':
#          user => 'root',
#          path => '/usr/bin',
#          command => 'yum clean metadata',
#}

package { 'sblim-sfcb':
	ensure => 'present',
#	require => Exec['yum-clean-metadata'],
}

service { 'sblim-sfcb':
	ensure => 'running',
	enable => true,
	require => Package['sblim-sfcb'],
}

package { 'net-snmp':
	ensure => 'present',
}

service { 'snmpd':
	ensure => 'running',
	enable => true,
	require => Package['net-snmp'],
}


$primergy_linux_drvs = [ 'kmod-smbus', 'primergy-smbus', 'ServerViewConnectorService', 'srv-cimprovider', 'srvmagt-agents', 'srvmagt-eecd', 'srvmagt-mods_src', 'SSMWebUI', 'SVSystemMonitor' ]

package { $primergy_linux_drvs:
        ensure => 'latest',
	require => [ Service['sblim-sfcb'], Service['snmpd'] ],
}

service { 'srvmagt':
	ensure => 'running',
	enable => true,
	require => [ Package['srvmagt-agents'], Package['srvmagt-eecd'], Package['srvmagt-mods_src'], Service['eecd'] ],
}

service { 'eecd':
	ensure => 'running',
	enable => true,
	require => Package['srvmagt-eecd'],
}

if $productname =~ /^PRIMEQUEST 18/ {
	include fujitsusvagents::primequest
}


}
