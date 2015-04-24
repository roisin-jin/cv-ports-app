
class PortCtrl

		constructor: (@$log, @$modal, @$location, @$rootScope, @PortService, @uiGmapGoogleMapApi) ->

				@$log.debug "constructing PortController"
				@countriesFrstChars = "ABCDEFGHIJKLMNOPQRSTUVWYZ".split("")
				@ports = []
				@availCountries = []
				@$rootScope.map = {}
				@$rootScope.mapSDK = []
				@geocoder = {}
				@getPortsInCountriesStartsWith("A")
				@loadISOCountriesIfNeeded()

		loadGoogleMap: () ->
			@$log.debug "loading google map"
			@uiGmapGoogleMapApi.then((maps) =>
											@$log.debug "Map loaded"
											maps.visualRefresh = true
											@$rootScope.map = {
											show: true,
											zoom: 10,
											center: {latitude: 53.3498053, longitude: -6.26031},
											options: {
												mapTypeControl: true,
												mapTypeControlOptions: {style: maps.MapTypeControlStyle.DROPDOWN_MENU},
												navigationControl: true,
												mapTypeId: maps.MapTypeId.ROADMAP,
												scrollwheel: false}
											}
											@$rootScope.mapSDK = maps
										,
										(error) => @$log.error "Unable to load google map: #{error}")

		resetMapCenter: (polygon) ->
			 @$rootScope.map.center = {latitude: polygon.lat, longitude: polygon.lon}
			 @$rootScope.map.zoom = 10

		resetMapCenterAndLoadGmarkers: (ctryCode) ->
			@$log.debug "Refresh map with new center and gmarkers"
			country = @$rootScope.ISOCountries[ctryCode]
			maps = @$rootScope.mapSDK
			@$rootScope.map.zoom = 5
			@gmarkers = (@createPortMarker port, index for port, index in @ports[ctryCode] when port.polygon?.lat)
			geocoder = new maps.Geocoder()
			geocoder.geocode({address: country}, (results, status) =>
											   newCenter = (value for key, value of results[0].geometry.location)
											   @$rootScope.map.center = {latitude: newCenter[0], longitude: newCenter[1]})

		resetMapToInitial: () ->
			@$rootScope.map.center = {latitude: 53.3498053, longitude: -6.26031}
			@$rootScope.map.zoom = 10

		createPortMarker: (port, index) -> 
			polygon = port.polygon
			lat = polygon.lat > 0 ? 'N' : 'S'
			lon = polygon.lon > 0 ? 'E' : 'W'
			content = port.locode.country + port.locode.port + " at " + String(polygon.lat) + lat + ", " + String(polygon.lon) + lon
			marker = {latitude:polygon.lat, longitude: polygon.lon, title:content, id:index, showWindow: false}
			f = (marker, eventName, args) -> marker.showWindow = !marker.showWindow
			marker.events = {mouseover: f, mouseout: f}
			return marker

		loadISOCountriesIfNeeded: () ->
				if @$rootScope.ISOCountries?
				   @$log.debug "ISO Countries already loaded"
				else
				   @PortService.loadISOCountries().then((data) => @$rootScope.ISOCountries = data)

		getPortsInCountriesStartsWith: (frstChar) ->
				@$log.debug "getPortsWithCountriesWith #{frstChar}"

				@PortService.listPortsStartsWith(frstChar)
				.then(
						(data) =>
								@$log.debug "Promise returned #{data.length} Ports"
								@ports = data
								@availCountries = (key for key, value of @ports).sort()
								@loadGoogleMap() if !@$rootScope.map.show
						,
						(error) =>
								@$log.error "Unable to get Ports: #{error}"
					)

		openUpdateModal: (port) ->
				@$log.debug "Opening update port modal"
				port_value = {name: port.name, locode: {country: port.locode.country, port: port.locode.port}}

				port_value.polygon = {lat: port.polygon.lat, lon: port.polygon.lon} if port.polygon
				port_value.limit = {width: port.limit.width, length: port.limit.length} if port.limit

				modalInstance = @$modal.open({
					templateUrl: '/assets/partials/updatePortModal.html',
					controller: 'UpdatePortCtrl as upc',
					size: 'lg',
					resolve: {port_to_be_updated: () -> port_value}
					})

				modalInstance.result.then((updated_port) => @getPortsInCountriesStartsWith(updated_port.locode.country.charAt(0))
										   ,
										   () => @$log.info "Modal dismissed at: " + new Date())

		openDeleteModal: (port) ->
				@$log.debug "Opening delete port modal"
				port_value = {name: port.name, locode: port.locode, polygon: port.polygon, limit: port.limit}

				modalInstance = @$modal.open({
									templateUrl: '/assets/partials/deletePortModal.html',
									controller: 'ConfirmPortCtrl as cpc',
									resolve: {port_to_be_processed: () -> port_value}
									})

				modalInstance.result.then((deleted) => @$location.path("/listPorts")
										   ,
										   () => @$log.info "Modal dismissed at: " + new Date())


controllersModule.controller("PortCtrl", PortCtrl)