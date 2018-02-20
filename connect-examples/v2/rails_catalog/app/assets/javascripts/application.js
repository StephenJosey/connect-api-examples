// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require turbolinks
//= require_tree .
//= require_self


function display_products() {
  var current_selection = document.getElementById('products');
  if (current_selection.options[current_selection.selectedIndex].text === 'New...') {
    if (document.getElementById('new_product').style.visibility === 'hidden' ||
      document.getElementById('new_product').style.visibility === '')
      document.getElementById('new_product').style.visibility = 'visible';
  } else {
    document.getElementById('new_product').style.visibility = 'hidden';
  }
}
function display_category() {
  var current_selection = document.getElementById('category');
  if (current_selection.options[current_selection.selectedIndex].text === 'New...') {
    if (document.getElementById('new_category').style.visibility === 'hidden' ||
        document.getElementById('new_category').style.visibility === '')
      document.getElementById('new_category').style.visibility = 'visible';
  } else {
    document.getElementById('new_category').style.visibility = 'hidden';
  }
}
