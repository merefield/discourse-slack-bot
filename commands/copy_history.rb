module SlackBot
  module Commands
    class CopyHistory < SlackRubyBot::Commands::Base

      def self.channel_cache_key(channel)
        "slack_channel_#{channel}"
      end

      command 'copyhist' do |client, data, match|

        expression = match["expression"]

        if expression.split[0] == "help"
          client.say(channel: data.channel, text: I18n.t("slack_bot.slack_commands.copy_history.help"))
          break
        end

        if !/\A\d+\z/.match(expression.split[0])
          client.say(channel: data.channel, text: I18n.t("slack_bot.slack_commands.copy_history.error.didnt_supply_integer_argument"))
          break
        end

        number_of_messages = expression.split[0].to_i
        target_category = expression.split[1]
        target_topic = expression.split[2]

        destination_topic = nil

        connection_data = Discourse.cache.fetch(channel_cache_key(data.channel), expires_in: 1.hour) do
          web_client = Slack::Web::Client.new
          web_client.conversations_info(channel: "#{data.channel}")
        end

        slack_channel_name = connection_data["channel"]["name"]
        pp slack_channel_name

        if target_category.nil?
          destination_category = Category.find_by(name: slack_channel_name) || Category.find_by(name: slack_channel_name.capitalize)
          client.say(channel: data.channel, text: I18n.t("slack_bot.slack_commands.copy_history.no_category_specified"))
        else
          destination_category = Category.find_by(name: target_category)
        end
        if destination_category
          client.say(channel: data.channel, text: I18n.t("slack_bot.slack_commands.copy_history.success.found_matching_discourse_category"))
        else
          client.say(channel: data.channel, text: I18n.t("slack_bot.slack_commands.copy_history.error.unable_to_find_discourse_category"))
          break
        end
        unless target_topic.nil?
          destination_topic = Topic.find_by(title: target_topic, category_id: destination_category.id)
          if destination_topic
            client.say(channel: data.channel, text: I18n.t("slack_bot.slack_commands.copy_history.success.found_matching_discourse_topic"))
          else
            client.say(channel: data.channel, text: I18n.t("slack_bot.slack_commands.copy_history.error.unable_to_find_discourse_topic"))
          end
        end
        system_user = User.find_by(id: -1)

        total_copied_messages = 0

        past_messages.reverse.in_groups_of(SiteSetting.slack_bot_message_copy_topic_size_limit.to_i).each_with_index do |message_batch, index|
          current_topic_id = nil
          message_batch.each_with_index do |pm, topic_index|
            next if pm.nil?

            slack_user_id = pm["user"]
            slack_message_text = pm["text"]

            raw = slack_message_text

            associated_user = UserAssociatedAccount.find_by(provider_uid: slack_user_id)
            unless associated_user.nil?
              posting_user = User.find_by(id: associated_user.user_id)
            else
              posting_user = system_user
            end

            if topic_index == 0 && destination_topic.nil?
              new_post = PostCreator.create!(posting_user, title: I18n.t("slack_bot.slack_commands.copy_history.discourse_topic_title", channel: slack_channel_name) + (past_messages.count <= SiteSetting.slack_bot_message_copy_topic_size_limit ? "" : " #{index + 1}") , raw: raw, category: destination_category.id, skip_validations: true)
              total_copied_messages += 1
              current_topic_id = new_post.topic.id
            elsif !destination_topic.nil? || !current_topic_id.nil?
              if current_topic_id.nil?
                current_topic_id = destination_topic.id
              end
              new_post = PostCreator.create!(posting_user, raw: raw, topic_id: current_topic_id, skip_validations: true)
              total_copied_messages += 1
            else 
              client.say(channel: data.channel, text: I18n.t("slack_bot.slack_commands.copy_history.error.unable_to_determine_topic_id"))
            end
          end
        end
        client.say(channel: data.channel, text: I18n.t("slack_bot.slack_commands.copy_history.success.final_outcome", count: total_copied_messages))
      end
    end
  end
end
