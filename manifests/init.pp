# Report processor integration with Slack.com
class slack (
  $slack_webhook        = $slack::params::slack_webhook,
  $slack_iconurl        = $slack::params::slack_iconurl,
  $slack_channel        = $slack::params::slack_channel,
  $slack_botname        = $slack::params::slack_botname,
  $slack_puppet_reports = $slack::params::slack_puppet_reports,
  $slack_puppet_dir     = $slack::params::slack_puppet_dir,
  $is_puppetmaster      = $slack::params::is_puppetmaster,
  $gem_provider         = $slack::params::gem_provider,
) inherits slack::params {

  notice("gem_provider: $gem_provider")

  anchor {'slack::begin':}

  if $is_puppetmaster == true {
    package { 'faraday':
      ensure   => installed,
      provider => gem,
      require  => Anchor['slack::begin'],
      before   => File["${slack_puppet_dir}/slack.yaml"],
    }
  } else {
    #include check_run
    case $::osfamily {
      'redhat','debian': {
        #check_run::task { 'task_faraday_gem_install':
        #  exec_command => '/usr/bin/puppetserver gem install faraday',
        #  require      => Anchor['slack::begin'],
        #  before       => File["${slack_puppet_dir}/slack.yaml"],
        #}
        package {'faraday':
          ensure   => present,
          require  => Anchor['slack::begin'],
          before   => File["${slack_puppet_dir}/slack.yaml"],
          provider => $gem_provider,
        }
      }
      default: {
        fail("Unsupported osfamily ${::osfamily}")
      }
    }
  }

  file { "${slack_puppet_dir}/slack.yaml":
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('slack/slack.yaml.erb'),
  }

  if $slack_puppet_reports {
    ini_setting { 'slack_puppet_reports':
      ensure  => present,
      path    => "${slack_puppet_dir}/puppet.conf",
      section => 'master',
      setting => 'reports',
      value   => $slack_puppet_reports,
      require => File["${slack_puppet_dir}/slack.yaml"],
      before  => Anchor['slack::end'],
    }
  }
  anchor{'slack::end':
    require => File["${slack_puppet_dir}/slack.yaml"],
  }
}
