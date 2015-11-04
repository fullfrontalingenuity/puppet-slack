class slack::params {

  $slack_webhook        = undef
  $slack_iconurl        = undef
  $slack_channel        = undef
  $slack_botname        = undef
  $slack_puppet_reports = undef
  $slack_puppet_dir     = $::settings::confdir
  $is_puppetmaster      = undef

  if $::pe_server_version {
    notice('pe_server_version was found')
    $gem_provider = 'puppetserver_gem'
  }
  elsif str2bool($::is_pe) {
    notice('is_pe was true')
    $gem_provider = 'pe_puppetserver_gem'
  }
  else {
    notice('last resort')
    $gem_provider = 'gem'
  }
}
