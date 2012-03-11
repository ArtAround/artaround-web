class Api::ApiController < ApplicationController
  
  def json_for_art(art)
    hash = art.as_json :include => :event
    hash = clean hash, art_fields
    hash[:comments] = art.comments.approved.all.map {|comment| clean comment.attributes, comment_fields}
    hash[:event] = clean(hash[:event], event_fields)
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
      hash = art.as_json :include => :event
      hash = clean hash, art_fields
      hash[:event] = clean(hash[:event], event_fields)
      hash
    end
    {
      :arts => results,
      :page => pagination.merge(:count => results.size),
      :total_count => total_count
    }.to_json
  end
  
  def json_for_comments(art)
    
  end
  
  def clean(attributes, whitelist)
    return nil unless attributes
    attributes.keys.each {|key| attributes.delete(key) unless whitelist.include?(key.to_sym)}
    attributes
  end
  
  def paginate_options
    page = (params[:page] || 1).to_i
    page = 1 if page.to_i < 1
    
    per_page = (params[:per_page] || 20).to_i
    per_page = 20 if per_page.to_i < 1
    
    {:page => page, :per_page => per_page}
  end
  
  
  def art_fields
    [
      :slug, :description, :location_description, :artist, :location, 
      :created_at, :updated_at, :category, :title, :flickr_ids, :updated_at, 
      :year, :neighborhood, :ward, :commissioned, :ranking, :event
    ]
  end

  def event_fields
    [
      :name, :url, :description, :starts_at, :ends_at
    ]
  end

  def comment_fields
    [
      :name, :created_at, :url, :text
    ]
  end
end