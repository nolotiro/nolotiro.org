//= require jquery
//= require jquery_ujs
//= require jquery.cookiebar
//= require moment-with-locales

$(document).ready(function(){

  // alert cookies (bottom) 
  // http://www.primebox.co.uk/projects/jquery-cookiebar/ 
  $.cookieBar({
    message: $('.js-cookie-message').html(),
    acceptText: 'OK'
  });

  // converting dates to "a month ago"
  var lang = $('.lang.active').data('langcode');
  moment.locale(lang);
  $('.js-moment').each( function(){
    var date = moment.utc($(this).html(), "YYYY-MM-DD h:mm:ss");
    $(this).html(date.fromNow()); 
  });

}); 
