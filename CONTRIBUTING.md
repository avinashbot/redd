# Contributing

This is the documentation that contains information on contributing to Redd.
Note that I would appreciate contributions to this document itself.

There isn't an official code of conduct, just
[don't be a dick](https://twitter.com/wilw/status/5966220832.).

### Filing an Issue / Making a Pull Request

**The quickest way to get a feature into Redd is by raising an issue.**

Please try to provide as much information as possible when submitting an
issue. I'm not going to get mad if the issue is inconsequential, so don't
hesitate to ask even simple questions about the gem.

When making a pull request, you don't really have to write tests for the
time being (what a relief for you!). Just make sure you have manually tested
the call yourself and rubocop doesn't whine about it too much.

### Architecture
The central part of the gem is the `Client`. It knows how to make HTTP
requests. For specific reddit behaviour, there is a subclass named
`APIClient`. Keep in mind that neither of these are actually aware of the API
methods, just how to interact with the API.

To simplify the architecture as much as humanly possible, everything is
represented as a model. A model holds a client and some attributes. It has
some methods that make API requests using the client and maybe some of its
attributes.

Each authentication method has an `AuthStrategy` associated with it. This only
provides API keys and is aware of the OAuth2 protocol.

The `Redd.it` method combines all of these:

1. It creates an `AuthStrategy`.
2. It creates an `APIClient` using the `AuthStrategy`.
3. It creates a `Session` model using the `APIClient`.
4. It returns the created `Session`.

This seems complicated but trust me on this, this gem has gone through three
rewrites.

### Reddit API

Here are some links where you can find helpful information about the reddit
API:

1. [API reference](https://www.reddit.com/dev/api)
2. [GitHub Wiki](https://github.com/reddit/reddit/wiki/API)
3. [API Subreddit](https://www.reddit.com/r/redditdev)

### Testing

Unit testing has turned out to be ultimately pointless; the API is a total
mess and requires a deep knowledge of how reddit works. Testing the multitude
of parameters that each call takes, it's safe to assume individual unit tests
will span a few thousand lines and be incredibly brittle. So when you submit a
pull-request, I expect you to have *manually tested the calls yourself*.

To help you, there is a console that can be found at `./bin/console`. Give it
a shot — I think you'll love it!
