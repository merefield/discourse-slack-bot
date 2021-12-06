# frozen_string_literal: true
# name: discourse slack bot
# about: Integrate Slack Bots with Discourse
# version: 0.01
# authors: Robert Barrow
# url: https://github.com/merefield/discourse-slack-bot




gem 'timers', '4.3.3', require: false
gem 'fiber-local', '1.0.0', require: false
gem 'console', '1.14.0', require: false

gem 'protocol-http', '0.22.5', require: false
gem 'protocol-hpack', '1.4.2', require: false
gem 'protocol-http1', '0.14.2', require: false
gem 'protocol-websocket', '0.7.5', require: false
gem 'protocol-http2', '0.14.2', require: false

gem 'async', '1.30.1', require: false
gem 'async-pool', '0.3.9', require: false
gem 'async-io', '1.32.2', require: false
gem 'async-http', '0.56.5', require: false

gem 'async-websocket', '0.19.0', require: false


gem 'websocket-extensions', '0.1.5', require: false
gem 'websocket-driver', '0.7.5', require: false
gem 'gli', '2.20.1', require: false
gem 'faraday_middleware', '1.2.0', require: false
gem 'slack-ruby-client', '0.17.0', require: false
gem 'slack-ruby-bot', '0.16.1', require: false

require 'slack-ruby-bot'

enabled_site_setting :slack_bot_enabled

after_initialize do

  %w[
    ../lib/bot.rb
    ../commands/calculate.rb
    ../commands/pong.rb
  ].each do |path|
    load File.expand_path(path, __FILE__)
  end

  #../lib/discourse_events_handlers.rb
  #../lib/slack_events_handlers.rb


  if SiteSetting.slack_bot_enabled && !SiteSetting.slack_bot_token.blank?
    Thread.abort_on_exception = true

    bot_thread = Thread.new do
      begin
        ::SlackBot::Bot.run_bot
      rescue Exception => ex
        Rails.logger.error("Slack Bot: There was a problem: #{ex}")
      end
    end

    STDERR.puts '------------------------------------------------'
    STDERR.puts 'Bot should now be spawned, say "Ping!" on Slack!'
    STDERR.puts '------------------------------------------------'
    STDERR.puts '(------      If not check logs          -------)'
  end
end
