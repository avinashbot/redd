<div align="center">
  <!-- Redd -->
  <img src="logo.png" width="500"><br>

  <!-- Intro Text -->
  <strong>Redd</strong> is an API wrapper
  for <a href="https://www.reddit.com/dev/api">reddit</a>
  that is all about being <strong>simple</strong>
  and <strong>intuitive</strong>.
</div>

---

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
  elsif comment.body.include?('flip a coin') || comment.body.include?('coin flip')
    coin_face = (rand(0..1) == 1 ? 'heads' : 'tails')
    comment.reply("I just flipped a coin! It's #{coin_face}!")
  end
end
```

---

### FAQ

#### Is that bot fully functional?
**Yes**, that's all there is to it! You don't need to handle rate-limiting, refresh access tokens
or protect against issues on reddit's end (like 5xx errors).

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
