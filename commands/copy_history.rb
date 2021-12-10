module SlackBot
  module Commands
    class CopyHistory < SlackRubyBot::Commands::Base
      command 'copyhist' do |client, data, match|

      pp "------------------------"
      pp data
      pp "------------------------"

# bot.command(:disccopy, min_args: 1, max_args: 3, bucket: :admin_tasks, rate_limit_message: I18n.t("discord_bot.commands.rate_limit_breached"), required_roles: [SiteSetting.discord_bot_admin_role_id], description: I18n.t("disccopy.description")) do |event, number_of_past_messages, target_category, target_topic|
#   past_messages = event.channel.history(number_of_past_messages, event.message.id)
#   destination_topic = nil
#   if target_category.nil?
#     destination_category = Category.find_by(name: event.message.channel.name)
#     event.respond I18n.t("discord_bot.commands.disccopy.no_category_specified")
#   else
#     destination_category = Category.find_by(name: target_category)
#   end
#   if destination_category
#     event.respond I18n.t("discord_bot.commands.disccopy.success.found_matching_discourse_category")
#   else
#     event.respond I18n.t("discord_bot.commands.disccopy.error.unable_to_find_discourse_category")
#     break
#   end
#   unless target_topic.nil?
#     destination_topic = Topic.find_by(title: target_topic, category_id: destination_category.id)
#     if destination_topic
#       event.respond I18n.t("discord_bot.commands.disccopy.success.found_matching_discourse_topic")
#     else
#       event.respond I18n.t("discord_bot.commands.disccopy.error.unable_to_find_discourse_topic")
#     end
#   end
#   system_user = User.find_by(id: -1)

#   total_copied_messages = 0

#   past_messages.reverse.in_groups_of(SiteSetting.discord_bot_message_copy_topic_size_limit.to_i).each_with_index do |message_batch, index|
#     current_topic_id = nil
#     message_batch.each_with_index do |pm, topic_index|
#       next if pm.nil?
#       raw = pm.to_s

#       associated_user = UserAssociatedAccount.find_by(provider_uid: pm.author.id)
#       unless associated_user.nil?
#         posting_user = User.find_by(id: associated_user.user_id)
#       else
#         posting_user = system_user
#       end

#       if topic_index == 0 && destination_topic.nil?
#         new_post = PostCreator.create!(posting_user, title: I18n.t("discord_bot.commands.disccopy.discourse_topic_title", channel: event.channel.name) + (past_messages.count <= SiteSetting.discord_bot_message_copy_topic_size_limit ? "" : " #{index + 1}") , raw: raw, category: destination_category.id, skip_validations: true)
#         total_copied_messages += 1
#         current_topic_id = new_post.topic.id
#       elsif !destination_topic.nil? || !current_topic_id.nil?
#         if current_topic_id.nil?
#           current_topic_id = destination_topic.id
#         end
#         new_post = PostCreator.create!(posting_user, raw: raw, topic_id: current_topic_id, skip_validations: true)
#         total_copied_messages += 1
#       else 
#         event.respond I18n.t("discord_bot.commands.disccopy.error.unable_to_determine_topic_id")
#       end
#     end
#   end
#   event.respond I18n.t("discord_bot.commands.disccopy.success.final_outcome", count: total_copied_messages) 
# end
      end
    end
  end
end
