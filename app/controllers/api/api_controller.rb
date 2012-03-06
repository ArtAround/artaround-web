class Api::ApiController < ApplicationController
  
  def json_for_art(art)
    
    {
      :art => clean(art.attributes).merge(:comments => json_for_comments(art))
    }
  end

  def json_for_arts
    arts = Art.only(art_fields).approved

    if params[:order] == 'hotness'
      arts = arts.desc :total_visits
    end
    
    # get it from the criteria before the content is lazily loaded
    total_count = arts.count
    pagination = paginate_options
    
    skip = pagination[:per_page] * (pagination[:page]-1)
    limit = pagination[:per_page]

    results = arts.skip(skip).limit(limit).map {|art| clean art.attributes}
    {
      :arts => results,
      :page => pagination.merge(:count => results.size),
      :total_count => total_count
    }.to_json
  end
  
  def json_for_comments(art)
    art.comments.only(comment_fields).approved.all.map {|comment| clean comment.attributes}
  end
  
  def clean(attributes)
    [:_id, :updated_at].each {|key| attributes.delete(key)}
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
    [:slug, :description, :location_description, :artist, :location, :created_at, :updated_at, :category, :title, :flickr_ids, :updated_at, :year, :neighborhood, :ward, :commissioned, :ranking, :event, :event_starts_at, :event_ends_at]
  end
  
  def comment_fields
    [:name, :created_at, :url, :text]
  end
end