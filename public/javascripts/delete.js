$(function() {
  $('*[data-method=delete]').on('click', function(e) {
    e.preventDefault();
    e.stopPropagation();
    var containerElement = $(e.target).parent().parent();
    var url = e.target.href;
    $.ajax({
      method: 'DELETE',
      type: 'DELETE',
      url: url
    }).done(function(msg){
      $(containerElement).remove();
    });
  });
});
