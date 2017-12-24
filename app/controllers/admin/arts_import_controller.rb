class Admin::ArtsImportController < ApplicationController
  def create
    CSV.open(params[:csv_file].path, headers: true).each do |row|
      Art.create_from_csv(row)
    end
  end
end
