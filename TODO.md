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
  - TODO: add implementation/documentation link
- **GET /api/mod/conversations**
  - TODO: add implementation/documentation link
- **POST /api/mod/conversations**
  - TODO: add implementation/documentation link
- **GET /api/mod/conversations/:conversation_id**
  - TODO: add implementation/documentation link
- **POST /api/mod/conversations/:conversation_id**
  - TODO: add implementation/documentation link
- **POST /api/mod/conversations/:conversation_id/archive**
  - TODO: add implementation/documentation link
- **DELETE /api/mod/conversations/:conversation_id/highlight**
  - TODO: add implementation/documentation link
- **POST /api/mod/conversations/:conversation_id/highlight**
  - TODO: add implementation/documentation link
- **POST /api/mod/conversations/:conversation_id/mute**
  - TODO: add implementation/documentation link
- **POST /api/mod/conversations/:conversation_id/unarchive**
  - TODO: add implementation/documentation link
- **POST /api/mod/conversations/:conversation_id/unmute**
  - TODO: add implementation/documentation link
- **GET /api/mod/conversations/:conversation_id/user**
  - TODO: add implementation/documentation link
- **POST /api/mod/conversations/read**
  - TODO: add implementation/documentation link
- **GET /api/mod/conversations/subreddits**
  - TODO: add implementation/documentation link
- **POST /api/mod/conversations/unread**
  - TODO: add implementation/documentation link
- **GET /api/mod/conversations/unread/count**
  - TODO: add implementation/documentation link

## Multis

- **POST /api/multi/copy**
  - TODO: add implementation/documentation link
- **GET /api/multi/mine**
  - TODO: add implementation/documentation link
- **POST /api/multi/rename**
  - TODO: add implementation/documentation link
- **GET /api/multi/user/username**
  - TODO: add implementation/documentation link
- **DELETE /api/multi/multipath**
  - TODO: add implementation/documentation link
- **GET /api/multi/multipath**
  - TODO: add implementation/documentation link
- **POST /api/multi/multipath**
  - TODO: add implementation/documentation link
- **PUT /api/multi/multipath**
  - TODO: add implementation/documentation link
- **GET /api/multi/multipath/description**
  - TODO: add implementation/documentation link
- **PUT /api/multi/multipath/description**
  - TODO: add implementation/documentation link
- **DELETE /api/multi/multipath/r/srname**
  - TODO: add implementation/documentation link
- **GET /api/multi/multipath/r/srname**
  - TODO: add implementation/documentation link
- **PUT /api/multi/multipath/r/srname**
  - TODO: add implementation/documentation link

## Search

- **GET [/r/subreddit]/search**
  - TODO: add implementation/documentation link

## Subreddits

- **GET [/r/subreddit]/about/where**
  - TODO: add implementation/documentation link
- **POST [/r/subreddit]/api/delete_sr_banner**
  - TODO: add implementation/documentation link
- **POST [/r/subreddit]/api/delete_sr_header**
  - TODO: add implementation/documentation link
- **POST [/r/subreddit]/api/delete_sr_icon**
  - TODO: add implementation/documentation link
- **POST [/r/subreddit]/api/delete_sr_img**
  - TODO: add implementation/documentation link
- **GET /api/recommend/sr/srnames**
  - TODO: add implementation/documentation link
- **POST /api/search_reddit_names**
  - TODO: add implementation/documentation link
- **POST /api/search_subreddits**
  - TODO: add implementation/documentation link
- **POST /api/site_admin**
  - TODO: add implementation/documentation link
- **GET [/r/subreddit]/api/submit_text**
  - TODO: add implementation/documentation link
- **GET /api/subreddit_autocomplete**
  - TODO: add implementation/documentation link
- **POST [/r/subreddit]/api/subreddit_stylesheet**
  - TODO: add implementation/documentation link
- **GET /api/subreddits_by_topic**
  - TODO: add implementation/documentation link
- **POST /api/subscribe**
  - TODO: add implementation/documentation link
- **POST [/r/subreddit]/api/upload_sr_img**
  - TODO: add implementation/documentation link
- **GET /r/subreddit/about**
  - TODO: add implementation/documentation link
- **GET /r/subreddit/about/edit**
  - TODO: add implementation/documentation link
- **GET /r/subreddit/about/rules**
  - TODO: add implementation/documentation link
- **GET /r/subreddit/about/traffic**
  - TODO: add implementation/documentation link
- **GET [/r/subreddit]/sidebar**
  - TODO: add implementation/documentation link
- **GET [/r/subreddit]/sticky**
  - TODO: add implementation/documentation link
- **GET /subreddits/mine/where**
  - TODO: add implementation/documentation link
- **GET /subreddits/search**
  - TODO: add implementation/documentation link
- **GET /subreddits/where**
  - TODO: add implementation/documentation link
- **GET /users/where**
  - TODO: add implementation/documentation link

## Users

- **POST /api/block_user**
  - TODO: add implementation/documentation link
- **POST [/r/subreddit]/api/friend**
  - TODO: add implementation/documentation link
- **POST /api/report_user**
  - TODO: add implementation/documentation link
- **POST [/r/subreddit]/api/setpermissions**
  - TODO: add implementation/documentation link
- **POST [/r/subreddit]/api/unfriend**
  - TODO: add implementation/documentation link
- **GET /api/user_data_by_account_ids**
  - TODO: add implementation/documentation link
- **GET /api/username_available**
  - TODO: add implementation/documentation link
- **DELETE /api/v1/me/friends/username**
  - TODO: add implementation/documentation link
- **GET /api/v1/me/friends/username**
  - TODO: add implementation/documentation link
- **PUT /api/v1/me/friends/username**
  - TODO: add implementation/documentation link
- **GET /api/v1/user/username/trophies**
  - TODO: add implementation/documentation link
- **GET /user/username/about**
  - TODO: add implementation/documentation link
- **GET /user/username/where**
  - TODO: add implementation/documentation link

## Wiki

- **POST [/r/subreddit]/api/wiki/alloweditor/act**
  - TODO: add implementation/documentation link
- **POST [/r/subreddit]/api/wiki/edit**
  - TODO: add implementation/documentation link
- **POST [/r/subreddit]/api/wiki/hide**
  - TODO: add implementation/documentation link
- **POST [/r/subreddit]/api/wiki/revert**
  - TODO: add implementation/documentation link
- **GET [/r/subreddit]/wiki/discussions/page**
  - TODO: add implementation/documentation link
- **GET [/r/subreddit]/wiki/pages**
  - TODO: add implementation/documentation link
- **GET [/r/subreddit]/wiki/revisions**
  - TODO: add implementation/documentation link
- **GET [/r/subreddit]/wiki/revisions/page**
  - TODO: add implementation/documentation link
- **GET [/r/subreddit]/wiki/settings/page**
  - TODO: add implementation/documentation link
- **POST [/r/subreddit]/wiki/settings/page**
  - TODO: add implementation/documentation link
- **GET [/r/subreddit]/wiki/page**
  - TODO: add implementation/documentation link
