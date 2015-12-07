class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :vote]
  before_action :require_login, only: [:new, :create, :vote]
  before_action :require_post_creator, only: [:edit, :update]

  def index
    @page = params[:page].to_i if params[:page] || 0
    @last_page = (Post.all.size / POSTS_PER_PAGE.to_f).ceil
    @posts = Post.limit(POSTS_PER_PAGE).offset(@page * POSTS_PER_PAGE)
    respond_to(:html, :js)
  end

  def show
    @comment = Comment.new
    @limit_increase = params[:limit].to_i if params[:limit] || 0
    @comment_limit = 5 + @limit_increase
    respond_to(:html, :js)
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
      @post.process_vote(params[:vote], session[:user_id])
      format.html { redirect_to :back; flash[:notice] = @post.html_message }
      format.js
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :description, :url, category_ids: [])
  end

  def set_post
    @post = Post.find_by(slug: params[:id])
  end

  def require_post_creator
    access_denied unless logged_in? && current_user == @post.creator || admin?
  end
end
