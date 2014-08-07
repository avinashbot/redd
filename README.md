<p align="center">
  <img src="github/redd.png?raw=true" alt="redd"><br>
  <a href="http://badge.fury.io/rb/redd"><img src="https://badge.fury.io/rb/redd.svg" alt="Gem Version" height="18"></a>
  <a href="https://gemnasium.com/avidw/redd"><img src="https://gemnasium.com/avidw/redd.svg" alt="Dependency Status"></a>
</p>

**redd** is an API wrapper for [reddit](http://reddit.com/dev/api) written in ruby that focuses on being *simple and extensible*.

---

<p align="center">
  <a href="#getting-started">Getting Started</a> |
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
   
   r = Redd.client "HelloWorldBot", "hunter2"
   # => #<Redd::Client::Authenticated:0xY4D4y4D4y4dA ...
   
   # This is generally a good thing to do:
   r.user_agent = "HelloWorldBot v1.0 (Redd), written by /u/Mustermind"
   ```

3. **Scouting**  
   Redd has a really cool method similar to praw's `helpers.comment_stream` that "streams" comments to you while avoiding duplicates. You won't have to take care of rate-limiting either; Redd `sleep`s after requests to avoid ratelimit errors. If you want to write a rate limiting class yourself, take a look at `lib/redd/rate_limit.rb`
   ```ruby
   r.comment_stream "test" do |comment|
     if comment.body =~ /^Hello\?$/i
       comment.reply "World!"
     end
   end
   ```

4. **Just in Case**
   It's also a good idea to escape some common errors from reddit in case they happen:
   ```ruby
   begin
     r.comment_stream "test" do |comment|
       if comment.body =~ /^Hello\?$/i
         comment.reply "World!"
       end
     end
   rescue Redd::Error::RateLimited => e
     time_left = e.time
     sleep(time_left)
   rescue Redd::Error => e
     status = e.message.status
     # 5-something errors are usually errors on reddit's end.
     raise e unless status.to_s.start_with? "5"
   end
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

       meth = :post
       path = "/api/v1/gold/gild/#{fullname}"

       # We're using send instead of object_from_response, because we don't
       # expect any object from the response.
       send(meth, path)
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
TODO: Travis CI

## Copyright
Copyright (c) [Avinash Dwarapu](http://github.com/avidw) under the MIT License. See LICENSE.md for more details.  
Some code has been used from [RedditKit.rb](http://github.com/samsymons/RedditKit.rb). See RedditKit.LICENSE.md for more details.

---

Redd not your cup of tea? Check out [RedditKit.rb](http://github.com/samsymons/RedditKit.rb)!
