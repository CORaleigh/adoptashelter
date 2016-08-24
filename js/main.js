var config = {
	shelters: {
		url: 'api/v1/ws_geo_attributequery.php',
		table: 'adopt.shelter_adopters'
	},
	adopt: {
		url: 'api/v1/ws_bus_shelter_adopt.php'
	},
	search: {
		url: 'https://maps.raleighnc.gov/arcgis/rest/services/Addresses/MapServer/0/query',
		field: 'ADDRESS'
	}
};
var map, greenMarker, redMarker, markers, shelterName;
//map functions//
function SetMarkerSymbols () {
	greenMarker = L.icon({
		iconUrl: 'img/marker-icon-green.png',
		iconSize: [25,41]
	});
	redMarker = L.icon({
		iconUrl: 'img/marker-icon-red.png',
		iconSize: [25,41]
	});
}
function CreateMap () {
	map = L.map('map').setView([35.7769, -78.6436],12);
        L.tileLayer('https://services.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Light_Gray_Base/MapServer/tile/{z}/{y}/{x}',{minZoom: 10, maxZoom: 16, attribution: 'Esri, DeLorme, NAVTEQ'}).addTo(map);
	L.tileLayer('https://services.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Light_Gray_Reference/MapServer/tile/{z}/{y}/{x}',{maxZoom: 16, attribution: 'Esri, DeLorme, NAVTEQ'}).addTo(map);
	
	markers = L.layerGroup().addTo(map);
	map.locate({setView: true, maxZoom: 16});
}
//display shelters on map//

function FormatDate(input) {
    var dt = new Date(input);
    dt.setTime(dt.getTime() + dt.getTimezoneOffset() * 60 * 1000);
    return dt.toLocaleDateString();
}

function GetShelters () {
	$.ajax({
		url: config.shelters.url,
		data: {
			table: config.shelters.table,
			fields: '*'
		},
		success: function (data) {
			$.each(data, function (i, shelter) {
				var geom = $.parseJSON(shelter.geometry),
					icon = greenMarker;
				if (shelter.start) {
					icon = redMarker;
				}
				var marker = L.marker([geom.coordinates[1], geom.coordinates[0]], {icon: icon});
				markers.addLayer(marker);
				if (!shelter.start) {
					marker.bindPopup('<div class="text-center"><h5>' + shelter.name + "</h5><button data-id='" + shelter.id + "' data-name='" + shelter.name + "'  data-toggle='modal' data-target='#adopt-modal' class='btn btn-success'>Adopt Me</button></div>");
				} else {
                    marker.bindPopup('<h5>' + shelter.name + '</h5>Shelter has been adopted by <strong>' + shelter.organization +'</strong> through <strong>' + FormatDate(shelter.expires) + '</strong>.');
				}
				marker.on('popupopen', function () {

					var id = $("button", this.getPopup().getContent()).data('id'),
						name = $("button", this.getPopup().getContent()).data('name');
					shelterName = name;
					$('#inputId').val(id);
					$("#adopt-modal .modal-title").text("Adopt " +  name);
				});
			});
		}
	});
}
//form validation functions//
function placeErrors (error, element) {
	$(element).parent().addClass('has-error');
	$('.help-block', $(element).parent()).show().text($(error[0]).text());
}
function removeErrors (label, element) {
	$(element).parent().removeClass('has-error');
	$('.help-block', $(element).parent()).hide().text('');

}

function SetFeedbackForm () {
	$("#feedback-modal form").validate({
		rules: {
			'feedbackEmail': {
				required: true,
				email: true
			},
			'comments': {
				required: true
			}
		},
		submitHandler: function () {
			$.ajax({
				url: '/php/email.php',
				type: 'POST',
				dataType: 'json',
				data: {
					email: $("#feedbackEmail").val(),
					message: $("#inputComments").val()},
			})
			.done(function() {
				console.log("success");
			});
		},
		errorPlacement: placeErrors,
		success: removeErrors
	});
}

function SetFormValidation () {
	$.validator.addMethod("phoneUS", function(phone_number, element) {
	    phone_number = phone_number.replace(/\s+/g, "");
	    return this.optional(element) || phone_number.length > 9 &&
	        phone_number.match(/^(1-?)?(\([2-9]\d{2}\)|[2-9]\d{2})-?[2-9]\d{2}-?\d{4}$/);
	}, "Please specify a valid phone number");
	$('#form-adopt').validate({
		rules: {
			'email': {
				required: true,
				email: true,
				maxlength: 50
			},
			'contact': {
				required: true,
				maxlength: 50
			},
			'organization': {
				required: true,
				maxlength: 100
			},
			'phone': {
				required: true,
				maxlength: 14,
				phoneUS: true
			}
		},
		submitHandler: function () {
			$('#adopt-alert').hide();
			$('#adopt-modal').bu
			$.ajax({
				url: config.adopt.url,
				dataType: 'json',
				data: {
					email: $('#inputEmail').val(),
					id: $('#inputId').val(),
					contact: $('#inputName').val(),
					organization: $('#inputOrg').val(),
					phone: $('#inputPhone').val(),
					shelter: shelterName
				},
				success: function (data) {
					if (data.success) {
						FormMarkAllValid();
						$('#adopt-modal').modal('hide');
						markers.clearLayers();
						GetShelters();
					} else if (data.error){
						$('#alert-message').text(data.error.msg);
						$('#adopt-alert').show();
						if (data.error.code == 99) {
							markers.clearLayers();
							GetShelters();
						}
					}
				}
			});
		},
		errorPlacement: placeErrors,
		success: removeErrors
	});
}
function FormMarkAllValid (){
	$('input', 'form').removeClass('has-error');
}
//search functions//
function SearchByAddress (value, dataset) {
	$.ajax({
		url: config.search.url,
		format: 'jsonp',
		data: {
			f: 'json',
			returnGeometry: true,
			where: config.search.field + " = '" + value + "'",
			outSR: 4326
		}
	}).done(function (data) {
		var data = $.parseJSON(data);
		if (data.features.length > 0) {
			var point = L.latLng(data.features[0].geometry.y, data.features[0].geometry.x);
			map.setView(point, 16);
		}
	});
}
function SetSearch () {
	$('.typeahead').typeahead({
		name: 'addresses',
		remote: {
			url: config.search.url + '?f=json&where=UPPER(' + config.search.field + ") LIKE UPPER('%QUERY%25')&outFields=" + config.search.field + "&returnGeometry=false",
			filter: function (resp) {
				var values = [];
				$(resp.features).each(function (i, feature) {
					values.push(feature.attributes[config.search.field]);
				});
				return values;
			}
		}
	}).on('typeahead:selected', function(obj, datum, dataset) {
		SearchByAddress(datum.value, dataset);
	});
}
$(document).ready(function () {
	if(typeof(Storage)!=='undefined') {
		if (window.localStorage.hideSplash === 'false' || !window.localStorage.hideSplash) {
			$('#splash-modal').modal('show');
		}
		$('#splash-modal button').click(function () {
			window.localStorage.setItem('hideSplash',($('#splash-modal input[type="checkbox"]').is(':checked')))
		});
	}
	SetMarkerSymbols();
	CreateMap();
	GetShelters();
	SetFeedbackForm();
	SetFormValidation();
	SetSearch();
    $('#termsCheck').change(function() {
        if($(this).is(':checked')) {
            $('#submitButton').removeClass('disabled');
        } else {
            $('#submitButton').addClass('disabled');
        }
    });
});
