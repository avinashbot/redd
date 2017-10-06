---
title: Creating Webapps with Redd
path: /tutorials/creating-webapps-with-redd
---
Redd can also help with simplifying web apps that need to use the reddit API thanks to OAuth2. This guide assumes you are somewhat familiar with web development on Ruby and skips some of the basic steps (you can always ask if you need help). The full code from this example can be found [**here**](https://gist.github.com/avinashbot/f298efca5622d77e4ba65abc57c253e4).

## A quick primer on OAuth2

1. A user goes to our fancy website.
2. Then, they see a cool orangered button labeled "login with reddit" and click it.
3. Our website then **redirects them to reddit**, which asks the user if they are sure want to login through reddit.
4. If they change their mind and press "Decline", **reddit redirects the user back to our site** saying that they denied giving us access.
5. If they press "Allow", **reddit redirects the user back to our site with a code**.
6. We can now **make a request to reddit with the code to get an access token** (and maybe a refresh token too).
7. Tada! Now that we have an access token, we can make API requests to reddit.
8. Once the access token has **expired**, we ask reddit to give us a new one using our refresh token.

## Step 1: Creating an Application

Start by visiting your [**applications**](https://www.reddit.com/prefs/apps#developed-apps) and skipping to the "**developed apps**" section and clicking the button to create an app. Give it a name and a description. Make it friendly, because the user is going to see them! You are also given a choice between three app types (two of which are relevant to us).

- **web app**: if you're running the application from a trusted server
- **installed app**: if you're running the application on the user's device

The "*redirect uri*" is the URL that the user gets redirected to once they've either allowed or denied access to reddit.

## Step 2: Break out the Rails (or Sinatra)

Let's start with a simple Sinatra app.

```ruby
require 'bundler/setup'
require 'sinatra'
require 'redd/middleware'

enable :sessions

get '/' do
  '<a href="/login">login with reddit</a>'
end
```

Sweet. That login link will 404, but we're going to fix that in next step.

## Step 3: The Secret Weapon

Redd (from `v0.8.6` onwards) sports a new [Rack Middleware](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Middleware) that makes integrating Redd with traditional web-apps much easier. In your preferred framework (guides for [Rails](http://guides.rubyonrails.org/rails_on_rack.html#adding-a-middleware), [Sinatra](http://www.sinatrarb.com/intro.html#Rack%20Middleware), [Rackup](https://github.com/rack/rack/wiki/%28tutorial%29-rackup-howto)), add the Redd::Middleware, providing it options similar to the following:

```ruby
use Redd::Middleware,
    user_agent:   'Redd:Your App:v1.0.0 (by /u/<your username>)',
    client_id:    '<your client id>',
    secret:       '<your app secret>',
    redirect_uri: '<your redirect uri>',
    scope:        %w(identity),
    via:          '/login'
```

Before continuing, **make sure that sessions are enabled**.

- Rails: has it in by default. No work needed on your end.
- Sinatra: Add `enable :sessions` **before** adding the `Redd::Middleware`.
- Rackup: Add `use Rack::Session::Cookie` **before** adding the `Redd::Middleware`.

Modify as needed. The `via` option specifies the path that takes the user to the authorization page (`/auth/reddit` by default). We'll use `/login` since that's we used in the previous step.

## Step 4: All Logged In (Maybe)

When the user comes back to our site, they are sent to the redirect uri that we gave reddit. So let's define a route so that our user isn't met with a 404 when they authorize us. Assuming our redirect uri is something like `https://<your website>/redirect`, the code should look like this:

```ruby
get '/redirect' do
  redirect to('/profile')
end
```

But what if the user clicked deny? Or what if the user got sent to us because of a [CSRF attack](https://www.owasp.org/index.php/Cross-Site_Request_Forgery_%28CSRF%29)? Redd detects that and puts an exception in the 'redd.error' rack environment variable. If you already have a mechanism in place to deal with exceptions, you can just raise the error.

```ruby
get '/redirect' do
  redirect to('/profile') if request.env['redd.error'].nil?
  
  if request.env['redd.error'].message == 'access_denied'
    'Sorry, you clicked decline. <a href="/login">Login again?</a>'
  elsif request.env['redd.error'].message == 'invalid_state'
    'Did you login through our website? <a href="/login">(No)</a>'
  else
    puts "Error while logging in!"
    raise request.env['redd.error'] # Raise a 500 and make a mental note to look at the logs later
  end
end
```

Much better.

## Step 5: Using the API

```ruby
get '/profile' do
  "Hi, #{request.env['redd.session'].me.name}! <a href='/logout'>Log out</a>"
end
```

Well, that was easy! `redd.session` is a [**Session**](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Session) model, which is basically a starting point for all the API calls that Redd offers.

## Step 6: Logging out

```ruby
get '/logout' do
  request.env['redd.session'] = nil
  redirect to('/')
end
```

Well, there isn't anything I need to explain, is there?

---

I know you're just excited to build your awesome website, but before you leave, a few tips:

- Here's the [**documentation**](http://www.rubydoc.info/github/avinashbot/redd/master/Redd/Models/Session), and feel free to [**shoot me a message**](https://www.reddit.com/message/compose/?to=Mustermind) if you need help.
- Rate limits still apply (although they're per user). If you're going to be making many API requests per page request, you might want to look into caching.
- There are restrictions on commercial use of the API. [**Here's the rules on that**](https://www.reddit.com/wiki/api).
- I love hearing about the crazy ways you people make use of my gem! Feel free to post in this subreddit if you have an application that relies on Redd.