class ArtImport
  include Mongoid::Document
  include Mongoid::Timestamps

  field :import_count
  field :error_count
  field :total_count
  field :art_ids, type: Array
  field :errored_rows, type: Array


  def self.from_csv(csv_file)
    imported = []
    total_count = 0
    errors = []

    CSV.open(csv_file.path, headers: true).each do |row|
      total_count += 1
      begin
        art = Art.create_from_csv(row)
        imported << art
      rescue Exception => e
        errors << {row: row.to_h, exception: e.inspect, row_number: total_count}
      end
    end

    ArtImport.create import_count: imported.count,
      error_count: errors.count,
      total_count: total_count,
      art_ids: imported.map(&:id),
      errored_rows: errors
  end

  def to_csv
    url_helpers = Rails.application.routes.url_helpers

    CSV.generate do |csv|
      csv << ['Title', 'Public Url', 'Admin Url']
      arts.each do |art|
        csv << [
          art.title,
          url_helpers.art_url(art),
          url_helpers.admin_art_url(art)
        ]
      end
    end
  end

  def arts
    @arts ||= Art.in(id: art_ids)
  end
end
