require "redd"
require "sinatra"
require "secure_random"

reddit = Redd.it(:web,
  ENV["CLIENT_ID"],
  ENV["SECRET"],
  ENV["REDIRECT_URI"]
)

enable :sessions

get "/" do
  if session[:access]
    access = Redd::Access.from_json(session[:access])
    reddit.with(access) { |client| "Welcome back, #{client.me.name}!" }
  else
    redirect to("/authorize")
  end
end

get "/authorize" do
  state = SecureRandom.urlsafe_base64
  auth_url = reddit.auth_url(state, [:identity], :temporary)
  redirect auth_url, 301
end

get "/redirect" do
  access = reddit.authorize!(params[:code])
  session[:access] = access.to_json
  redirect to("/")
end
