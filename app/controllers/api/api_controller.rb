class Api::ApiController < ApplicationController
  def json_for_art(art)
    hash = art.as_json
    hash = clean hash, art_fields
    hash[:comments] = art.comments.approved.all.map {|comment| clean comment.attributes, comment_fields}
    hash[:event] = event_for_art(art)
    hash[:photos] = photos_for_art(art)
    if art.commissioned_by.nil?
      hash[:commissioned_by] = nil
    else
      hash[:commissioned_by] = {
        name: art.commissioned_by.name,
        url: art.commissioned_by.url
      }
    end
    hash
  end

  def json_for_arts
    arts = Art.approved

    if params[:order] == 'hotness'
      arts = arts.desc :total_visits
    end

    # get it from the criteria before the content is lazily loaded
    total_count = arts.count
    pagination = paginate_options

    skip = pagination[:per_page] * (pagination[:page]-1)
    limit = pagination[:per_page]

    results = arts.skip(skip).limit(limit).map do |art|
      hash = art.as_json

      if art.artist
        hash[:artist] = art.artist.to_a
      end

      if art.commissioned_by.nil?
        hash[:commissioned_by] = nil
      else
        hash[:commissioned_by] = { name: art.commissioned_by.name }
      end
      hash = clean hash, art_fields
      hash[:event] = event_for_art(art)
      # hash[:photos] = photos_for_art(art)
      hash
    end
    {
      arts: results,
      page: pagination.merge(count: results.size),
      total_count: total_count
    }.to_json
  end

  def event_for_art(art)
    if event = art.event
      hash = clean(event.attributes.dup, event_fields)
      hash[:icon_thumbnail_url] = event.icon :thumbnail
      hash[:icon_thumbnail_retina_url] = event.icon :thumbnail_retina
      hash[:icon_small_url] = event.icon :small
      hash
    end
  end

  def photos_for_art(art)
    art.photos.map do |photo|
      {
        attribution_text: photo.attribution_text_for_display,
        attribution_url: photo.attribution_url,
        primary: photo.primary,
        image_thumbnail_url: photo.image(:thumbnail),
        image_small_url: photo.image(:small),
        image_big_url: photo.image(:big)
      }
    end
  end

  def clean(attributes, whitelist)
    return nil unless attributes
    attributes.select { |key, _| key.to_sym.in? whitelist }
  end

  def paginate_options
    page = (params[:page] || 1).to_i
    page = 1 if page.to_i < 1

    per_page = (params[:per_page] || 20).to_i
    per_page = 20 if per_page.to_i < 1

    { page: page, per_page: per_page }
  end

  def art_fields
    [
      :slug, :description, :location_description, :artist, :location,
      :created_at, :updated_at, :category, :title, :updated_at,
      :year, :neighborhood, :ward, :commissioned, :ranking, :event,
      :commissioned_by, :website, :tag
    ]
  end

  def event_fields
    [
      :name, :website, :description, :starts_at, :ends_at, :slug
    ]
  end

  def comment_fields
    [
      :_id, :name, :created_at, :url, :text
    ]
  end
end
