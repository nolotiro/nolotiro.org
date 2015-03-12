// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.cookiebar
//= require moment-with-locales
// require turbolinks
//= require_tree .


$(document).ready(function(){

  // alert cookies (bottom) 
  // http://www.primebox.co.uk/projects/jquery-cookiebar/ 
  $.cookieBar({
    message: $('.js-cookie-message').html(),
    acceptText: 'OK'
  });
  if (! readCookie('alert-first-visit-close') )  { $('.js-alert-first-visit').show('slow'); } 

  // alert first visit
  $('.js-close-first-visit').on('click', function(e){
    e.preventDefault();
    $(this).parent().hide('slow');
    createCookie('alert-first-visit-close', true, 90); 
  })

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
    $(this).html(moment($(this).html(), "YYYY-MM-DD h:mm:ss").fromNow()); 
  });

}); 
