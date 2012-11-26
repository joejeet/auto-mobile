// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery.tools.js
//= require_tree .
//= require jquery.chained.js
//= require jqModal.js
//= require bootstrap-dropdown.js
//= require bootstrap-tab.js
//= require bootstrap-modal.js
//= require bootstrap-collapse



$(function() {

$('#myModal').hide();
$('#smrModal').hide();

$(".collapse").collapse();

$(".smrdrilldown td").dblclick(function() {
    var temp = $(this).parent("tr").find("td:first").html();
    var months = $("#search_months").val();
    var miles = $("#search_miles").val();    
     $.ajax({
		url: "/smr_drilldowns/add_vehicle_to_popup/?code="+ temp +"&months=" + months +"&miles=" + miles,
		dataType: "script"
	  });	    
});

  $('.exit-click').click(function() {
    $('#exitModal').modal();

  });

 
 $('#job_cost tr').dblclick(function() {
        $('#jobModal').modal();
        
  });

$("td span.expand").click(function() {
    $(this).parents("tr.main").nextUntil("tr.main").toggle();
});

  	
	$('tbody  tr:odd').addClass('odd');


  $('tbody tr:even').addClass('even');
	
	$("#country_name").change(function(){
	var country = $(this).val();
	var manufacturer = $("#manufacturer_name").val();	
	$.ajax({
		url: "/service_plans/models_search/?manufacturer="+ manufacturer +"&country=" + country,
		dataType: "script"
	  });			
	});
	
	$("#make_model").change(function(){
	var model = $(this).val();
	var country = $("#country_name").val();	
	$.ajax({
		url: "/service_plans/vehicles_search/?model="+ model +"&country=" + country,
		dataType: "script"
	  });			
	});
	
	$(".submit_part").live("click", function(e){
		e.preventDefault();
		var part_number = $(this).prevAll(".part_number_field").val();
		var part_type = $(this).prevAll(".part_type").val();
		var description_id = $(this).prevAll(".part_description_id").val();
		var manufacturer_id = $(this).prevAll(".manufacturer_id").val();
		if (part_number != '')
        {
			url = "/service_plans/part_search/?type="+ part_type +"&num=" + part_number +"&description=" + description_id +"&manufacturer=" + manufacturer_id;
        	ajaxLookup (url, "get");
        }
	});
		
	$(".part_select").live("click", function(e){
		e.preventDefault();
			
		sp_show_hide_search("show");		
					
		$('#dialog').jqmHide();
	});	
	
	$(".submit_part_delete").live("click", function(e){
		e.preventDefault();
		var index = $(this).closest('tr').index() + 1;	
		sp_show_hide_search("hide", index);		
					
		$('#dialog').jqmHide();
	});	

	$("#part_part_type").live('change', function(e){	
		if((this.value)=="S")
		{
		   $("#ll_interval_miles").show();
		   $("#ll_interval_months").show();
		   $("#labour_time").hide();
		}
		else
		{
			$("#ll_interval_miles").hide();
	   		$("#ll_interval_months").hide();
	   		$("#labour_time").show();
	   	};
  	});
  	
  	$("ul.tabs").tabs("div.panes > div");
  	
  	$('select#vehicle_make_model_id').chained('select#vehicle_country_id');
	
	$('select#country_name').chained('select#manufacturer_name');
		
	$('#add_service').live('click', function(e) {
		e.preventDefault();
    	addTemplateSet($('#services_fields_template'), $('#services > tbody'));
    });
    $('#add_fixed_cost').live('click', function(e) {
		e.preventDefault();
    	addTemplateSet($('#fixed_costs_fields_template'), $('#fixed_costs > tbody'));
    });
    
    $(".delete_table_row").live("click", function(e){
        e.preventDefault();
        $(this).prev('input[name$="[_destroy]"]').val("1");
        $(this).parents('tr').hide();
    });
$('.dropdown-toggle').dropdown();
});

function show_smrdrilldown(el) {
var temp = $( 'td:first-child', $( el ).parents ( 'tr' ) ).html();
    alert("you clicked: " + temp);
	$('#myModal').modal('show');
}

function part_selected(){
	sp_show_hide_search("show");					
	$('#dialog').jqmHide();
}

function sp_show_hide_search(action, index){
	if(action == "show"){
		var index = $("#service_parts input:hidden[id^=description_id][value="+ part.part_description_id + "]").closest('tr').index() + 1;
		
		$("#service_parts tr:eq("+index+") td:eq(1)").html(part.interval_miles);
		$("#service_parts tr:eq("+index+") td:eq(3)").html(part.interval_months);	
		$("#service_parts tr:eq("+index+") td:eq(5)").html(part.ll_interval_miles);	
		$("#service_parts tr:eq("+index+") td:eq(7)").html(part.ll_interval_months);		
		$("#service_parts tr:eq("+index+") td:eq(10)").html(price);
		$("#service_parts tr:eq("+index+") td:eq(11) input").val(part.id);
		
		$("#service_parts tr:eq("+index+") td:eq(12) .search").hide();		
		$("#service_parts tr:eq("+index+") td:eq(12) a").text(select_part_number).attr('href','#').show();		
		$("#service_parts tr:eq("+index+") td:eq(13) .submit_part_delete").show();
	}
	else if(action == "hide"){
		$("#service_parts tr:eq("+index+") td:eq(0)").html("");	
		$("#service_parts tr:eq("+index+") td:eq(1)").html("");
		$("#service_parts tr:eq("+index+") td:eq(3)").html("");
		$("#service_parts tr:eq("+index+") td:eq(5)").html("");
		$("#service_parts tr:eq("+index+") td:eq(7)").html("");
		$("#service_parts tr:eq("+index+") td:eq(10)").html("");
		$("#service_parts tr:eq("+index+") td:eq(11) input").val("");
		
		$("#service_parts tr:eq("+index+") td:eq(12) .search").show();
		$("#service_parts tr:eq("+index+") td:eq(12) a").hide();		
		$("#service_parts tr:eq("+index+") td:eq(13) .submit_part_delete").hide();
	}
}

function ajaxLookup(url, method)
{
   $('body').css('cursor', 'wait');
   $.ajax({
		url: url,
        type: method,
        dataType: 'script',
        success: function()
        {
        	$('body').css('cursor', 'auto');
        }
   });
}

function addTemplateSet(template, where){
	var regexp = new RegExp("NEW_RECORD", "g")
    var temp = template.html();
    where.append(temp.replace(regexp, genid));
}

function genid(){
    return new Date().getTime();
}

function dialog_show(html){
	$('#dialog > #dialog_bdy').html(html);	
	$('#dialog').jqm({modal:true});
	$('#dialog').jqmShow();
}


function show_welcome_modal() {
  if (gon.display_login_popup){
    $('#welcomeModal').modal();
  }
}

jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})

jQuery.fn.submitWithAjax = function() {
  this.submit(function() {
    $.post(this.action, $(this).serialize(), null, "script");
    return false;
  })
  return this;
};







