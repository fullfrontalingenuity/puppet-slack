class slack::params {

  $slack_webhook        = undef
  $slack_iconurl        = undef
  $slack_channel        = undef
  $slack_botname        = undef
  $slack_puppet_reports = undef
  $slack_puppet_dir     = $::settings::confdir
  $is_puppetmaster      = undef

  if str2bool($::is_pe) {
    $gem_provider = 'puppetserver_gem'
  }
  else {
    $gem_provider = 'gem'
  }
}
