# TODO

This page contains all the calls from the reddit api along with their
implementations in Redd. The API docs are located
[**here**](https://www.reddit.com/dev/api).

## Account

- **GET /api/v1/me**
  - **Implemented**: [Redd::Models::Session#me](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Session#me-instance_method)
- **GET /api/v1/me/karma**
  - **Implemented**: [Redd::Models::Session#karma_breakdown](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Session#karma_breakdown-instance_method)
- **GET /api/v1/me/prefs**
  - **Implemented**: [Redd::Models::Session#my_preferences](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Session#my_preferences-instance_method)
- **PATCH /api/v1/me/prefs**
  - **Implemented**: [Redd::Models::Session#edit_preferences](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Session#edit_preferences-instance_method)
- **GET /api/v1/me/trophies**
  - **Not Implemented**
- **GET /prefs/where**
  - **Partially Implemented**: [Redd::Models::Session](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Session) (for friends, blocked, and trusted)

## Captcha

- **GET /api/needs_captcha**
  - **Won't Implement**: Not necessary for OAuth2 clients

## Flair

- **POST [/r/subreddit]/api/clearflairtemplates**
  - **Not Implemented**
- **POST [/r/subreddit]/api/deleteflair**
  - **Implemented**: [Redd::Models::Subreddit#delete_flair](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Subreddit#delete_flair-instance_method)
- **POST [/r/subreddit]/api/deleteflairtemplate**
  - **Not Implemented**
- **POST [/r/subreddit]/api/flair**
  - **Implemented**: [Redd::Models::Subreddit#set_flair](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Subreddit#set_flair-instance_method)
- **POST [/r/subreddit]/api/flairconfig**
  - **Not Implemented**
- **POST [/r/subreddit]/api/flaircsv**
  - **Not Implemented**
- **GET [/r/subreddit]/api/flairlist**
  - **Implemented**: [Redd::Models::Subreddit#flair_listing](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Subreddit#flair_listing-instance_method)
- **POST [/r/subreddit]/api/flairselector**
  - **Not Implemented**
- **POST [/r/subreddit]/api/flairtemplate**
  - **Not Implemented**
- **GET [/r/subreddit]/api/link_flair**
  - **Not Implemented**
- **POST [/r/subreddit]/api/selectflair**
  - **Implemented**: [Redd::Models::Subreddit#set_flair_template](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Subreddit#set_flair_template-instance_method)
- **POST [/r/subreddit]/api/setflairenabled**
  - **Not Implemented**
- **GET [/r/subreddit]/api/user_flair**
  - **Not Implemented**

## Reddit Gold

- **POST /api/v1/gold/gild/fullname**
  - **Implemented**: [Redd::Models::Gildable#gild](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Gildable#gild-instance_method)
- **POST /api/v1/gold/give/username**
  - **Implemented**: [Redd::Models::User#gift_gold](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/User#gift_gold-instance_method)

## Links & Comments

- **POST /api/comment**
  - **Implemented**: [Redd::Models::Replyable#reply](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Replyable#reply-instance_method)
- **POST /api/del**
  - **Implemented**: [Redd::Models::Postable#delete](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Postable#delete-instance_method)
- **POST /api/editusertext**
  - **Implemented**: [Redd::Models::Postable#edit](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Postable#edit-instance_method)
- **POST /api/hide**
  - **Implemented**: [Redd::Models::Postable#hide](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Postable#hide-instance_method)
- **GET [/r/subreddit]/api/info**
  - **Implemented**
    - [Redd::Models::Session#from_fullnames](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Session#from_fullnames-instance_method)
    - Also implemented as part of lazy loaders.
- **POST /api/lock**
  - **Implemented**: [Redd::Models::Submission#lock](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Submission#lock-instance_method)
- **POST /api/marknsfw**
  - **Implemented**: [Redd::Models::Submission#mark_as_nsfw](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Submission#mark_as_nsfw-instance_method)
- **GET /api/morechildren**
  - TODO: add implementation/documentation link
- **POST /api/report**
  - **Not Implemented**
- **POST /api/save**
  - **Implemented**: [Redd::Models::Postable#save](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Postable#save-instance_method)
- **GET /api/saved_categories**
  - **Implemented**: [Redd::Models::Session#saved_categories](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Session#saved_categories-instance_method)
- **POST /api/sendreplies**
  - **Implemented**: [Redd::Models::Postable#enable_inbox_replies](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Postable#enable_inbox_replies-instance_method)
- **POST /api/set_contest_mode**
  - **Implemented**: [Redd::Models::Submission#enable_contest_mode](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Submission#enable_contest_mode-instance_method)
- **POST /api/set_subreddit_sticky**
  - **Implemented**: [Redd::Models::Submission#make_sticky](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Submission#make_sticky-instance_method)
- **POST /api/set_suggested_sort**
  - **Implemented**: [Redd::Models::Submission#set_suggested_sort](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Submission#set_suggested_sort-instance_method)
- **POST /api/spoiler**
  - **Implemented**: [Redd::Models::Submission#mark_as_spoiler](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Submission#mark_as_spoiler-instance_method)
- **POST /api/store_visits**
  - **Not Implemented**
- **POST /api/submit**
  - **Implemented**: [Redd::Models::Subreddit#submit](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Subreddit#submit-instance_method)
- **POST /api/unhide**
  - **Implemented**: [Redd::Models::Postable#unhide](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Postable#unhide-instance_method)
- **POST /api/unlock**
  - **Implemented**: [Redd::Models::Submission#unlock](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Submission#unlock-instance_method)
- **POST /api/unmarknsfw**
  - **Implemented**: [Redd::Models::Submission#unmark_as_nsfw](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Submission#unmark_as_nsfw-instance_method)
- **POST /api/unsave**
  - **Implemented**: [Redd::Models::Postable#unsave](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Postable#unsave-instance_method)
- **POST /api/unspoiler**
  - **Implemented**: [Redd::Models::Submission#unmark_as_spoiler](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Submission#unmark_as_spoiler-instance_method)
- **POST /api/vote**
  - **Implemented**:
    - [Redd::Models::Postable#upvote](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Postable#upvote-instance_method)
    - [Redd::Models::Postable#downvote](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Postable#downvote-instance_method)
    - [Redd::Models::Postable#undo_vote](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Postable#undo_vote-instance_method)

## Listings

- **GET /api/trending_subreddits**
  - **Not Implemented**
- **GET /by_id/names**
  - **Not Implemented**: See `/api/info`.
- **GET [/r/subreddit]/comments/article**
  - **Implemented**: Part of lazy-loading in Submission and Comment.
- **GET /duplicates/article**
  - **Implemented**: [Redd::Models::Submission#duplicates](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Submission#duplicates-instance_method)
- **GET [/r/subreddit]/hot**
  - **Implemented**: [Redd::Models::FrontPage#hot](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/FrontPage#hot-instance_method)
  - **Implemented**: [Redd::Models::Submission#hot](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Submission#hot-instance_method)
- **GET [/r/subreddit]/new**
  - **Implemented**: [Redd::Models::FrontPage#new](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/FrontPage#new-instance_method)
  - **Implemented**: [Redd::Models::Submission#new](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Submission#new-instance_method)
- **GET [/r/subreddit]/random**
  - **Implemented**: [Redd::Models::FrontPage#random](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/FrontPage#random-instance_method)
  - **Implemented**: [Redd::Models::Submission#random](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Submission#random-instance_method)
- **GET [/r/subreddit]/rising**
  - **Implemented**: [Redd::Models::FrontPage#rising](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/FrontPage#rising-instance_method)
  - **Implemented**: [Redd::Models::Submission#rising](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Submission#rising-instance_method)
- **GET [/r/subreddit]/sort**
  - **Implemented**: [Redd::Models::FrontPage#listing](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/FrontPage#listing-instance_method)
  - **Implemented**: [Redd::Models::Submission#listing](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Submission#listing-instance_method)

## Live Threads

- **GET /api/live/by_id/names**
  - **Not Implemented**
- **POST /api/live/create**
  - **Not Implemented**
- **GET /api/live/happening_now**
  - **Not Implemented**
- **POST /api/live/thread/accept_contributor_invite**
  - **Not Implemented**
- **POST /api/live/thread/close_thread**
  - **Not Implemented**
- **POST /api/live/thread/delete_update**
  - **Implemented**: [Redd::Models::LiveThread#delete_update](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/LiveThread#delete_update-instance_method)
- **POST /api/live/thread/edit**
  - **Implemented**: [Redd::Models::LiveThread#configure](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/LiveThread#configure-instance_method)
- **POST /api/live/thread/invite_contributor**
  - **Not Implemented**
- **POST /api/live/thread/leave_contributor**
  - **Not Implemented**
- **POST /api/live/thread/report**
  - **Not Implemented**
- **POST /api/live/thread/rm_contributor**
  - **Not Implemented**
- **POST /api/live/thread/rm_contributor_invite**
  - **Not Implemented**
- **POST /api/live/thread/set_contributor_permissions**
  - **Not Implemented**
- **POST /api/live/thread/strike_update**
  - **Implemented**: [Redd::Models::LiveThread#strike_update](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/LiveThread#strike_update-instance_method)
- **POST /api/live/thread/update**
  - **Implemented**: [Redd::Models::LiveThread#update](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/LiveThread#update-instance_method)
- **GET /live/thread**
  - **Implemented**: [Redd::Models::LiveThread#updates](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/LiveThread#updates-instance_method)
- **GET /live/thread/about**
  - **Implemented**: [Redd::Models::Session#live_thread](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Session#live_thread-instance_method)
- **GET /live/thread/contributors**
  - **Implemented**: [Redd::Models::LiveThread#contributors](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/LiveThread#contributors-instance_method)
- **GET /live/thread/discussions**
  - **Implemented**: [Redd::Models::LiveThread#discussions](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/LiveThread#discussions-instance_method)

## Private Messages

- **POST /api/block**
  - **Implemented**: [Redd::Models::Inboxable#block](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Inboxable#block-instance_method)
- **POST /api/collapse_message**
  - **Not Implemented**
- **POST /api/compose**
  - **Implemented**: [Redd::Models::Messageable#send_message](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Messageable#send_message-instance_method)
- **POST /api/del_msg**
  - **Implemented**: [Redd::Models::PrivateMessage#delete](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/PrivateMessage#delete-instance_method)
- **POST /api/read_all_messages**
  - **Implemented**: [Redd::Models::Session#read_all_messages](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Session#read_all_messages-instance_method)
- **POST /api/read_message**
  - **Implemented**: [Redd::Models::Inboxable#mark_as_read](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Inboxable#mark_as_read-instance_method)
- **POST /api/unblock_subreddit**
  - **Not Implemented**
- **POST /api/uncollapse_message**
  - **Not Implemented**
- **POST /api/unread_message**
  - **Implemented**: [Redd::Models::Inboxable#mark_as_unread](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Inboxable#mark_as_unread-instance_method)
- **GET /message/where**
  - **Implemented**: [Redd::Models::Session#my_messages](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Session#my_messages-instance_method)

## Miscellaneous

- **GET /api/v1/scopes**
  - **Not Implemented**

## Moderation

- **GET [/r/subreddit]/about/log**
  - **Implemented**: [Redd::Models::Subreddit#mod_log](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Subreddit#mod_log-instance_method)
- **GET [/r/subreddit]/about/location**
  - **Implemented**: [Redd::Models::Subreddit#moderator_listing](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Subreddit#moderator_listing-instance_method)
- **POST [/r/subreddit]/api/accept_moderator_invite**
  - **Implemented**: [Redd::Models::Subreddit#accept_moderator_invite](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Subreddit#accept_moderator_invite-instance_method)
- **POST /api/approve**
  - **Implemented**: [Redd::Models::Moderatable#approve](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Moderatable#approve-instance_method)
- **POST /api/distinguish**
  - **Implemented**: [Redd::Models::Moderatable#distinguish](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Moderatable#distinguish-instance_method)
- **POST /api/ignore_reports**
  - **Implemented**: [Redd::Models::Moderatable#ignore_reports](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Moderatable#ignore_reports-instance_method)
- **POST /api/leavecontributor**
  - **Implemented**: [Redd::Models::Subreddit#leave_contributor](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Subreddit#leave_contributor-instance_method)
- **POST /api/leavemoderator**
  - **Implemented**: [Redd::Models::Subreddit#leave_moderator](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Subreddit#leave_moderator-instance_method)
- **POST /api/mute_message_author**
  - **Implemented**: [Redd::Models::PrivateMessage#mute_author](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/PrivateMessage#mute_author-instance_method)
- **POST /api/remove**
  - **Implemented**: [Redd::Models::Moderatable#remove](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Moderatable#remove-instance_method)
- **POST /api/unignore_reports**
  - **Implemented**: [Redd::Models::Moderatable#unignore_reports](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Moderatable#unignore_reports-instance_method)
- **POST /api/unmute_message_author**
  - **Implemented**: [Redd::Models::PrivateMessage#unmute_author](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/PrivateMessage#unmute_author-instance_method)
- **GET [/r/subreddit]/stylesheet**
  - **Implemented**: [Redd::Models::Subreddit#stylesheet](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Subreddit#stylesheet-instance_method)

## New Modmail

- **POST /api/mod/bulk_read**
  - **Not Implemented**
- **GET /api/mod/conversations**
  - **Implemented**: [Redd::Models::Modmail#conversations](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Modmail#conversations-instance_method)
- **POST /api/mod/conversations**
  - **Implemented**: [Redd::Models::Modmail#create](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Modmail#create-instance_method)
- **GET /api/mod/conversations/:conversation_id**
  - **Implemented**: [Redd::Models::Modmail#get](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Modmail#get-instance_method)
- **POST /api/mod/conversations/:conversation_id**
  - **Implemented**: [Redd::Models::ModmailConversation#reply](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/ModmailConversation#reply-instance_method)
- **POST /api/mod/conversations/:conversation_id/archive**
  - **Implemented**: [Redd::Models::ModmailConversation#archive](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/ModmailConversation#archive-instance_method)
- **DELETE /api/mod/conversations/:conversation_id/highlight**
  - **Implemented**: [Redd::Models::ModmailConversation#unhighlight](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/ModmailConversation#unhighlight-instance_method)
- **POST /api/mod/conversations/:conversation_id/highlight**
  - **Implemented**: [Redd::Models::ModmailConversation#highlight](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/ModmailConversation#highlight-instance_method)
- **POST /api/mod/conversations/:conversation_id/mute**
  - **Implemented**: [Redd::Models::ModmailConversation#mute](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/ModmailConversation#mute-instance_method)
- **POST /api/mod/conversations/:conversation_id/unarchive**
  - **Implemented**: [Redd::Models::ModmailConversation#unarchive](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/ModmailConversation#unarchive-instance_method)
- **POST /api/mod/conversations/:conversation_id/unmute**
  - **Implemented**: [Redd::Models::ModmailConversation#unmute](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/ModmailConversation#unmute-instance_method)
- **GET /api/mod/conversations/:conversation_id/user**
  - **Not Implemented**
- **POST /api/mod/conversations/read**
  - **Not Implemented**
- **GET /api/mod/conversations/subreddits**
  - **Implemented**: [Redd::Models::Modmail#enrolled](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Modmail#enrolled-instance_method)
- **POST /api/mod/conversations/unread**
  - **Not Implemented**
- **GET /api/mod/conversations/unread/count**
  - **Implemented**: [Redd::Models::Modmail#unread_count](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Modmail#unread_count-instance_method)

## Multis

- **POST /api/multi/copy**
  - **Not Implemented**
- **GET /api/multi/mine**
  - **Not Implemented**
- **POST /api/multi/rename**
  - **Not Implemented**
- **GET /api/multi/user/username**
  - **Not Implemented**
- **DELETE /api/multi/multipath**
  - **Not Implemented**
- **GET /api/multi/multipath**
  - **Implemented**: [Redd::Models::Session#multi](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Session#multi-instance_method)
- **POST /api/multi/multipath**
  - **Not Implemented**
- **PUT /api/multi/multipath**
  - **Not Implemented**
- **GET /api/multi/multipath/description**
  - **Not Implemented**
- **PUT /api/multi/multipath/description**
  - **Not Implemented**
- **DELETE /api/multi/multipath/r/srname**
  - **Not Implemented**
- **GET /api/multi/multipath/r/srname**
  - **Not Implemented**
- **PUT /api/multi/multipath/r/srname**
  - **Not Implemented**

## Search

- **GET [/r/subreddit]/search**
  - **Implemented**: [Redd::Models::Searchable#search](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Searchable#search-instance_method)

## Subreddits

- **GET [/r/subreddit]/about/where**
  - **Implemented**: [Redd::Models::Subreddit#relationship_listing](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Subreddit#relationship_listing-instance_method)
- **POST [/r/subreddit]/api/delete_sr_banner**
  - **Not Implemented**
- **POST [/r/subreddit]/api/delete_sr_header**
  - **Not Implemented**
- **POST [/r/subreddit]/api/delete_sr_icon**
  - **Not Implemented**
- **POST [/r/subreddit]/api/delete_sr_img**
  - **Not Implemented**
- **GET /api/recommend/sr/srnames**
  - **Not Implemented**
- **POST /api/search_reddit_names**
  - **Not Implemented**
- **POST /api/search_subreddits**
  - **Not Implemented**
- **POST /api/site_admin**
  - **Implemented**: [Redd::Models::Subreddit#modify_settings](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Subreddit#modify_settings-instance_method)
- **GET [/r/subreddit]/api/submit_text**
  - **Won't Implement**: Already covered by the Subreddit model.
- **GET /api/subreddit_autocomplete**
  - **Not Implemented**
- **POST [/r/subreddit]/api/subreddit_stylesheet**
  - **Implemented**: [Redd::Models::Subreddit#update_stylesheet](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Subreddit#update_stylesheet-instance_method)
- **GET /api/subreddits_by_topic**
  - **Not Implemented**
- **POST /api/subscribe**
  - **Implemented**: [Redd::Models::Subreddit#subscribe](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Subreddit#subscribe-instance_method)
- **POST [/r/subreddit]/api/upload_sr_img**
  - **Implemented**: [Redd::Models::Subreddit#upload_image](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Subreddit#upload_image-instance_method)
- **GET /r/subreddit/about**
  - **Implemented**: [Redd::Models::Session#subreddit](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Session#subreddit-instance_method)
- **GET /r/subreddit/about/edit**
  - **Implemented**: [Redd::Models::Subreddit#settings](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Subreddit#settings-instance_method)
- **GET /r/subreddit/about/rules**
  - **Not Implemented**
- **GET /r/subreddit/about/traffic**
  - **Not Implemented**
- **GET [/r/subreddit]/sidebar**
  - **Won't Implement**: Already covered by Subreddit's "description" property.
- **GET [/r/subreddit]/sticky**
  - **Not Implemented**
- **GET /subreddits/mine/where**
  - **Implemented**: [Redd::Models::Session#my_subreddits](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Session#my_subreddits-instance_method)
- **GET /subreddits/search**
  - **Not Implemented**
- **GET /subreddits/where**
  - **Not Implemented**
- **GET /users/where**
  - **Not Implemented**

## Users

- **POST /api/block_user**
  - **Implemented**: [Redd::Models::User#block](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/User#block-instance_method)
- **POST [/r/subreddit]/api/friend**
  - TODO: add implementation/documentation link
- **POST /api/report_user**
  - **Not Implemented**
- **POST [/r/subreddit]/api/setpermissions**
  - **Not Implemented**
- **POST [/r/subreddit]/api/unfriend**
  - TODO: add implementation/documentation link
- **GET /api/user_data_by_account_ids**
  - **Not Implemented**
- **GET /api/username_available**
  - **Not Implemented**
- **DELETE /api/v1/me/friends/username**
  - **Implemented**: [Redd::Models::User#unfriend](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/User#unfriend-instance_method)
- **GET /api/v1/me/friends/username**
  - TODO: add implementation/documentation link
- **PUT /api/v1/me/friends/username**
  - **Implemented**: [Redd::Models::User#friend](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/User#friend-instance_method)
- **GET /api/v1/user/username/trophies**
  - TODO: add implementation/documentation link
- **GET /user/username/about**
  - **Implemented**: [Redd::Models::Session#user](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Session#user-instance_method)
- **GET /user/username/where**
  - **Implemented**: [Redd::Models::User#listing](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/User#listing-instance_method)

## Wiki

- **POST [/r/subreddit]/api/wiki/alloweditor/act**
  - **Not Implemented**
- **POST [/r/subreddit]/api/wiki/edit**
  - **Implemented**: [Redd::Models::WikiPage#edit](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/WikiPage#edit-instance_method)
- **POST [/r/subreddit]/api/wiki/hide**
  - **Not Implemented**
- **POST [/r/subreddit]/api/wiki/revert**
  - **Not Implemented**
- **GET [/r/subreddit]/wiki/discussions/page**
  - **Not Implemented**
- **GET [/r/subreddit]/wiki/pages**
  - **Implemented**: [Redd::Models::FrontPage#wiki_pages](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/FrontPage#wiki_pages-instance_method)
  - **Implemented**: [Redd::Models::Subreddit#wiki_pages](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Subreddit#wiki_pages-instance_method)
- **GET [/r/subreddit]/wiki/revisions**
  - **Not Implemented**
- **GET [/r/subreddit]/wiki/revisions/page**
  - **Not Implemented**
- **GET [/r/subreddit]/wiki/settings/page**
  - **Not Implemented**
- **POST [/r/subreddit]/wiki/settings/page**
  - **Not Implemented**
- **GET [/r/subreddit]/wiki/page**
  - **Implemented**: [Redd::Models::FrontPage#wiki_page](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/FrontPage#wiki_page-instance_method)
  - **Implemented**: [Redd::Models::Subreddit#wiki_page](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Subreddit#wiki_page-instance_method)
