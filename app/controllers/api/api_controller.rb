class Api::ApiController < ApplicationController

  def json_for_list(criteria)
    # get it from the criteria before the content is lazily loaded
    model = criteria.klass
    total_count = criteria.count
    
    pagination = paginate_options
    
    results = criteria.paginate(pagination).map {|document| scoped model, document.attributes}
    {
      model.to_s.underscore.pluralize => results,
      :page => pagination.merge(:count => results.size),
      :total_count => total_count
    }.to_json
  end
  
  def scoped(model, attributes)
    attributes.keys.each do |key|
      attributes.delete(key) unless model.json_fields.include?(key.to_sym)
    end
    attributes
  end
  
  def paginate_options
    page = params[:page] || 1
    page = 1 if page.to_i < 1
    
    per_page = params[:per_page] || 20
    per_page = 20 if per_page.to_i < 1
    
    {:page => page, :per_page => per_page}
  end
end