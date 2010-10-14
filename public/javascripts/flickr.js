// homegrown Flickr API JS wrapper for fetching thumbnails
var Flickr = {
  api_key: null,
  username: null,
  
  url: function(method, params) {
    return "http://api.flickr.com/services/rest/?method=" + method + "&format=json" +
        "&api_key=" + Flickr.api_key + ($.isEmptyObject(params) ? '' : '&' + $.param(params)) + "&jsoncallback=?";
  },
  
  photoUrl: function(photo_id) {
    return "http://www.flickr.com/photos/" + Flickr.username + "/" + photo_id + "/";
  },
  
  get: function(method, params, callback) {
    $.getJSON(Flickr.url(method, params), function(data) {
      if (data.stat == "fail")
        callback(null);
      else
        callback(data);
    });
  },
  
  getThumbnail: function(photo_id, size, callback) {
    Flickr.get("flickr.photos.getSizes", {photo_id: photo_id}, function(data) {
      if (data == null)
        callback(null);
      else {
        var thumbs = data.sizes.size;
        var found = false;
        for (var i=0; i<thumbs.length; i++) {
          if (thumbs[i].label == size) {
            callback(thumbs[i]);
            found = true;
          }
        }
        if (!found)
          callback(null);
      }
    });
  }
  
}