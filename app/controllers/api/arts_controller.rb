class Api::ArtsController < Api::ApiController
  before_action :load_art, :only => :show

  def index
    render :json => json_for_arts
  end

  def create
    # Drop the Rails-related parameters
    vals = params.reject { |k, v| %w[ controller action format ].include?(k) }

    # Clean the Params as the ios app encodes them.
    vals = ParamsCleaner.clean(vals)
    # Create a new Art object with the values received from the API client.
    # Some values are protected from mass-assignment, so they will need to
    # be set manually.

    if vals[:category]
      vals[:category] = vals[:category].split(',')
    end

    art = Art.new(vals)

    art.approved = true # auto-approve, would default to false otherwise

    if vals[:location]
      latitude = vals[:location][0].to_f
      longitude = vals[:location][1].to_f
      art.location = [latitude, longitude]
    end

    unless vals[:commissioned_by].blank?
      @commissioner = Commissioner.where({:name => /^#{vals[:commissioned_by]}/i}).first
      if @commissioner.nil?
        @commissioner = Commissioner.create(:name => vals[:commissioned_by])
      end
    end

    respond_to do |format|
      format.json do
        # If the art is successfully saved, send back the JSON representation
        # of the art. Otherwise, send back the errors and a Bad Request
        # status code.
        if art.safely.save
          AdminMailer.new_art(art).deliver
          unless @commissioner.nil?
            @commissioner.arts.push(art)
            @commissioner.save
          end
          render :json => { :success => art.slug }
        else
          Rails.logger.info "Could not save art: #{art.errors}"
          render :json => art.errors, :status => 400
        end
      end
    end
  end

  def photos
    art = Art.find_by_slug(params[:id])

    # Send back a 404 message if the art was not found. Since
    # this is an API, no body is required.
    head :not_found and return unless art

    photo = create_photo art, params[:file], params[:photo_attribution_text], params[:photo_attribution_url]

    if photo.save
      AdminMailer.new_photo(art).deliver
      render json: json_for_art(art)
    else
      render json: { success: false, errors: photo.errors.messages.values.flatten }, status: 500
    end
  end

  def show
    @art.inc :api_visits, 1
    @art.inc :total_visits, 1
    render json: {
      art: json_for_art(@art)
    }
  end

  def update
    art = Art.find_by_slug(params[:id])

    # Send back a 404 message if the art was not found. Since
    # this is an API, no body is required.
    head :not_found and return unless art

    data = params.reject { |k, v| %w[ controller action format id ].include?(k) }
    # Clean the Params as the ios app encodes them.
    ParamsCleaner.clean(data)

    submission = art.submissions.build(data)

    respond_to do |format|
      format.json do
        if submission.save
          AdminMailer.new_art_info(art, submission).deliver
          render json: { success: true }
        else
          Rails.logger.info "Could not save submission: #{submission.errors}"
          render json: { success: false }, status: 400
        end
      end
    end
  end

  def comments
    art = Art.find_by_slug(params[:id])

    # Send back a 404 message if the art was not found. Since
    # this is an API, no body is required.
    head :not_found and return unless art

    vals = {
      name: params[:name],
      email: params[:email],
      url: params[:url],
      text: params[:text]
    }
    # Clean the Params as the ios app encodes them.
    ParamsCleaner.clean(vals)

    comment = art.comments.build(vals)
    comment.ip_address = request.ip

    respond_to do |format|
      format.json do
        # Respond with 200 if the comment was posted successfully or tell the
        # client it was a BadRequest otherwise
        if comment.save
          AdminMailer.new_comment(art, params[:name], params[:text]).deliver
          render json: { success: true }
        else
          Rails.logger.info "Comment for art #{art.id} could not be saved: #{comment.errors}"
          render json: { success: false }
        end
      end
    end
  end

  def neighborhoods_api
    render json: neighborhoods.to_json
  end

  def categories_api
    render json: categories.to_json
  end

  def tags_api
    render json: tags.to_json
  end

  protected

  def load_art
    @art = Art.approved.find(params[:id])
  end
end
