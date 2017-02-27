<div align="center">
  <p>
    <!-- Redd -->
    <img src="logo.png" width="500"><br>

    <!-- Badges -->
    <a href="https://rubygems.org/gems/redd">
      <img src="http://img.shields.io/gem/v/redd.svg?style=flat-square" alt="Gem Version">
    </a>
    <a href="https://travis-ci.org/avinashbot/redd">
      <img src="http://img.shields.io/travis/avinashbot/redd.svg?style=flat-square" alt="Build Status">
    </a>
    <a href="https://rubygems.org/gems/redd">
      <img src="http://img.shields.io/gem/dt/redd.svg?style=flat-square" alt="Gem Downloads">
    </a>
  </p>

  <!-- Intro Text -->
  <p>
    <strong>Redd</strong> is a <strong>batteries-included</strong>
    API wrapper for <a href="https://www.reddit.com/dev/api">reddit</a>.
  </p>
</div>

---

### Features

- Supports most of the reddit API, including live threads and the beta mod-mail.
- Includes support for streaming new posts and comments.
- Built-in rate limiting and error handling.
- Automatic retrying of failed requests.

### Demo

```ruby
require 'redd'

session = Redd.it(
  user_agent: 'Redd:RandomBot:v1.0.0 (by /u/Mustermind)',
  client_id:  'PQgS0UaX9l70oQ',
  secret:     'PsF_kVZrW8nSVCG5kNsIgl-AaXE',
  username:   'RandomBot',
  password:   'hunter2'
)

session.subreddit('all').comment_stream do |comment|
  if comment.body.include?('roll a dice')
    comment.reply("I just rolled a dice! It's a #{rand(1..6)}!")
  elsif comment.body.include?('flip a coin')
    comment.reply("I just flipped a coin! It's a #{%w(heads tails).sample}!")
  end
end
```

### FAQ

#### Is that bot fully functional?
**Yes**, that's all there is to it! You don't need to handle rate-limiting, refresh access tokens or protect against issues on reddit's end (like 5xx errors).

#### Where can I find the documentation?

[**Gem**](http://www.rubydoc.info/gems/redd/Redd/Models/Session) / [**GitHub**](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Session)

#### How do I request a feature / contribute?

- The quickest way to get a feature into Redd is to raise a GitHub issue.
- Pull requests are also appreciated!
- Don't hesitate! There are no stupid questions!

#### How can I contact you?
[Reddit](https://www.reddit.com/message/compose/?to=Mustermind) /
[GitHub](https://github.com/avinashbot/redd/issues/new) /
[Email](mailto:avinash@dwarapu.me)

---

<div align="center">
  <!-- Copyright Notice -->
  <em>
  This project is available under the MIT License. See LICENSE.txt for more details.<br>
  The Redd logo uses the FARRAY font by Coquet Adrien.
  </em>
</div>
