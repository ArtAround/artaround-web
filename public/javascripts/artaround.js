var sizes

function loadThumbnail(element_id, photo_id, options) {
  var flickr_size = options.flickr_size || "Small";
  var max_width = options.max_width || 75;
  var max_height = options.max_height || 75
  var resize = options.resize || false;
  var link_to_flickr = options.link_to_flickr || false;
  
  Flickr.getThumbnail(photo_id, flickr_size, function(thumbnail) {
    if (thumbnail) {
      
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
      
      html = "<img src=\"" + thumbnail.source + "\" ";
      if (resize)
        html += "style=\"width: " + rendered_width + "px; height: " + rendered_height + "px\" ";
      html += "/>";
      
      if (link_to_flickr)
        html = "<a href=\"" + Flickr.photoUrl(photo_id) + "\">" + html + "</a>";
      
      $("#" + element_id).html(html);
    }
  });
}