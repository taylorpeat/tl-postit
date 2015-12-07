class CommentsController < ApplicationController
  before_action :require_login

  def create
    @post = Post.find_by(slug: params[:post_id])
    @comment = @post.comments.new(comment_params)
    @comment.user_id = session[:user_id]
    @comment_limit = 5

    if @comment.save
      flash[:notice] = "You're comment was successfully created."
      redirect_to post_path(@post)
    else
      render 'posts/show'
    end
  end

  def vote
    @comment = Comment.find(params[:id])
    respond_to do |format|
      @comment.process_vote(params[:vote], session[:user_id])
      format.html { redirect_to :back; flash[:notice] = @post.html_message }
      format.js
    end
  end

  private

  def comment_params
    params.require(:comment).permit!
  end
end