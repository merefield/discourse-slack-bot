# frozen_string_literal: true
# Slack bot class
class SlackBot < SlackRubyBot::Bot

  @@SlackBot = nil

  def self.init
    @@SlackBot = SlackRubyBot::Server.new(token: SiteSetting.slack_bot_token, aliases: ['slackbot'])
    @@SlackBot.start_async
    
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

    unless bot.nil?
      ::SlackBot::DiscourseEventsHandlers.hook_events
      bot.include!(::SlackBot::DiscordEventsHandlers::TransmitAnnouncement)
      ::SlackBot::BotCommands.manage_discord_commands(bot)
    end
  end
end
