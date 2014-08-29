<p align="center">
  <img src="https://i.imgur.com/2JfE4M1.png" alt="redd"><br>
  <a href="http://badge.fury.io/rb/redd"><img src="https://badge.fury.io/rb/redd.svg" alt="Gem Version" height="18"></a>
  <a href="https://travis-ci.org/avidw/redd"><img src="https://travis-ci.org/avidw/redd.svg?branch=master" alt="Build Status"></a>
</p>

**redd** is an API wrapper for [reddit](http://reddit.com/dev/api) written in ruby that focuses on being *simple and extensible*.  

**Check out the latest documentation on [RubyDoc](http://rubydoc.info/github/avidw/redd/master/frames).**

---

<p align="center">
  <a href="#getting-started">Getting Started</a> |
  <a href="#oauth2">OAuth2</a> |
  <a href="#extending-redd">Extending Redd</a> |
  <a href="#supported-rubies">Supported Rubies</a> |
  <a href="#copyright">Copyright</a>
</p>

---

## Getting Started
Ruby and redd make creating reddit bots accessible and fun. To demonstrate, let's create a simple bot in four steps that responds to "Hello?" with "World!". *Note: this is just a tutorial; although you're welcome to take it on a test drive on a testing subreddit, don't actually host this bot.*

1. **Installing**  
   You can either install the gem directly by running `gem install redd` or by placing the gem into your `Gemfile` and running `bundle install`.
   ```ruby
   source "https://rubygems.org"
   gem "redd"
   
   # or if you're feeling adventurous
   gem "redd", github: "avidw/redd"
   ```

2. **Setting Up**  
   Let's load up redd and create a client for us to work with. (The username and password aren't real!)
   ```ruby
   require "redd"
   #=> true
   
   r = Redd::Client::Authenticated.new_from_credentials "HelloWorldBot", "hunter2", user_agent: "HelloWorldBot v1.0 by /u/you"
   # => #<Redd::Client::Authenticated:0xY4D4y4D4y4dA ...
   ```

3. **Scouting**  
   Redd has a really cool method similar to praw's `helpers.comment_stream` that "streams" comments to you while avoiding duplicates. You won't have to take care of rate-limiting either; Redd `sleep`s after requests to avoid ratelimit errors. If you want to write a rate limiting class yourself, take a look at `lib/redd/rate_limit.rb`
   ```ruby
   r.comment_stream "test" do |comment|
      comment.reply "World!" if comment.body =~ /^Hello\?$/i
   end
   ```

4. **Just in Case**  
   It's also a good idea to escape some common errors from reddit in case they happen:
   ```ruby
   begin
      r.comment_stream "test" do |comment|
        comment.reply "World!" if comment.body =~ /^Hello\?$/i
      end
    rescue Redd::Error::RateLimited => e
      time_left = e.time
      sleep(time_left)
    rescue Redd::Error => e
      status = e.code
      # 5-something errors are usually errors on reddit's end.
      raise e unless (500...600).include?(status)
   end
   ```

## OAuth2
Redd also provides a wrapper to connect to reddit via OAuth2. The client's methods are similar to the authenticated client, given that you have the required scopes. Refer to [reddit's api](https://www.reddit.com/dev/api/oauth) for the various scopes. Getting it running is really simple and can even be used to integrate reddit's features into a [Rails](https://github.com/rails/rails) application. Another plus is that logging in via OAuth2 lets you make twice as many requests without hitting a rate limit (1/second). Let's try logging into reddit with [**sinatra**](http://www.sinatrarb.com/).

The first thing you need to do is to create an OAuth2 application in reddit [**here**](https://ssl.reddit.com/prefs/apps). For more information, refer to [**"Getting Started"**](https://github.com/reddit/reddit/wiki/OAuth2#getting-started) on reddit's wiki. 

Note: Although I enter the client id and secret in the code directly, I recommend you store them in environment variables or a **`.env`** file and load it with [**dotenv**](https://github.com/bkeepers/dotenv).

```ruby
# config.ru

require "./connect_to_reddit"
run ConnectToReddit
```

```ruby
# connect_to_reddit.rb

require "sinatra/base"
require "redd"

class ConnectToReddit < Sinatra::Base
  configure do
    enable :sessions

    # If you're on Rails, you can replace the fixed url with a named one (e.g. redirect_url).
    set :client, Redd::Client::OAuth2.new("sa_xTDcJ3dWz0w", "very-sensitive-secret", "http://localhost:8080/auth/reddit/redirect")
  end

  get "/auth/reddit" do
    # Make use of the state!
    # SecureRandom, which is included in Ruby, helps create a url-safe random string.
    state = SecureRandom.urlsafe_base64
    session[:state] = state
    redirect settings.client.auth_url(["identity"], :temporary, state)
  end

  get "/auth/reddit/redirect" do
    raise "Your state doesn't match!" unless session[:state] == params[:state]

    access = settings.client.request_access(params[:code])
    me = settings.client.with_access(access) { |client| client.me }

    # Now use the Redd::Object::User object to create a user, maybe assign some
    # sort of token to remember their session.
    redirect to("/success")
  end
end
```

Now let's run the application:

```shell
$ rackup -p 8080
```

## Extending Redd
Extending any ruby library, including redd is incredibly easy. Let's try this out by adding a gilding extension. Reddit provides an api to be able to gild posts and comments, given that you have "creddits".

1. Let's start by creating a module for the methods to live in.
   ```ruby
   module MyGildingExtension
   end
   ```

2. Let's add a method to gild a thing, using the [reddit api](http://www.reddit.com/dev/api#section_gold) and following the conventions.
   ```ruby
   module MyGildingExtension
      def gild(thing)
        # Redd::Client::Unauthenticated::Utilities has some pretty helpful
        # methods.
        fullname = extract_fullname(thing)

        # We're using post instead of object_from_response, because we don't
        # expect any object from the response.
        post "/api/v1/gold/gild/#{fullname}"
      end
   end
   ```

3. Let's add the method to the Authenticated client. You can also add it to the Unauthenticated client, but since unauthenticated users can't gild, there's no point.
   ```ruby
   Redd::Client::Authenticated.include(MyGildingExtension)
   ```

4. You might also want to add the method to objects to make it easier to access.
   ```ruby
   module Gildable
      def gild
        # Every Redd::Object is instantiated with the client that created
        # it, so the method can be called on the client easily, similar to
        # praw in python.
        client.gild(self)
      end
   end

   Redd::Object::Submission.include(Gildable)
   Redd::Object::Comment.include(Gildable)
   ```

## Supported Rubies
This gem aims to work on the following rubies:

MRI: **1.9.3** - **2.1.2**  
JRuby: **1.7.x**  
Rubinius: **2.x.x**

## Copyright
Copyright (c) [Avinash Dwarapu](http://github.com/avidw) under the MIT License. See LICENSE.md for more details.  
Some code has been used from [RedditKit.rb](http://github.com/samsymons/RedditKit.rb). See RedditKit.LICENSE.md for more details.

---

Redd not your cup of tea? Check out [RedditKit.rb](http://github.com/samsymons/RedditKit.rb)!
