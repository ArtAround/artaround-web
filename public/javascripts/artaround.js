function loadThumbnail(element_id, photo_id) {
  Flickr.getThumbnail(photo_id, "Small", function(thumbnail) {
    if (thumbnail) {
      var max_width = 75;
      var max_height = 75;
      
      var rendered_height = thumbnail.height;
      var rendered_width = thumbnail.width;
      
      if (thumbnail.width > thumbnail.height) {
        if (thumbnail.width > max_width) {
          var ratio = max_width / thumbnail.width;
          rendered_width = max_width;
          rendered_height = Math.floor(thumbnail.height * ratio);
        }
      } else {
        if (thumbnail.height > max_height) {
          var ratio = max_height / thumbnail.height;
          rendered_height = max_height;
          rendered_width = Math.floor(thumbnail.width * ratio);
        }
      }
      
      $("#" + element_id).html(
        "<img src=\"" + thumbnail.source + "\" " + 
          //"style=\"width: " + rendered_width + "px; height: " + rendered_height + "px\" " +
          "/>"
      );
    }
  });
}