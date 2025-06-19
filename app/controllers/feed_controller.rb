class FeedController < ApplicationController
  def show
    @post = Post.all
  end
end
