$('<%= escape_javascript(render(:partial => @manufacturer))%>')
  .appendTo('#manufacturers')
  .hide()
  .fadeIn()

$('#new_manufacturer')[0].reset()