require 'slack-ruby-bot'

module SlackBot
  module Commands
    class Pong < SlackRubyBot::Commands::Base
      command 'ping' do |client, data, match|
        client.say(text: 'pong', channel: data.channel)
      end
    end
  end
end
