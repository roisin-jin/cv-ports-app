
class PortCtrl

		constructor: (@$log, @$modal, @$location, @$rootScope, @PortService) ->

				@$log.debug "constructing PortController"
				@countriesFrstChars = "ABCDEFGHIJKLMNOPQRSTUVWYZ".split("")
				@ports = []
				@availCountries = []
				@getPortsInCountriesStartsWith("A")
				@loadISOCountriesIfNeeded()


		loadISOCountriesIfNeeded: () ->
		        if @$rootScope.ISOCountries
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

				modalInstance.result.then((updated_port) => @$location.path("/listPorts")
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