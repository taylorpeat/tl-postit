class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :vote]
  before_action :require_login, only: [:new, :create, :vote]
  before_action :require_post_creator, only: [:edit, :update]

  def index
    @posts = Post.all
  end

  def show
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = session[:user_id]
    if @post.save
      flash[:notice] = "Your post was saved."
      redirect_to post_path(@post)
    else
      render :new
    end
  end

  def edit
  end

  def update
    @post.update(post_params)
    if @post.save
      flash[:notice] = "Your post was updated."
      redirect_to post_path(@post)
    else
      render 'edit'
    end
  end

  def vote
    respond_to do |format|
      if exist_vote = @post.votes.find_by(user_id: session[:user_id])
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
        vote = @post.votes.create(vote: params[:vote], user_id: session[:user_id])
        
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

  def post_params
    params.require(:post).permit(:title, :description, :url, category_ids: [])
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
