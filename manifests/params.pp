class slack::params {

  $slack_webhook        = undef,
  $slack_iconurl        = undef,
  $slack_channel        = undef,
  $slack_botname        = undef,
  $slack_puppet_reports = undef,
  $slack_puppet_dir     = undef,
  $is_puppetmaster      = undef,

  # assume that the master this is being enforced on is the same configuration as the one compiling
  $puppet_confdir     = $::settings::confdir

  if $::pe_server_version {
    $gem_provider     = 'puppetserver_gem'
  }
  elsif str2bool($::is_pe) {
    0 {
      $gem_provider = 'pe_puppetserver_gem'
    }
    else {
      $gem_provider = 'pe_gem'
    }
  } else {
    $gem_provider     = 'gem'
  }
}
