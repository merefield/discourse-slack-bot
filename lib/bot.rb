# frozen_string_literal: true
# Slack bot class
module SlackBot
  class Bot < SlackRubyBot::Bot
    cattr_reader :SlackBot, :SlackClient

    @@SlackBot = nil
    @@SlackClient = nil

    def self.init
      require 'console/logger.rb'

      return if !@@SlackBot.nil?
      
      Slack.configure do |config|
        config.token = SiteSetting.slack_bot_token
      end

      Slack::RealTime::Client.configure do |config|
        config.start_method = :rtm_connect
      end

      @@SlackBot = SlackRubyBot::Server.new(token: SiteSetting.slack_bot_token, aliases: ['slackbot'])
      @@SlackClient = Slack::Web::Client.new(token: SiteSetting.slack_user_token)

      @@SlackBot.run

      @@SlackBot
    end

    def self.discord_bot
      @@SlackBot
    end

    def self.run_bot
      bot = self.init
    end
  end
end
