module ApplicationHelper
  def fix_url(url)
    url.starts_with?("http://") || url.starts_with?("https://") ? url : "http://" + url
  end

  def format_time(time)
    time_ago_in_words(time) + " ago"
  end
end
