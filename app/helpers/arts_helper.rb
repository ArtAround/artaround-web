module ArtsHelper
  def pretty_print_tags submission
    return [] if submission.tag.nil?
    submission.tag.reject(&:blank?)
  end

  def pretty_print_categories submission
    return [] if submission.category.nil?
    submission.category.reject(&:blank?)
  end

  def pretty_print_artist submission
    return '' if submission.artist.nil?
    submission.artist
  end
end
