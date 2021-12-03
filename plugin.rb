# frozen_string_literal: true
# name: discourse slack bot
# about: Integrate Slack Bots with Discourse
# version: 0.01
# authors: Robert Barrow
# url: https://github.com/merefield/discourse-slack-bot

gem 'slack-ruby-bot'
gem 'async-websocket', '~>0.8.0'

require 'slack-ruby-bot'

enabled_site_setting :slack_bot_enabled

after_initialize do

  %w[
    ../lib/engine.rb
    ../lib/bot.rb
    ../lib/bot_commands.rb
    ../lib/discourse_events_handlers.rb
    ../lib/slack_events_handlers.rb
  ].each do |path|
    load File.expand_path(path, __FILE__)
  end

  bot_thread = Thread.new do
    begin
      ::SlackBot::Bot.run_bot
    rescue Exception => ex
      Rails.logger.error("Discord Bot: There was a problem: #{ex}")
    end
  end

  STDERR.puts '------------------------------------------------'
  STDERR.puts 'Bot should now be spawned, say "Ping!" on Slack!'
  STDERR.puts '------------------------------------------------'
  STDERR.puts '(------      If not check logs          -------)'
end
