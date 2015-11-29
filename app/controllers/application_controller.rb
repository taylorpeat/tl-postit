class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :local_user, :logged_in?

  def current_user
    if session[:user_id]
      User.find(session[:user_id])
    end
  end

  def local_user
    if params[:id]
      User.find(params[:id])
    end
  end

  def require_post_creator
    post = Post.find(params[:id])
    user = post.creator
    unless !current_user.nil? && current_user == user
      flash[:error] = "You are not authorized for this action."
      redirect_to :back
    end
  end

  def logged_in?
    @logged_in ||= !!current_user
  end

  def require_current_user
    unless !current_user.nil? && current_user == local_user
      flash[:error] = "You are not authorized for this action."
      redirect_to :back
    end
  end

  def require_login
    unless logged_in?
      flash[:error] = "You must be logged in for this action."
      redirect_to :back
    end
  end

  def exist_vote_check(exist_vote)
    unless exist_vote.vote.to_s == params[:vote]
      exist_vote.delete
      flash[:success] = "Your previous vote has been removed."
      redirect_to :back
    end
  end
end
