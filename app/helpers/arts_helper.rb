module ArtsHelper
  def pretty_print_tags submission
    return [] if submission.tag.nil?
    submission.tag.reject(&:blank?)
  end

  def pretty_print_categories submission
    return [] if submission.category.nil?
    return [submission.category] if submission.category.is_a?(String)
    submission.category.reject(&:blank?)
  end

  def pretty_print_artist submission
    return '' if submission.artist.nil?
    submission.artist
  end

  def comment_url comment
    if comment.url.include? "http://"
      comment.url
    else
      "http://#{comment.url}"
    end
  end
end
