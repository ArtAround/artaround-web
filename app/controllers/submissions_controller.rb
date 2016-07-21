class SubmissionsController < ApplicationController
  def approve
    if art.apply_submission(submission)
      redirect_to art, notice: "Submission applied to #{art.title}"
    else
      raise "There was a problem while trying to apply submission"
    end
  end

  private

  def art
    Art.find_by_slug(params[:art_id])
  end

  def submission
    art.submissions.find(params[:id])
  end
end
