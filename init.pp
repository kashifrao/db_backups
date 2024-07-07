# == Class:  db_backups
#
# Creates a cron job that archives Apache and Tomcat logs.
#
# === Copyright
#
# Copyright (c) 2016, NCI, Australian National University.
# All Rights Reserved.
#


class db_backups( 
) 
{

  $backup_source_path   = '/opt/admincloud/database_backup'
  $days_to_keep         = '1'
  $script               = "${backup_source_path}/backup.py"
  $dirs_name = ["${backup_source_path}","${backup_source_path}/conf"]
  
   
  
 
  # ----------------------------------------------------------------------------
  # Create database backup source dirs
  
  $dirs_name.each |String $dirs| {
  
    file { $dirs:
      ensure  => directory,
      owner   => 'root',
      group   => 'root',
      mode    => '0744',
    }
  }
  
   
  # Create Main backup runtime file
  file { "${backup_source_path}/backup.py" :
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0744',
    content => template("db_backups/backup_py.erb"),
  }

  file { "${backup_source_path}/conf/setup_conf.py" :
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0744',
    content => template("db_backups/setup_conf_py.erb"),
  }
  
  file { "${backup_source_path}/conf/Logger.py" :
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0744',
    content => template("db_backups/logger_py.erb"),
  }
  
  file { "${backup_source_path}/create_db_list.py" :
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0744',
    content => template("db_backups/create_db_list.erb"),
  }
  
  
  # cronjob for database sanity check
  cron { 'Database Sanity Check':
    command => '/opt/admincloud/database_backup/create_db_list.py 2>&1 >& /dev/null',
    user    => 'root', 
    minute  => [28,55],
  }


}