<p align="center">
  <img src="https://i.imgur.com/2JfE4M1.png" alt="redd"><br>
  <a href="https://rubygems.org/gems/redd"><img src="http://img.shields.io/gem/v/redd.svg?style=flat-square" alt="Gem Version"></a>
  <a href="https://travis-ci.org/avidw/redd"><img src="http://img.shields.io/travis/avidw/redd.svg?style=flat-square" alt="Build Status"></a>
  <a href="https://rubygems.org/gems/redd"><img src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat-square" alt="MIT License"></a>
</p>

**redd** is an API wrapper for [reddit](http://www.reddit.com/dev/api) written in ruby that focuses on being consistent and extensible. **Check out the latest documentation on [RubyDoc](http://www.rubydoc.info/github/avidw/redd/master/frames/Redd.it).**

---

#### Gemfile
```ruby
gem "ruby", "~> 0.7.0"
# if you're feeling adventurous
# gem "redd", github: "avidw/redd"

gem "oj", platforms: :ruby
```

#### Getting Started
```ruby
# Authorization (Web)
w = Redd.it(:web, "CLIENT_ID", "SECRET", "REDIRECT_URI", user_agent: "TestSite v1.0.0")
url = w.auth_url("random_state", ["identity", "read"], :temporary)
puts "Please go to #{url} and enter the code below:"
code = gets.chomp
w.authorize!(code)

# Authorization
r = Redd.it(:script, "CLIENT_ID", "SECRET", "Unidan", "hunter2", user_agent: "TestBot v1.0.0")
r.authorize!

# See documentation for more grants.
```

```ruby
# Access
require "secure_random"
require "sinatra"

enable :sessions

get "/auth" do
  state = SecureRandom.urlsafe_base64
  session[:state] = state
  redirect w.auth_url(state, %w(identity), :permanent)
end

get "/redirect" do
  halt 500, "Your state doesn't match!" unless session[:state] == params[:state]
  access = w.authorize!(params[:code])
  session[:access] = access.to_json
  redirect to("/name")
end

get "/name" do
  if session[:access]
    session_access = Redd::Access.from_json(session[:access])
    w.with(session_access) do |client|
      client.refresh_access! if session_access.expired?
      "Your username is #{client.me.name}"
    end
  else
    redirect to("/auth")
  end
end

```

```ruby
# Getting a model
vargas = r.user_from_name("_vargas_")
puts vargas.keys
puts vargas.over_18?

picturegame = r.subreddit_from_name("picturegame")
puts picturegame.display_name
puts picturegame.public_description
```

```ruby
# Listings
hot = r.get_hot("all")
hot.each { |link| puts "#{link.title} by /u/#{link.author}" }
```

```ruby
# Streaming
def stream_all!
  r.stream :get_comments, "all" do |comment|
    comment.reply("World!") if comment.body == "Hello?"
  end
end
```

```ruby
# Escaping Errors
begin
  stream_all!
rescue Redd::Error::RateLimited => error
  sleep(error.time)
  retry
rescue Redd::Error => error
  # 5-something errors are usually errors on reddit's end.
  raise error unless (500...600).include?(error.code)
  retry
end
```

#### Extras
```ruby
# Extending Redd.rb

module MyGildingExtension
  def gild!
    # We're using post instead of request_object, because we don't
    # expect any object from the response.
    post("/api/v1/gold/gild/#{fullname}")
  end
end

Redd::Objects::Comment.include(MyGildingExtension)
Redd::Objects::Submission.include(MyGildingExtension)
```

```markdown
# Contributing
1. [Fork](https://github.com/avidw/redd/issues/new)
2. [Pull](https://github.com/avidw/redd/compare)
3. [Profit](https://www.reddit.com/r/requestabot)

# Request a Feature
1. [Help](https://github.com/avidw/redd/issues/new)
```

```ruby
# Copyright.rb
#
# Copyright (c) Avinash Dwarapu under the MIT License. See LICENSE.txt for more details.
# Redd::Error has been modified from RedditKit.rb. See RedditKit.LICENSE.txt for its license.
```
