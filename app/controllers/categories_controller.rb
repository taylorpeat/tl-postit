class CategoriesController < ApplicationController
  before_action :require_admin, only: [:new, :create]

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:notice] = "A new category was created."
      redirect_to posts_path
    else
      render 'new'
    end
  end

  def show
    @page = params[:page].to_i if params[:page] || 0
    @category = Category.find_by(slug: params[:id])
    @last_page = (@category.posts.size / POSTS_PER_PAGE.to_f).ceil
    @posts = @category.posts.limit(POSTS_PER_PAGE).offset(@page * POSTS_PER_PAGE)
    respond_to(:html, :js)
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end