
class CreatePortCtrl

	constructor: (@$log, @$location, @$modal, @$rootScope, @PortService) ->
		@$log.debug "constructing CreatePortController"
		@port = {}
		@countryOptions = (@createCountryOption key, value for key, value of @$rootScope.ISOCountries)
		@countryOptions.sort((a,b) -> a.value.localeCompare(b.value))
		@msg

	createCountryOption: (code, name) -> {label: code + ' - ' + name, value: code}
	assignCountryValue: (value) ->
		@port.locode = {country: value, port: @getEle('locode_pt').val()}
		return

	resetAll: () ->
				@port = {}
				@getEle('locode_ct').val('')
				@getEle('locode_pt').val('')
				return

	getEle: (elementId) -> angular.element(document.querySelector('#' + elementId))

	validatePort: () ->
		@msg = "Not valid Country code" if @port.locode.country not in (code.value for code in @countryOptions)
		valid = (@msg == '')

	
	openConfirmModal: () ->
			if validatePort
				@$log.debug "Opening confirm new port modal"
				pname = @port.name.charAt(0).toUpperCase() + @port.name.slice(1)
				plocode = {country: @port.locode.country.toUpperCase(), port: @port.locode.port.toUpperCase()}
				port_value = {name: pname, locode: plocode, polygon: @port.polygon, limit: @port.limit}

				modalInstance = @$modal.open({
											templateUrl: '/assets/partials/confirmPortModal.html',
											controller: 'ConfirmPortCtrl as cpc',
											resolve: {port_to_be_processed: () -> port_value}
											})

				modalInstance.result.then((data) => @$location.path("/listPorts")
										  ,
										  () => @$log.info "Modal dismissed at: " + new Date())



controllersModule.controller('CreatePortCtrl', CreatePortCtrl)