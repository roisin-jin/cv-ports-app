
class PortCtrl

		constructor: (@$log, @$modal, @$location, @PortService) ->

				@$log.debug "constructing PortController"

				@countriesFrstChars = ["A", "B", "C", "D", "E",
									   "F", "G", "H", "I", "J", 
									   "K", "L", "M", "N", "O", 
									   "P", "Q", "R", "S", "T", 
									   "U", "V", "W", "Y", "Z"]

				@ports = []
				@availCountries = []
				@ISOCountries = []
				@getAllPortsAndISOCountries()

		loadCountries: (frstChar) ->
				@availCountries = (key for key, value of @ports when key.indexOf(frstChar) == 0).sort()

		getAllPortsAndISOCountries: () ->
				@$log.debug "getAllPorts()"

				@PortService.listAllPorts()
				.then(
						(data) =>
								@$log.debug "Promise returned #{data.length} Ports"
								@ports = data
								@loadCountries("A")
						,
						(error) =>
								@$log.error "Unable to get Ports: #{error}"
					)

				@PortService.loadISOCountries().then((data) => @ISOCountries = data)

		openUpdateModal: (port) ->
				@$log.debug "update port"
				port_value = {name: port.name,
				locode: {country: port.locode.country, port: port.locode.port}}

				port_value.polygon = {lat: port.polygon.lat, lon: port.polygon.lon} if port.polygon

				modalInstance = @$modal.open({
					templateUrl: '/assets/partials/update.html',
					controller: 'UpdatePortCtrl as upc',
					size: 'lg',
					resolve: {port_to_be_updated: () -> port_value}
					})

				modalInstance.result.then((updated_port) => @$location.path("/listPorts")
										   ,
										   () => @$log.info "Modal dismissed at: " + new Date())

		openDeleteModal: (port) ->
				@$log.debug "delete port"
				port_value = {name: port.name, locode: port.locode, polygon: port.polygon}
				modalInstance = @$modal.open({
									templateUrl: '/assets/partials/delete.html',
									controller: 'DeletePortCtrl as dpc',
									size: 'lg',
									resolve: {port_to_be_deleted: () -> port_value}
									})

				modalInstance.result.then((deleted) => @$location.path("/listPorts")
										   ,
										   () => $log.info "Modal dismissed at: " + new Date())


controllersModule.controller("PortCtrl", PortCtrl)