
class PortCtrl

		constructor: (@$log, @PortService) ->

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

controllersModule.controller("PortCtrl", PortCtrl)