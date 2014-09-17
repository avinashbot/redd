## Setting up the testing environment on reddit

    # Create a subreddit for testing.
    $ export REDDIT_SUBREDDIT=redd_testing

    # Create an account for testing. You can use your reddit account.
    $ export REDDIT_USERNAME=redd-testing
    $ export REDDIT_PASSWORD=????????

    # Create an example post on the subreddit
    $ export REDDIT_LINKID=t3_2gngbm

    # Create a page on the wiki with the following name
    # Remember to make the wiki set to "mod editing"
    $ export REDDIT_WIKIPAGE=redd_wiki_test

    # Grab a sandwich or something. The tests are rate-limited.
    $ rspec