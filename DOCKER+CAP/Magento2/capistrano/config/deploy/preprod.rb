set :domain,       "planetbowling.preprod"
set :deploy_to,    "/var/www/planetbowling/preprod"
set :repo_tree,    "magento"
set :branch,       "preprod"

set :ssh_options, {
  user: 'www-data',
  port: '2222'
}

role :web, "79.137.41.200"
role :app, "79.137.41.200"