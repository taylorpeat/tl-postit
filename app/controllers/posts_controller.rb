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

    # if exist_vote = @post.votes.where(user_id: session[:user_id]).first
    #   exist_vote_check(exist_vote) and return
    # end

    vote = @post.votes.create(vote: params[:vote], user_id: session[:user_id])

    respond_to do |format|
      if vote.valid?
        format.html { redirect_to :back, flash[:success] = "Your vote has been counted." }
        format.js
      else
        format.html { redirect_to :back, flash[:error] = "Your vote could not be counted." }
        format.js
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
