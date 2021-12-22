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

      # byebug

      Slack::RealTime::Client.configure do |config|
        config.start_method = :rtm_connect
      end

      @@SlackBot = SlackRubyBot::Server.new(token: SiteSetting.slack_bot_token, aliases: ['slackbot'])
      @@SlackClient = Slack::Web::Client.new(token: SiteSetting.slack_user_token)


      # byebug
      # @@SlackBot.start_async
      @@SlackBot.run
      
      # @@DiscordBot.ready do |event|
      #   puts "Logged in as #{@@DiscordBot.profile.username} (ID:#{@@DiscordBot.profile.id}) | #{@@DiscordBot.servers.size} servers"
      #   @@DiscordBot.send_message(SiteSetting.discord_bot_admin_channel_id, "The Discourse admin bot has started his shift!")
      # end

      @@SlackBot
    end

    def self.discord_bot
      @@SlackBot
    end

    def self.run_bot
      bot = self.init

      # unless bot.nil?
      #   ::SlackBot::DiscourseEventsHandlers.hook_events
      #   bot.include!(::SlackBot::DiscordEventsHandlers::TransmitAnnouncement)
      #   ::SlackBot::BotCommands.manage_discord_commands(bot)
      # end
    end
  end
end
