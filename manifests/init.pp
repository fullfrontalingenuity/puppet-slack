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

  #notify {"slack_webhook:   ${slack_webhook}":}
  #notify {"is_puppetmaster: ${is_puppetmaster}":}
  #notify {"slack_channel:   ${slack_channel}":}
  #notify {"slack_botname:   ${slack_botname}":}
  #notify {"gem_provider:    ${gem_provider}":}

  anchor {'slack::begin':}

  if $is_puppetmaster == true {
    package { 'rubygems':
      ensure  => present,
      require => Anchor['slack::begin'],
    }

    package { 'faraday':
      ensure   => installed,
      provider => "${gem_provider}",
      #require  => Anchor['slack::begin'],
      require  => Package['rubygems'],
      before   => File["${slack_puppet_dir}/slack.yaml"],
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
}
