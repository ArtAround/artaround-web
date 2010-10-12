var sizes

function loadThumbnail(element_id, photo_id, flickr_size, max_width, max_height, resize) {
  Flickr.getThumbnail(photo_id, flickr_size, function(thumbnail) {
    if (thumbnail) {
      var max_width = max_width;
      var max_height = max_height;
      
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
          (resize ? "style=\"width: " + rendered_width + "px; height: " + rendered_height + "px\" " : "") +
          "/>"
      );
    }
  });
}