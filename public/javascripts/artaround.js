function loadThumbnail(element_id, photo_id) {
  Flickr.getThumbnail(photo_id, "Small", function(thumbnail) {
    if (thumbnail) {
      // TODO: figure out right size to avoid squashing
      
      $("#" + element_id).html("<img src=\"" + thumbnail.source + "\"/>");
    }
  });
}