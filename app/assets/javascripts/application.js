//= require jquery
//= require jquery_ujs
//= require jquery.cookiebar

$(document).ready(function(){

  // alert cookies (bottom) 
  // http://www.primebox.co.uk/projects/jquery-cookiebar/ 
  $.cookieBar({
    message: $('.js-cookie-message').html(),
    acceptText: 'OK'
  });
}); 
