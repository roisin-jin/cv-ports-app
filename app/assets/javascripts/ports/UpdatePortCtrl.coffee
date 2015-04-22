
class UpdatePortCtrl

	constructor: (@$log, @$modalInstance, @PortService, port_to_be_updated) ->
			@$log.debug "constructing UpdatePortController"
			@original_port = port_to_be_updated
			@updated_port = port_to_be_updated

	updatePort: () ->
			if @original_port != @updated_port
				 @PortService.updatePort(@original_port, @updated_port)
							 .then((data) =>
								  @$log.debug "Promise returned #{data} Port"
								  @$modalInstance.close(@updated_port)
							  ,
							  (error) =>
								  @$log.error "Unable to update Port: #{error}"
							  )
			else @cancel()

	cancel: () ->
		   @$log.debug "No update needed"
		   @$modalInstance.dismiss('cancel')

controllersModule.controller('UpdatePortCtrl', UpdatePortCtrl)