//= require jquery
//= require jquery_ujs
//= require jquery.cookiebar
//= require moment-with-locales
// require turbolinks
//= require_tree .
//

function rememeberClosedAlerts() {
  //<div class="info js-alert-cookie hide" data-cookie-name="alert-first-visit">
  //  <%= t('nlt.first_visit') %>
  //  <a href="#" class="js-alert-close alert-close">x</a> 
  //</div>                                                                                        
  $('.js-alert-cookie').each( function(){
    var $el = $(this);
    var cookie = $(this).attr('data-cookie-name');
    if (! readCookie(cookie) ) { $el.show('slow'); } 
  });

  $('.js-alert-close').on('click', function(e){
    e.preventDefault();
    var $alert = $(this).parent('.js-alert-cookie');
    var cookie = $alert.attr('data-cookie-name'); 
    $alert.hide('slow');
    createCookie(cookie, true, 90); 
  });

}

$(document).ready(function(){

  // alert cookies (bottom) 
  // http://www.primebox.co.uk/projects/jquery-cookiebar/ 
  $.cookieBar({
    message: $('.js-cookie-message').html(),
    acceptText: 'OK'
  });
  if (! readCookie('alert-first-visit-close') )  { $('.js-alert-first-visit').show('slow'); } 

  rememeberClosedAlerts(); 

  // alert welcome message
  if ( $('p.notice').length > 0 ) {
   if ( $('p.notice').html().trim() == "Bienvenido" ) {
     $('p.notice').hide(); 
     $('#main').prepend('<p class="success">' + $('.js-welcome-message').html() + " " + $('#js-username').html() + '</p>')
   }
  }

  // converting dates to "a month ago"
  var lang = $('.lang.active').data('langcode');
  moment.locale(lang);
  $('.js-moment').each( function(){
    var date = moment.utc($(this).html(), "YYYY-MM-DD h:mm:ss");
    $(this).html(date.fromNow()); 
  });

}); 
