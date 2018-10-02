class Admin::StatsController < Admin::AdminController
  def index
  end

  def tags
    @tags = Art.counts_grouped_by_tags
    @tags_in_the_last_month = Art.counts_grouped_by_tags(Art.last_month)
  end

  def categories
    @categories = Art.counts_grouped_by_categories
    @categories_in_the_last_month = Art.counts_grouped_by_categories(Art.last_month)
  end

  def artists
    @artists = Art.counts_grouped_by_artists
    @artists_in_the_last_month = Art.counts_grouped_by_artists(Art.last_month)
  end

  def cities
    @cities = Art.counts_grouped_by_cities
    @cities_in_the_last_month = Art.counts_grouped_by_cities(Art.last_month)
  end
end
