class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :local_user, :logged_in?, :admin?

  POSTS_PER_PAGE = 3

  def current_user
    if session[:user_id]
      User.find(session[:user_id])
    end
  end

  def local_user
    if params[:id]
      User.find_by(slug: params[:id])
    end
  end

  def post_creator?

  end

  def logged_in?
    @logged_in ||= !!current_user
  end

  def admin?
    @admin ||= logged_in? && current_user.role == "admin"
  end

  def require_current_user
    access_denied unless !current_user.nil? && current_user == local_user  
  end

  def require_admin
    access_denied unless admin?
  end

  def access_denied
    flash[:error] = "You are not authorized for this action."
    redirect_to root_path
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
        format.html { redirect_to :back; flash[:success] = "Your previous vote has been removed." }
        format.js { @message = "Previous<br>vote<br>removed".html_safe }
    end
  end
end
