
class CreatePortCtrl

    constructor: (@$log, @$location,  @PortService) ->
        @$log.debug "constructing CreatePortController"
        @port = {}

    createPort: () ->
        @$log.debug "createPort()"
        @PortService.createPort(@port)
        .then(
            (data) =>
                @$log.debug "Promise returned #{data} port"
                @port = data
                @$location.path("/listPorts")
            ,
            (error) =>
                @$log.error "Unable to create port: #{error}"
            )

controllersModule.controller('CreatePortCtrl', CreatePortCtrl)