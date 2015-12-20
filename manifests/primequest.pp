class fujitsusvagents::primequest inherits fujitsusvagents {


service { ['y10SVmco', 'y30SVmco', 'y40SVmco'] :
        ensure => 'running',
        enable => 'true',
#       require => Package["SVmco*"],
}

if ( $primequest_partition_mgmt_ip != undef ){

#augeas { "Partition Management IP":
# 	 notify  => Service[y30SVmco],
#  	context => "/files/etc/fujitsu/SVmco/usr/ipsetup.conf",
#  	changes => [
#    		"set ManagementIP $primequest_partition_mgmt_ip",
#  		];
#}


file_line { "Partition Management IP":
	ensure => present,
	path => "/etc/fujitsu/SVmco/usr/ipsetup.conf",  
  	line => "ManagementIP=$primequest_partition_mgmt_ip",
	match   => "^ManagementIP=.*$",
	notify => [ Exec['mgmtip_change_eec'], Service['y30SVmco'] ],
}

exec { "mgmtip_change_eec": 
	command => "/usr/sbin/eecdcp -c oc=E002 oe=000C \\'$primequest_partition_mgmt_ip\\'",
	refreshonly => true,
}


}


if ( $primequest_partition_id != undef ){
	$primequest_partition_psa_ip = sprintf('172.30.0.%d',$primequest_partition_id+2)

	file_line { "PSA-to-MMB IP":
        ensure => present,
        path => "/etc/fujitsu/SVmco/usr/tommbipsetup.conf",
        line => "TOMMBIP=$primequest_partition_psa_ip",
        match   => "^TOMMBIP=.*$",
	notify => Service['y30SVmco'],
	}


}else{
	notify {"no partition id configured":}
}



}
