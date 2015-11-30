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
    respond_to do |format|
      if exist_vote = @comment.votes.find_by(user_id: session[:user_id])
        unless exist_vote.vote.to_s == params[:vote]
          exist_vote.delete
          @message = "Vote<br>removed".html_safe
          @fade_in = exist_vote.vote ? ".icon-arrow-up" : ".icon-arrow-down"
          @fade_out = "#no_id"
          format.html { redirect_to :back; flash[:success] = "Your previous vote has been removed." }
          format.js {}
        end
      end

      if @message == nil
        vote = @comment.votes.create(vote: params[:vote], user_id: session[:user_id])

        if vote.valid?
          @fade_in = "#no_id"
          if vote.vote
            @fade_out = ".icon-arrow-up"
          else
            @fade_out = ".icon-arrow-down"
          end
          format.html { redirect_to :back; flash[:success] = "Your vote has been counted." }
          format.js { @message = "Vote<br>counted".html_safe }
        else
          format.html { redirect_to :back; flash[:error] = "Your vote could not be counted." }
          format.js { @message = "Vote<br>not<br>counted".html_safe }
        end
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit!
  end
end