/*
--------------------------------------------------

Metra Rail.com
Combined Javascript Library [library.js]

Joe Morrow [joe.morrow@acquitygroup.com]
6/26/2009

Copyright © 2009 Acquity Group LLC

--------------------------------------------------
*/


// browser detectors ($.browser is deprecated in jQuery 1.3 and $.support isn't helpful when targeting style rules)
function isIE6() {
	if (typeof($.isIE6) == "undefined") {
		jQuery.extend({
			isIE6: ((window.XMLHttpRequest == undefined) && (ActiveXObject != undefined)) ? true : false
		});
	}
	return $.isIE6;
}

function isIE() {
	if (typeof($.isIE) == "undefined") {
		jQuery.extend({
			isIE: (document.all) ? true : false
		});
	}
	return $.isIE;
}

function isSafari() {
	if (typeof($.isSafari) == "undefined") {
		jQuery.extend({
			isSafari: (/Safari/.test(navigator.userAgent)) ? true : false
		});
	}

	return $.isSafari;
}

function isSafari2() {
	if (typeof($.isSafari2) == "undefined") {
		jQuery.extend({
			isSafari2: ((/412|416|419/.test(navigator.appVersion)) && (/Safari/.test(navigator.userAgent))) ? true : false
		});
	}
	return $.isSafari2;
}

function isOpera8() {
	if (typeof($.isOpera8) == "undefined") {
		var ua = navigator.userAgent.toLowerCase();
		jQuery.extend({
			isOpera8: (ua.indexOf("opera 8") != -1 || ua.indexOf("opera/8") != -1) ? true : false
		});
	}
	return $.isOpera8;
}

function isLteFF30() {
	if (typeof($.isLteFF30) == "undefined") {
		if (/Firefox[\/\s](\d+\.\d+)/.test(navigator.userAgent)) {
			var v = new Number(RegExp.$1);
			jQuery.extend({
				isLteFF30: (v <= 3.0) ? true : false
			});
		} else {
			jQuery.extend({
				isLteFF30: false
			});
		}
	}
	return $.isLteFF30;
}

// Carousel Switcher Function
function promoSwitchTo(selected) {
	selected = selected.replace("#", "");
	var number = selected.charAt(selected.length - 1);
	if ((typeof(number * 1) == "number") && (!$("#" + selected).hasClass("selected"))) {
		$("#carouselContainer div.selected").fadeOut("medium", function() {
			$(this).removeClass("selected");
			$("#carouselController li.selected").removeClass("selected").children("a").children("img").attr("src", "/apps/metra/docroot/images/imagecarousel/dot.gif");
			var selectedScroller = $("#controller-" + number).addClass("selected");
			selectedScroller.children("a").children("img").attr("src", "/apps/metra/docroot/images/imagecarousel/dot-on.gif");
			$("#carouselItem-" + number).fadeIn("medium", function() {
				$(this).addClass("selected");
				$("#carouselBack a").attr("href", $("a", (selectedScroller.prev().size() > 0) ? selectedScroller.prev() : $("li:last-child", selectedScroller.parent())).attr("href"));
				$("#carouselNext a").attr("href", $("a", (selectedScroller.next().size() > 0) ? selectedScroller.next() : $("li:first-child", selectedScroller.parent())).attr("href"));
			});
		});
	}
}

// Convert CSS property names into Javascript property names
function getJavascriptStyleName(name) {
	var nameArray = name.split("-");
	var nameJS = nameArray[0];
	if (nameArray.length > 1) {
		for (var i=1; i<nameArray.length; i++) {
			nameJS += nameArray[i].charAt(0).toUpperCase() + nameArray[i].slice(1).toLowerCase();
		}
	}
	return nameJS;
}

// Get the style property units
function getStyleUnits(value) {
	var match = /[%ceimnptx]+/.exec(value);
	return (match != null) ? match : "";
}

// Text Resize Function
function resizeStyle(multiplier, properties, context, excluded, isPreset) {

	// Cache the style name lookup table for performance
	var styleNameLookup = Array();

	// Some values look better when multiplied by a fractional amount
	var multiplierFractional = ((multiplier > 1) ? 1 + ((multiplier - 1) / 10) : 1 / (1 + ((1/multiplier - 1) / 10)));

	// Preset the style values, if necessary, to limit the multiplication's scope
	if (!isPreset) {

		var elementsAll = $(":visible:not([class*=hidden], :input)", context).filter(function() {
			return ($(this).text().length > 0);
		});

		if (!isIE()) {
			elementsAll.each(function() {
				for (var i=0; i<properties.length; i++)
					$(this).css(properties[i], $(this).css(properties[i]));
			});
		} else {
			elementsAll.each(function() {
				for (var i=0; i<properties.length; i++) {
					if (styleNameLookup[properties[i]] == null)
						styleNameLookup[properties[i]] = getJavascriptStyleName(properties[i]);

					// jQuery has a known defect that incorrectly returns an extremely large font-size value for some elements, so skip these elements
					var styleUnits = getStyleUnits($(this)[0].currentStyle[styleNameLookup[properties[i]]]);	
					if ((styleUnits == "px") || (styleUnits == ""))
						$(this).css(properties[i], $(this)[0].currentStyle[styleNameLookup[properties[i]]]);
				}
			});
		}

		// Then grab only the relevant elements and cache the collection here for performance
		if (typeof($.resizeElements) == "undefined") {
			jQuery.extend({
				resizeElements: elementsAll.not(excluded)
			});
		}
	}

	// Iterate through each element
	$.resizeElements.each(function() {
		
		// Iterate through each style property
		for (var i=0; i<properties.length; i++) {
			if (styleNameLookup[properties[i]] == null)
				styleNameLookup[properties[i]] = getJavascriptStyleName(properties[i]);

			// jQuery has a known defect that incorrectly calculates some values in IE, so we're multiplying a different type of value in that case
			var value = (!isIE()) ? $(this).css(properties[i]) : $(this)[0].currentStyle[styleNameLookup[properties[i]]];
			var numeral = parseFloat(value);
			var units = getStyleUnits(value);
			
			if (numeral != null) {
				if (isIE()) {

					if ((units == "%") || (units == "")) 
						// For some units, we don't want as big a multiplier
						var multiplied = numeral * multiplierFractional;
					else
						// IE doesn't handle fractional pixels well, so we're rounding up to whole integers
						var multiplied = Math.ceil((numeral * multiplier) * 2) / 2;

				} else
					var multiplied = numeral * multiplier;

				// Set the new value, retaining the original units
				$(this).css(properties[i], multiplied + units);
			}
		}
	});

	// Reload Cufon, to set the new size
	Cufon.refresh();
}

// jQuery extention to clear default input values onfocus
// For password fields, it adds/removes a password field class that fakes the Password defaultValue
$.fn.clearDefaultValue = function() {
	return this.focus(function() {
		if(this.value == this.defaultValue)
			this.value = '';
		if(this.type == 'password' && this.value == '')
			$(this).removeClass('passwordField');
	}).blur(function() {
		if(!this.value.length)
			this.value = this.defaultValue;
		if(this.type == 'password' && this.value == '')
			$(this).addClass('passwordField');
	});
};

function clearForm(form) {
	$(':input', form).each(function() {
		var type = this.type;
		var tag = this.tagName.toLowerCase();
		if (type == 'text' || type == 'password' || tag == 'textarea')
			this.value = "";
		else if (type == 'checkbox' || type == 'radio')
			this.checked = false;
		else if (tag == 'select')
			this.selectedIndex = 0;
	});
};