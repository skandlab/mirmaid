// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery.noConflict()

jQuery(document).ready(function(){
    // BUTTONS
    jQuery('#flyout').menu({
        content: jQuery('#flyout').next().html(),
        flyOut: true
    });
});         