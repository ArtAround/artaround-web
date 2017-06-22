class Admin::SubmissionsController < Admin::AdminController
  def approve
    if art.apply_submission(submission)
      redirect_to art, notice: "Submission applied to #{art.title}"
    else
      raise "There was a problem while trying to apply submission"
    end
  end

  def destroy
    submission.delete
    respond_to do |format|
      format.json { render json: { message: 'Submission deleted' } }
    end
  end

  private

  def art
    Art.find(params[:art_id])
  end

  def submission
    art.submissions.find(params[:id])
  end
end
