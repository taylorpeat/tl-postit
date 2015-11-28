class CommentsController < ApplicationController
  before_action :require_login

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(comment_params)
    @comment.user_id = session[:user_id]

    if @comment.save
      flash[:notice] = "You're comment was successfully created."
      redirect_to post_path(@post)
    else
      render 'posts/show'
    end
  end

   def vote
    @comment = Comment.find(params[:id])
    if exist_vote = @comment.votes.find_by(user_id: session[:user_id])
      return unless exist_vote_check(exist_vote) == nil
    end

    vote = @comment.votes.create(vote: params[:vote], user_id: session[:user_id])

    if vote.valid?
      flash[:success] = "Your vote has been counted."
    else
      flash[:error] = "Your vote could not be counted."
    end
    redirect_to :back
  end

  private

  def comment_params
    params.require(:comment).permit!
  end
end