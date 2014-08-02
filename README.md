<p align="center">
  <img src="github/redd.png?raw=true" alt="redd"><br>
  <a href="http://badge.fury.io/rb/redd"><img src="https://badge.fury.io/rb/redd.svg" alt="Gem Version" height="18"></a>
  <a href="https://gemnasium.com/avidw/redd"><img src="https://gemnasium.com/avidw/redd.svg" alt="Dependency Status"></a>
</p>

**redd** is an API wrapper for [reddit](http://reddit.com/dev/api) written in ruby that focuses on being *simple and extensible*.  
**NOTE: Major features are not implemented yet!**

---

<p align="center">
  <a href="#getting-started">Getting Started</a> |
  <a href="#extending-redd">Extending Redd</a> |
  <a href="#conventions">Conventions</a> |
  <a href="#supported-rubies">Supported Rubies</a> |
  <a href="#copyright">Copyright</a>
</p>

---

## Getting Started
TODO: Elaborate.

```ruby
require "redd"

client = Redd.client
redditdev = client.subreddit("redditdev")

latest_post = redditdev.get_new.first
puts latest_post.title
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

## Conventions
### Method Names
- A method that returns a Redd::Object directly is called that in lowercase. For example, a method that returns a single `Redd::Object::Subreddit` is called `subreddit`
- Any method that return a listing is in the format `get_[thing]s`. For example, a method that returns a listing of subreddits is named `get_subreddits`.
- An **internal** method that edits an existing object is **usually** named `edit_[thing]`. This is often used in conjuction with the "my" rule below. Some exeptions to this rule are `vote` that edit a user's vote.
- Any method that returns something specific to the user must have "my" in the middle. For example, a method that returns a users subscribed subreddits is named `get_my_subscriptions` and a method that edits a users subscription is named `edit_my_subscription`. Note the change in singlular/plural.

### Methods
- Most methods that use an http request should usually follow this convention. I haven't had time to check the methods to see if they follow this, but this should be the case
  ```ruby
  def subreddit(thing, options = {})
    fullname = extract_fullname(thing)

    meth = :get
    path = "/r/ruby/about.json"
    params = options << {additional: "options"}

    object_from_response(meth, path, params)
  end
  ```

## Supported Rubies
TODO: Travis CI

## Copyright
Copyright (c) [Avinash Dwarapu](http://github.com/avidw) under the MIT License. See LICENSE.md for more details.  
Some code has been used from [RedditKit.rb](http://github.com/samsymons/RedditKit.rb). See RedditKit.LICENSE.md for more details.
