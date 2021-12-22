
class CopyMessageFromSlack < SlackRubyBot::Bot

  def self.channel_cache_key(channel)
    "slack_channel_#{channel}"
  end

  match /.*/ do |client, data, match|

    connection_data = Discourse.cache.fetch(channel_cache_key(data.channel), expires_in: 1.hour) do
      web_client = Slack::Web::Client.new
      web_client.conversations_info(channel: "#{data.channel}")
    end

    slack_user_id = data["user"]
    slack_message_text = data["text"]
    slack_channel_name = connection_data["channel"]["name"]

    system_user = User.find_by(id: -1)

    associated_user = UserAssociatedAccount.find_by(provider_uid: slack_user_id)
    unless associated_user.nil?
      posting_user = User.find_by(id: associated_user.user_id)
    else
      posting_user = system_user
    end

    if SiteSetting.slack_bot_auto_channel_sync
      matching_category = Category.find_by(name: slack_channel_name) || Category.find_by(name: slack_channel_name.capitalize)
      raw = slack_message_text
      unless matching_category.nil?
        if !(target_topic = Topic.find_by(title: I18n.t("slack_bot.slack_events.auto_message_copy.default_topic_title", slack_channel_name: matching_category.name))).nil?
          new_post = PostCreator.create!(posting_user, raw: raw, topic_id: target_topic.id, skip_validations: true)
        else
          new_post = PostCreator.create!(posting_user, title: I18n.t("slack_bot.slack_events.auto_message_copy.default_topic_title", slack_channel_name: matching_category.name), raw: raw, category: matching_category.id, skip_validations: true)
        end
      else
        # Copy the message to the assigned Discourse announcement Topic if assigned in plugin settings
        discourse_announcement_topic = Topic.find_by(id: SiteSetting.slack_bot_discourse_announcement_topic_id)
        unless discourse_announcement_topic.nil?
          new_post = PostCreator.create!(posting_user, raw: raw, topic_id: discourse_announcement_topic.id)
        end
      end
    end
  end
end
