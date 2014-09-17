describe Redd::Client::Authenticated::LinksComments do
  describe "#submit" do
    before do
      # create the posts
    end

    it "submits a text post correctly"
    it "submits a link post correctly"

    after do
      # delete the posts?
    end
  end

  describe "#add_comment" do
    context "when commenting on a link" do
      it "posts the comment correctly"
    end

    context "when replying to a comment" do
      it "posts the reply correctly"
    end

    context "when replying to a message" do
      it "replies to the message correctly"
    end

    after do
      # delete the reply and the comment?
      # we can't do anything for messages
    end
  end

  describe "#delete" do
    context "when deleting a comment" do
      before do
        # create a comment
      end

      it "deletes a comment successfully"
    end

    context "when deleting a link" do
      before do
        # create a link
      end

      it "deletes a link successfully"
    end
  end

  describe "#edit" do
    context "when editing a comment" do
      before do
        # create a comment
      end

      it "edits a comment successfully"

      after do
        # delete the comment
      end
    end

    context "when editing a link" do
      before do
        # create a link
      end

      it "edits a link successfully"

      after do
        # delete the link
      end
    end
  end

  describe "#hide" do
    before do
      # create a link
    end

    it "hides a link successfully"

    after do
      # delete the link
    end
  end

  describe "#unhide" do
    before do
      # create a link
    end

    it "unhides a link successfully"

    after do
      # delete the link
    end
  end

  describe "#mark_as_nsfw" do
    before do
      # create a link
    end

    it "marks a link as NSFW successfully"

    after do
      # delete the link
    end
  end

  describe "#unmark_as_nsfw" do
    before do
      # create a link
    end

    it "removes the NSFW mark from a link successfully"

    after do
      # delete the link
    end
  end

  # Nobody's going to give my testing suite gold, are they?
  describe "#save" do
    before do
      # create a link
    end

    it "saves the link successfully"

    after do
      # delete the link
    end
  end

  describe "#unsave" do
    before do
      # create a link
    end

    it "unsaves the link successfully"

    after do
      # delete the link
    end
  end

  describe "#upvote" do
    context "when upvoting a comment" do
      before do
        # create a comment
      end

      # We can't always count on the score increasing
      it "adds the comment to the user's liked list"

      after do
        # delete the comment
      end
    end

    context "when upvoting a link" do
      before do
        # create a link
      end

      it "adds the link to the user's liked list"

      after do
        # delete the link
      end
    end
  end

  describe "#downvote" do
    context "when downvoting a comment" do
      before do
        # create a comment
      end

      # We can't always count on the score increasing
      it "adds the comment to the user's disliked list"

      after do
        # delete the comment
      end
    end

    context "when downvoting a link" do
      before do
        # create a link
      end

      it "adds the link to the user's disliked list"

      after do
        # delete the link
      end
    end
  end

  describe "#unvote" do
    context "when unvoting a comment" do
      before do
        # create a comment and like it
      end

      # We can't always count on the score increasing
      it "removes the comment from the user's liked list"

      after do
        # delete the comment
      end
    end

    context "when unvoting a link" do
      before do
        # create a link
      end

      it "removes the link from the user's liked list"

      after do
        # delete the link
      end
    end
  end
end
