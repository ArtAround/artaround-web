class ArtsController < ApplicationController
  before_filter :load_art, :only => [:show, :comment, :submit, :add_photo, :flag]


  # New 2 step flow
  def new_art_photo
    @photo = Photo.new
  end

  def create_art_photo
    @photo = Photo.new(params[:photo])
    if @photo.save
      redirect_to new_art_path(:photo_id => @photo.id)
    else
      flash.now[:alert] = @photo.errors.messages.values.flatten.join(" ")
      redirect_to new_art_photo_path, :alert => @photo.errors.messages.values.flatten.join(" ")
    end
  end

  def new
    @art = Art.new
    @photo = Photo.find(params[:photo_id])
    if @photo.image_content_type == 'image/jpeg'
      exif = EXIFR::JPEG.new(@photo.image.path)
      if exif.gps?
        @art.location = exif.gps
      end
    end
  end

  def create
    latitude = params[:art].delete 'latitude'
    longitude = params[:art].delete 'longitude'

    # remove special case
    latitude = (latitude || "").strip
    longitude = (longitude || "").strip
    latitude = ["Click on Map", ""].include?(latitude) ? nil : latitude.to_f
    longitude = ["Click on Map", ""].include?(longitude) ? nil : longitude.to_f
    unless params[:art]['commissioned_by'].blank?
      @commissioner = Commissioner.where({:name => /^#{params[:art]['commissioned_by']}/i}).first
      if @commissioner.nil?
        @commissioner = Commissioner.create(:name => params[:art]['commissioned_by'])
      end
    end

    @art = Art.new params[:art]
    @photo = Photo.find(params[:photo_id])

    @art.commissioned_by = @commissioner
    @art.location = [latitude, longitude] if latitude and longitude

    @art.approved = true # auto-approve, would default to false otherwise

    # Get around Rails bug that introduces empty element with multiple selects
    @art.category.reject!(&:blank?)

    if @art.safely.save
        AdminMailer.new_art(@art).deliver
        unless @commissioner.nil?
          @commissioner.arts.push(@art)
          @commissioner.save
        end
        @art.photos << @photo

        redirect_to art_path(@art), :notice => "Thanks for contributing a new piece of art!"
    else
      render :new
    end
  end

  def submit
    @submission = @art.submissions.build params[:submission]

    if @submission.save
      @art.submitted_at = Time.now
      @art.save!

      AdminMailer.new_art_info(@art, @submission).deliver

      redirect_to art_path(@art), :notice => "Thanks for helping us fill in the gaps! We moderate submissions, so your contribution should appear shortly."
    else
      @comment = Comment.new
      render :show
    end
  end

  def add_photo
    redirect_to(art_path(@art)) and return false unless params[:new_photo] and params[:new_photo].respond_to?(:path)

    # size check
    if File.size(params[:new_photo].path) > (1024*1024 * 6)
      redirect_to art_path(@art), :alert => "We ask that uploaded photos be less than 6MB in size. Please resize your photo so that it takes up less space and try again."
      return false
    end

    photo = create_photo @art, params[:new_photo], params[:photo_attribution_text], params[:photo_attribution_url]
    if photo.save
      AdminMailer.new_photo(@art).deliver
      redirect_to art_path(@art), :notice => "Thank you for contributing your photo! It should appear in the slideshow below."
    else
      redirect_to art_path(@art), :alert => photo.errors.messages.values.flatten.join(" ")
    end
  end

  def show
    @comment = Comment.new
    @submission = @art.new_submission
    @art.inc :web_visits, 1
    @art.inc :total_visits, 1
    @other_photos = @art.photos.to_a.reject {|p| p == @art.primary_photo}
  end

  def comment
    @comment = @art.comments.build params[:comment]
    @comment.ip_address = request.ip

    if @comment.save
      AdminMailer.new_comment(@art, params[:comment]['name'], params[:comment]['text']).deliver
      redirect_to @art, :notice => "Your comment will be posted soon. Thanks for contributing!"
    else
      @submission = @art.new_submission
      redirect_to art_path(@art), :alert => @comment.errors.messages.flatten.join(" ")
    end
  end

  def flag
    @art.update_attributes :flagged_at => Time.now
    AdminMailer.art_flagged(@art, params[:text], params[:source]).deliver
    if params[:source] == "web"
      redirect_to art_path(@art), :notice => "Thanks for the report!"
    else
      head 201
    end
  end


  protected

  def load_art
    unless params[:id] and (@art = Art.where(:approved => true, :slug => params[:id]).first)
      head :not_found and return false
    end
  end

end
