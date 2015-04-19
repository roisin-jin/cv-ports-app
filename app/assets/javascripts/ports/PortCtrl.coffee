
class PortCtrl

		constructor: (@$log, @PortService) ->

				@$log.debug "constructing PortController"

				@countriesFrstChars = ["A", "B", "C", "D", "E",
									   "F", "G", "H", "I", "J", 
									   "K", "L", "M", "N", "O", 
									   "P", "Q", "R", "S", "T", 
									   "U", "V", "W", "Y", "Z"]

				@ports = []
				@map = {}
				@options = {}
				@gmarkers = []
				@getAllPortsAndMarkers("A")

		getAllPortsAndMarkers: (frstChar) ->
				@$log.debug "getAllPorts()"

				@PortService.listPortsStartsWith(frstChar)
				.then(
						(data) =>
								@$log.debug "Promise returned #{data.length} Ports"
								@ports = data
						,
						(error) =>
								@$log.error "Unable to get Ports: #{error}"
					)

controllersModule.controller("PortCtrl", PortCtrl)