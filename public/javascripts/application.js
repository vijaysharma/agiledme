// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$("#backlog_close").click(function () {
    $("#backlog").hide();
});
$("#current_close").click(function () {
    $("#current").hide();
});
$("#done_close").click(function () {
    $("#done").hide();
});
$("#icebox_close").click(function () {
    $("#icebox").hide();
});