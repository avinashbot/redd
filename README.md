<p align="center">
  <img src="https://i.imgur.com/2JfE4M1.png" alt="redd"><br>
  <a href="https://rubygems.org/gems/redd"><img src="http://img.shields.io/gem/v/redd.svg?style=flat-square" alt="Gem Version"></a>
  <a href="https://travis-ci.org/avidw/redd"><img src="http://img.shields.io/travis/avidw/redd.svg?style=flat-square" alt="Build Status"></a>
  <a href="https://rubygems.org/gems/redd"><img src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat-square" alt="MIT License"></a>
  <a href="https://rubygems.org/gems/redd"><img src="http://img.shields.io/gem/dt/redd.svg?style=flat-square" alt="Gem Downloads"></a>
</p>

**redd** is an API wrapper for [reddit](http://www.reddit.com/dev/api) written in ruby that focuses on being *simple and extensible*.  
**Check out the latest documentation on [RubyDoc](http://rubydoc.info/github/avidw/redd/oauth2/frames).**

---

```ruby
# Gemfile

gem "ruby", "~> 0.7.0"
# if you're feeling adventurous
# gem "redd", github: "avidw/redd", branch: "oauth2"
```

```ruby
# Getting Started.rb

require "bundler/setup"
require "redd"

r = Redd.it(:script,
  "CLIENT_ID", "SECRET",
  "Unidan", "hunter2",
  user_agent: "TestBot v1.0.0"
)

r.authorize!
puts "#{r.me.name} checking in!"

begin
  r.stream :get_comments, "all" do |comment|
    comment.reply("World!") if comment.body == "Hello?"
  end
rescue Redd::Error::RateLimited => error
  sleep(error.time)
  retry
rescue Redd::Error => error
  # 5-something errors are usually errors on reddit's end.
  raise error unless (500...600).include?(error.code)
  retry
end

```

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

```ruby
# How To Request A Feature.rb

def request_feature(feature)
  github.issues.add(feature)
  I.will_patch_it_in(:asap)
  enjoy!
end
```

```ruby
# Copyright.rb

# Copyright (c) Avinash Dwarapu under the MIT License. See LICENSE.txt for more details.
# Some code has been used from RedditKit.rb. See RedditKit.LICENSE.txt for more details.
```
