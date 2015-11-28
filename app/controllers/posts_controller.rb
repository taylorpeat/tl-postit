class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :vote]
  before_action :require_login, only: [:new, :create, :vote]
  before_action :require_current_user, only: [:edit, :update]

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
    if exist_vote = @post.votes.where(user_id: session[:user_id]).first
      exist_vote_check(exist_vote) and return
    end

    vote = @post.votes.create(vote: params[:vote], user_id: session[:user_id])

    if vote.valid?
      flash[:success] = "Your vote has been counted."
    else
      flash[:error] = "Your vote could not be counted."
    end
    redirect_to :back
  end

  private

  def post_params
    params.require(:post).permit(:title, :description, :url, category_ids: [])
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
