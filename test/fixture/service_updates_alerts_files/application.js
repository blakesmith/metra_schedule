/*
--------------------------------------------------

Metra Rail.com
Javascript Application Code [application.js]

Joe Morrow [joe.morrow@acquitygroup.com]
6/26/2009

Copyright � 2009 Acquity Group LLC

--------------------------------------------------
*/


$(function() {

	// Browser & OS Detection
	if (isSafari()) {
		$("body").addClass("safari");
		Cufon.refresh();
	};
	
	if (isLteFF30()) {
		$("body").addClass("ff30");
		Cufon.refresh();
	}

	// Auto-clear inline prompt text, stored in "title" attribute
	$(".inline-prompt").each(function() {
		if ($(this).attr("title").length == 0)
			$(this).attr("title", $(this).val());
	}).focus(function() {
		if ($(this).val() == $(this).attr("title"))
			$(this).val("").removeClass("inline-prompt");
	}).blur(function() {
		if ($(this).val() == "")
			$(this).val($(this).attr("title")).addClass("inline-prompt");
	});

	// Toggle Additional Ticket fields
	$("#addAdditionalTicket").click(function() {
		var tElement = $("#addAdditionalTicketFields");
		var sElement = $("fieldset.submission", tElement.parent().parent());
		if (tElement.is(":visible")) {
			tElement.hide();
			sElement.show();
		} else {
			tElement.show();
			sElement.hide();
		}
	}).each(function() {
		// Preset initial state
		var tElement = $("#addAdditionalTicketFields");
		var sElement = $("fieldset.submission", tElement.parent().parent());
		if ($(this).is(":checked")) {
			tElement.show();
			sElement.hide();
		} else {
			tElement.hide();
			sElement.show();
		}
	});

	// Toggle Monthly Options fields
	$("input.ticketType").click(function() {
		var tElement = $(".gender", $(this).parents("dl.type")).add($(this).parents("fieldset.ticketParameters").next("fieldset.connectingServiceOptions"));
		if ($(this).is(".monthlyPass:checked")) {
			tElement.show();
		} else {
			tElement.hide();
		}
	}).each(function() {
		// Preset initial state
		var tElement = $(".gender", $(this).parents("dl.type")).add($(this).parents("fieldset.ticketParameters").next("fieldset.connectingServiceOptions"));
		if ($(this).is(".monthlyPass:checked")) {
			tElement.show();
		} else {
			tElement.hide();
		}
	});

	// Toggle Reduced Fare Options fields
	$("input.reducedFare").click(function() {
		var tElement = $("dd.reducedFare", $(this).parents("dl.type"));
		if ($(this).is(":checked")) {
			tElement.show();
			$(this).parents("dt.reducedFare").removeClass("reducedFareUnchecked");
		} else {
			tElement.hide();
			$(this).parents("dt.reducedFare").addClass("reducedFareUnchecked");
		}
	}).each(function() {
		// Preset initial state
		var tElement = $("dd.reducedFare", $(this).parents("dl.type"));
		if ($(this).is(":checked")) {
			tElement.show();
			$(this).parents("dt.reducedFare").removeClass("reducedFareUnchecked");
		} else {
			tElement.hide();
			$(this).parents("dt.reducedFare").addClass("reducedFareUnchecked");
		}
	});

	// Carousel Scroller
	if ($("div.carouselItem").size() > 0) {
		$("div.carouselItem.hidden").hide().removeClass("hidden");
		$("#carouselController a").click(function() {
			clearTimeout(promoTimeout);
			if (!$(this).parent().hasClass("selected"))
				promoSwitchTo($(this).attr("href"));
			return false;
		});
		$("#carouselBack a, #carouselNext a").click(function() {
			clearTimeout(promoTimeout);
			promoSwitchTo($(this).attr("href"));
			return false;
		});
		var promoTimeout = setInterval("promoSwitchTo($('#carouselNext a').attr('href'))", 8000);
	}

	// Print buttons
	$("#utilities a.print").click(function() {
		window.print();
		return false;
	});
	
	// Payment Sources switching
	$("#paymentSource dl").hide();
	$("#" + $("#paymentSourceSelect option:selected").val()).show();
	$("#paymentSourceSelect").change(function() {
		$("#paymentSource").find("dl").hide();
		$("#" + $("#paymentSourceSelect option:selected").val()).show();
	});
	
	// Billing & Shipping Method switching
	$("#billingAndShippingMethod dl").hide();
	$("#" + $("#billingAndShippingMethodSelect option:selected").val()).show();
	$("#billingAndShippingMethodSelect").change(function() {
		$("#billingAndShippingMethod").find("dl").hide();
		$("#" + $("#billingAndShippingMethodSelect option:selected").val()).show();
	});

	// Text Resize buttons
	var resizeFactor = 1.2;
	var resizeProperties = ["font-size", "line-height"];
	var resizeContext = "#content, #cartOverview, #civicCrisis";
	var resizeExcluded = ".continueLink, .continueLink *";
	var isResizePreset = false;

	$("#utilities a.increase").click(function() {
		resizeStyle(resizeFactor, resizeProperties, resizeContext, resizeExcluded, isResizePreset);
		isResizePreset = true;
		return false;
	});

	$("#utilities a.decrease").click(function() {
		resizeStyle(1 / resizeFactor, resizeProperties, resizeContext, resizeExcluded, isResizePreset);
		isResizePreset = true;
		return false;
	});
	
	// Switch destinations
	$("#schedule-reverse").click(function()	{
		var destA = $("#schedule-start").val();
		var destB = $("#schedule-end").val();
		$("#schedule-end").val(destA);
		$("#schedule-start").val(destB);

		if ($("#mapContent").size() > 0)
			$("#schedule-end, #schedule-start").change();

		return false;
	});

	// Initialize field clearing
	// Exclude My Metra Edit Info page
	$('input[type="text"],input[type="password"]:not(body.ma input)').clearDefaultValue();
	$('input[type="password"]:not(body.ma input)').each(function() {
		($(this).val() == '') ? $(this).addClass('passwordField') : null;
	});
	
	// Toggle My Metra Welcome Modals
	// Use the href of a .toggleModal link to toggle a modal with the same ID as the href
	$('.toggleModal').click(function() {
		$(this.href.slice((this.href.indexOf('#')),this.href.length)).toggleClass('displayModal');
		return false;
	});
	
	// Toggle Line Attractions
	// Use the href of a .toggleDescription link to toggle a <div> with the same ID as the href
	$('td.description')
		.find('div.showMore')
			.hide()
		.end()
		.find('a.toggleDescription')
			.click(function(element) {
				$(this.href.slice((this.href.indexOf('#')),this.href.length)).slideToggle('50');
				$(this).find('span.showText, span.hideText').toggle();
				return false;
			});

	// Attach clear form links
	$('a.clearForm').click(function() {
		clearForm($(this).parents('form:first'));
		return false;
	});
	
	// New windows
	// Add rel="popup" to make any link a pop-up window
	// Add rel="popup|w|h" to make any link a pop-up window with a specified width and height (ex. rel="popup|800|700" will result in a popup width=800 height=700)
	//  Default width and height is 600
    $('a[rel^="popup"]').click(function() {
		var attributes = $(this).attr('rel').split('|');
		var url = $(this).attr('href');
		var name = Math.floor(Math.random()*100);
		var width = (attributes[1]) ? attributes[1] : '600';
		var height = (attributes[2]) ? attributes[2] : '600';
        window.open(url,name,'width='+ width +',height='+ height +',scrollbars=1');
        return false;
    });
	
	// Nav rollover
	$('#topNav ul.nav li').hover(function(){
		$(this).hasClass('selected') ? $(this).addClass('current') : $(this).addClass('selected')
		if ($(this).hasClass('last')) Cufon.refresh()
	},function(){
		$(this).hasClass('current') ? $(this).removeClass('current') : $(this).removeClass('selected')
		if ($(this).hasClass('last')) Cufon.refresh()
	})

	// Datepicker
	if ($(".datepicker").size() > 0) {

		if ($("body.es").size() > 0) {
			// date localization for locale 'es'
			// generated by Jörn Zaefferer using Java's java.util.SimpleDateFormat
			Date.dayNames = ['domingo', 'lunes', 'martes', 'mi�rcoles', 'jueves', 'viernes', 's�bado'];
			Date.abbrDayNames = ['dom', 'lun', 'mar', 'mi�', 'jue', 'vie', 's�b'];
			Date.monthNames = ['enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'];
			Date.abbrMonthNames = ['ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic'];
		}

		Date.firstDayOfWeek = 0;
		Date.format = 'mm/dd/yyyy';
		
		$(".datepicker").closest("#contactUs-form").length > 0 ? $(".datepicker").datePicker({startDate:'01/01/1984'}) : $(".datepicker").datePicker(); 
	}
	
	// Column striping for full schedules
	function stripeColumns() {
		var i = 3;
		while($('.fullSchedule .data tr th:nth-child(' + i + ')').length > 0) {
			$('.fullSchedule .data tr th:nth-child(' + i + ')').addClass('col');
			i = i + 2;
		}
		var i = 3;
		while($('.fullSchedule .data tr td:nth-child(' + i + ')').length > 0) {
			$('.fullSchedule .data tr td:nth-child(' + i + ')').addClass('col');
			i = i + 2;
		}
	}
	stripeColumns();
	
	// Add fullWidth class to fullSchedule tables with more than 11 columns
	$('.fullSchedule .data').each(function() {
		($(this).find('thead tr:first-child th').length > 11) ? $(this).addClass('fullWidth') : null;
	});

});