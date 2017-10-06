---
title: Creating Bots with Redd
path: /tutorials/creating-bots-with-redd
---

## Step 1: Creating an Application

Every bot needs to be registered on reddit. Some API wrappers let you skip this, but chances are, you will be heavily rate limited. Start by visiting your [**applications**](https://www.reddit.com/prefs/apps#developed-apps) and skipping to the "**developed apps**" section and clicking the button to create an app. Give it a name and a description and select the **script** app type. If you want to create a web application, [**follow this guide**](/tutorials/creating-webapps-with-redd). The text input labeled "redirect uri" is mandatory but you can just put any url in there because it doesn't really matter.

## Step 2: Creating a Bot Account (optional)

If you want your bot to interact with other users on the site (like submitting posts or replying to comments), you'll need to create a bot account. Log out and click the "Log in or sign up" link at the top right. Pick a nice bot name and a secure password (a valid email is encouraged in case you forget the password).

**This step is important!** Go to the application [you just created](https://www.reddit.com/prefs/apps#developed-apps) and add the bot's username as a developer for the app.

## Step 3: Installing Redd

Go ahead and [install Ruby](https://www.ruby-lang.org/en/downloads/) if you haven't already. Most package managers have a pretty recent version of Ruby up. The latest version at the time of writing is `2.4.1`. Redd supports Ruby versions `2.1.0` and up, but it's recommended to get the latest version, since I'll probably stop supporting older versions as time passes.

While you can just run `gem install redd` and call it a day, we're going to use [Bundler](https://bundler.io) like the responsible Rubyist we are.

1. Let's make sure bundler is installed:

        $ gem install bundler

2. Then, create a folder for your bot's code to live in:

        $ mkdir myfancybot
        $ cd myfancybot

3. Create a `Gemfile`listing all the gems our bot is going to use. It should look something like this:

    ```ruby
    source 'https://rubygems.org'
    gem 'redd', '~> 0.8'
    ```

4. Okay, now we just need to download all the gems and then we're ready to get coding!

        $ bundle install

## Step 4: Test Drive

Let's create the file our bot is going to run from. I'm going to call it `app.rb`, but feel free to use your imagination. Let's put the following in it to start off:

```ruby
require 'bundler/setup'
require 'redd'
```
Redd has a pretty convenient method to get us up and running with the API as quickly as possible called [`Redd.it`](http://www.rubydoc.info/github/avinashbot/redd/master/Redd#it-class_method). I'm going to use that to plug in all my application details. Add the following to your bot's file, replacing the text in angled brackets with your app's details. If you don't need an account for your bot, just skip the `username` and `password` fields.

```ruby
reddit = Redd.it(
  user_agent: 'Redd:MyFancyBot:v1.2.3',
  client_id:  '[the code under the title of your app]',
  secret:     '[the apps secret]',
  username:   '[your bot account username]',
  password:   '[your bot account password]'
)
```

For more info on the user_agent, take a look at reddit's [API rules](https://github.com/reddit/reddit/wiki/API).

Now if everything went as planned, `reddit` should be a valid reddit session. The [**Session documentation**](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Session) lists all the things you can do from here. But for now, let's just print out the title of the post on top of /r/all right now by adding the following to your code:

```ruby
r_all = reddit.subreddit('all')
post = r_all.hot.first
puts post.title
```

**We're all done!** Let's run this baby!

    $ ruby app.rb

## Step 6: Making your Dream Bot

The [**documentation**](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Session) is a great starting point for things you can do with Redd. If you need help with Ruby, /r/learnruby is a great place to visit. If you need help with the Reddit API, /r/redditdev is also very helpful, along with [reddit's API documentation](https://reddit.com/dev/api).

**Remember to respect the the [bottiquette](https://www.reddit.com/wiki/bottiquette)!** P.S. /r/Bottiquette keeps a [list of subreddits where bots aren't allowed](https://www.reddit.com/r/Bottiquette/wiki/robots_txt), while [/r/botsrights does the opposite](https://www.reddit.com/r/botsrights/wiki/listofbotfriendlysubs).

## Step 7: Making it Legendary

While it convenient that you can run the bot straight from your home, running a bot 24/7 from your overheating laptop isn't exactly the best long term solution, ya dig? There are three solutions to this dilemma:

1. Abuse free pricing tiers:
    - [**Heroku**](https://www.heroku.com/free) offers up to 1000 dyno hours per account per month.
    - [**AWS**](https://aws.amazon.com/free/) has a free tier, offering 750 hours a month for a year.
    - [**Google Cloud Platform**](https://cloud.google.com/free/docs/always-free-usage-limits) has an always free tier, offering 28 instance hours a day.

2. Five bucks a month:  
Both [DigitalOcean](https://www.digitalocean.com/pricing) and [Linode](https://www.linode.com/pricing) offer cloud computing for $5 a month.

3. One-time payment:  
Buy a [Raspberry Pi](https://www.raspberrypi.org/products/) or a [CHIP](https://getchip.com/) to run from your home.

---

I hope that got you started making your first reddit bot! If you need help, don't hesitate to [**submit a self post**](https://www.reddit.com/r/Redd/submit?selftext=true) or [**PM me**](https://www.reddit.com/message/compose/?to=Mustermind).

If you're uploading your Ruby bot to GitHub, post a link to the bot's code to the subreddit!
