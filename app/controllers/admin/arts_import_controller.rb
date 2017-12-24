class Admin::ArtsImportController < ApplicationController
  def show
    @import = ArtImport.find params[:id]
    respond_to do |format|
      format.html { render 'show' }
      format.csv { send_data @import.to_csv }
    end
  end

  def create
    import = ArtImport.from_csv(params[:csv_file])

    redirect_to admin_art_import_path(import)
  end
end
