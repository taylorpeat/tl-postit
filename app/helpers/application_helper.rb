module ApplicationHelper
  def fix_url(url)
    url.starts_with?("http://") || url.starts_with?("https://") ? url : "http://" + url
  end

  def format_time(time)
    time_ago_in_words(time) + " ago"
  end

  def format_full_time(time)
    if logged_in? && !current_user.time_zone.blank?
      time = time.in_time_zone(current_user.time_zone)
    end
    time = time.strftime("%m/%d/%Y %l:%M%P %Z")
  end

  def voted_true?(obj)
    if vote_object = obj.votes.find_by(user_id: current_user.id)
      "collapse" if vote_object.vote
    end
  end

  def voted_false?(obj)
    if vote_object = obj.votes.find_by(user_id: current_user.id)
      "collapse" unless vote_object.vote
    end
  end
end
