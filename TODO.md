# TODO

This page contains all the calls from the reddit api along with their
implementations in Redd. The API docs are located
[**here**](https://www.reddit.com/dev/api).

## Account

- **GET /api/v1/me**
  - **Implemented**: [Session#me](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Session#me-instance_method)
- **GET /api/v1/me/karma**
  - TODO: add implementation/documentation link
- **GET /api/v1/me/prefs**
  - TODO: add implementation/documentation link
- **PATCH /api/v1/me/prefs**
  - TODO: add implementation/documentation link
- **GET /api/v1/me/trophies**
  - TODO: add implementation/documentation link
- **GET /prefs/where**
  - TODO: add implementation/documentation link

## Captcha

- **GET /api/needs_captcha**
  - **Won't Implement**: Not necessary for OAuth2 clients

## Flair

- **POST [/r/subreddit]/api/clearflairtemplates**
  - TODO: add implementation/documentation link
- **POST [/r/subreddit]/api/deleteflair**
  - TODO: add implementation/documentation link
- **POST [/r/subreddit]/api/deleteflairtemplate**
  - TODO: add implementation/documentation link
- **POST [/r/subreddit]/api/flair**
  - TODO: add implementation/documentation link
- **POST [/r/subreddit]/api/flairconfig**
  - TODO: add implementation/documentation link
- **POST [/r/subreddit]/api/flaircsv**
  - TODO: add implementation/documentation link
- **GET [/r/subreddit]/api/flairlist**
  - TODO: add implementation/documentation link
- **POST [/r/subreddit]/api/flairselector**
  - TODO: add implementation/documentation link
- **POST [/r/subreddit]/api/flairtemplate**
  - TODO: add implementation/documentation link
- **GET [/r/subreddit]/api/link_flair**
  - TODO: add implementation/documentation link
- **POST [/r/subreddit]/api/selectflair**
  - TODO: add implementation/documentation link
- **POST [/r/subreddit]/api/setflairenabled**
  - TODO: add implementation/documentation link
- **GET [/r/subreddit]/api/user_flair**
  - TODO: add implementation/documentation link

## Reddit Gold

- **POST /api/v1/gold/gild/fullname**
  - TODO: add implementation/documentation link
- **POST /api/v1/gold/give/username**
  - TODO: add implementation/documentation link

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
  - **Won't Implement**: This is probably deprecated. See [#31](https://github.com/avinashbot/redd/issues/31).
- **POST /api/lock**
  - **Implemented**: [Redd::Models::Submission#lock](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Submission#lock-instance_method)
- **POST /api/marknsfw**
  - **Implemented**: [Redd::Models::Submission#mark_as_nsfw](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Submission#mark_as_nsfw-instance_method)
- **GET /api/morechildren**
  - TODO: add implementation/documentation link
- **POST /api/report**
  - TODO: add implementation/documentation link
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
  - TODO: add implementation/documentation link
- **POST /api/spoiler**
  - TODO: add implementation/documentation link
- **POST /api/store_visits**
  - TODO: add implementation/documentation link
- **POST /api/submit**
  - TODO: add implementation/documentation link
- **POST /api/unhide**
  - TODO: add implementation/documentation link
- **POST /api/unlock**
  - TODO: add implementation/documentation link
- **POST /api/unmarknsfw**
  - TODO: add implementation/documentation link
- **POST /api/unsave**
  - TODO: add implementation/documentation link
- **POST /api/unspoiler**
  - TODO: add implementation/documentation link
- **POST /api/vote**
  - TODO: add implementation/documentation link

## Listings

- **GET /api/trending_subreddits**
  - TODO: add implementation/documentation link
- **GET /by_id/names**
  - TODO: add implementation/documentation link
- **GET [/r/subreddit]/comments/article**
  - TODO: add implementation/documentation link
- **GET /duplicates/article**
  - TODO: add implementation/documentation link
- **GET [/r/subreddit]/hot**
  - TODO: add implementation/documentation link
- **GET [/r/subreddit]/new**
  - TODO: add implementation/documentation link
- **GET [/r/subreddit]/random**
  - TODO: add implementation/documentation link
- **GET [/r/subreddit]/rising**
  - TODO: add implementation/documentation link
- **GET [/r/subreddit]/sort**
  - TODO: add implementation/documentation link

## Live Threads

- **GET /api/live/by_id/names**
  - TODO: add implementation/documentation link
- **POST /api/live/create**
  - TODO: add implementation/documentation link
- **GET /api/live/happening_now**
  - TODO: add implementation/documentation link
- **POST /api/live/thread/accept_contributor_invite**
  - TODO: add implementation/documentation link
- **POST /api/live/thread/close_thread**
  - TODO: add implementation/documentation link
- **POST /api/live/thread/delete_update**
  - TODO: add implementation/documentation link
- **POST /api/live/thread/edit**
  - TODO: add implementation/documentation link
- **POST /api/live/thread/invite_contributor**
  - TODO: add implementation/documentation link
- **POST /api/live/thread/leave_contributor**
  - TODO: add implementation/documentation link
- **POST /api/live/thread/report**
  - TODO: add implementation/documentation link
- **POST /api/live/thread/rm_contributor**
  - TODO: add implementation/documentation link
- **POST /api/live/thread/rm_contributor_invite**
  - TODO: add implementation/documentation link
- **POST /api/live/thread/set_contributor_permissions**
  - TODO: add implementation/documentation link
- **POST /api/live/thread/strike_update**
  - TODO: add implementation/documentation link
- **POST /api/live/thread/update**
  - TODO: add implementation/documentation link
- **GET /live/thread**
  - TODO: add implementation/documentation link
- **GET /live/thread/about**
  - TODO: add implementation/documentation link
- **GET /live/thread/contributors**
  - TODO: add implementation/documentation link
- **GET /live/thread/discussions**
  - TODO: add implementation/documentation link

## Private Messages

- **POST /api/block**
  - **Implemented**: [Redd::Models::Inboxable#block](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Inboxable#block-instance_method)
- **POST /api/collapse_message**
  - TODO: add implementation/documentation link
- **POST /api/compose**
  - **Implemented**: [Redd::Models::Messageable#send_message](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Messageable#send_message-instance_method)
- **POST /api/del_msg**
  - **Implemented**: [Redd::Models::PrivateMessage#delete](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/PrivateMessage#delete-instance_method)
- **POST /api/read_all_messages**
  - **Implemented**: [Redd::Models::Session#read_all_messages](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Session#read_all_messages-instance_method)
- **POST /api/read_message**
  - **Implemented**: [Redd::Models::Inboxable#mark_as_read](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Inboxable#mark_as_read-instance_method)
- **POST /api/unblock_subreddit**
  - TODO: add implementation/documentation link
- **POST /api/uncollapse_message**
  - TODO: add implementation/documentation link
- **POST /api/unread_message**
  - **Implemented**: [Redd::Models::Inboxable#mark_as_unread](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Inboxable#mark_as_unread-instance_method)
- **GET /message/where**
  - **Implemented**: [Redd::Models::Session#my_messages](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Session#my_messages-instance_method)

## Miscellaneous

- **GET /api/v1/scopes**
  - TODO: add implementation/documentation link

## Moderation

- **GET [/r/subreddit]/about/log**
  - TODO: add implementation/documentation link
- **GET [/r/subreddit]/about/location**
  - TODO: add implementation/documentation link
- **POST [/r/subreddit]/api/accept_moderator_invite**
  - TODO: add implementation/documentation link
- **POST /api/approve**
  - TODO: add implementation/documentation link
- **POST /api/distinguish**
  - TODO: add implementation/documentation link
- **POST /api/ignore_reports**
  - TODO: add implementation/documentation link
- **POST /api/leavecontributor**
  - TODO: add implementation/documentation link
- **POST /api/leavemoderator**
  - TODO: add implementation/documentation link
- **POST /api/mute_message_author**
  - TODO: add implementation/documentation link
- **POST /api/remove**
  - TODO: add implementation/documentation link
- **POST /api/unignore_reports**
  - TODO: add implementation/documentation link
- **POST /api/unmute_message_author**
  - TODO: add implementation/documentation link
- **GET [/r/subreddit]/stylesheet**
  - TODO: add implementation/documentation link

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
