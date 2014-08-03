require "redd"

c = Redd.client
s = c.get_info(id: "t3_2cfy08")

puts c.get_comments(s)