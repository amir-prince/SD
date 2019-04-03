# config valid only for current version of Capistrano

set :application, 'bowlingstar'
set :repo_url, 'git@github.com:Weblibre-consulting/PlanetBowling_Magento.git'
set :log_level, :debug

# url of webhook to communicate with slack
set :slack_url, 'https://hooks.slack.com/services/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'
set :slack_parse, 'full'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 3

set :linked_dirs, fetch(:linked_dirs, []).push("media", "var", "api/websocket/sdasyncws/node_modules")
set :linked_files, fetch(:linked_files, []).push("app/etc/local.xml", "websocket.sh")

#ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

namespace :slack do
  before :notify_finished, :changelog do
      # generate changelog, as we know which revision is the end
      on roles(:web) do
        within release_path do
          releases = capture(:ls, '-xt', releases_path).split
          prev_release_id = capture(:cat, releases_path.join(releases[1].to_s).join('REVISION'))
          changelog = capture(:git, "--git-dir=#{repo_path}", '--no-pager', 'log', "--pretty=format:'%s (%an)'", '--encoding=UTF-8', '--date=short', '--reverse', "#{prev_release_id}..#{fetch(:current_revision)}")
          changelog = changelog.force_encoding("UTF-8")
          set :slack_text, -> {
            "Changelog : #{changelog}"
          }
        end
      end
  end
end

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end