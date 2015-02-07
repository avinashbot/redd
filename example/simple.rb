require "redd"

reddit = Redd.it(:script,
  ENV["CLIENT_ID"],
  ENV["SECRET"],
  ENV["USERNAME"],
  ENV["PASSWORD"]
)

puts reddit.me.name
