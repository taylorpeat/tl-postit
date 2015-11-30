module ApplicationHelper
  def fix_url(url)
    url.starts_with?("http://") || url.starts_with?("https://") ? url : "http://" + url
  end

  def format_time(time)
    time_ago_in_words(time) + " ago"
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
