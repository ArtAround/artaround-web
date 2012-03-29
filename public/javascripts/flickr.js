// homegrown Flickr API JS wrapper for fetching thumbnails
var Flickr = {
  api_key: null,
  username: null,
  
  photoUrl: function(photo_id) {
    return "http://www.flickr.com/photos/" + Flickr.username + "/" + photo_id + "/";
  }
  
}