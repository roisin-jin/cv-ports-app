
class CreatePortCtrl

    constructor: (@$log, @$location,  @PortService) ->
        @$log.debug "constructing CreatePortController"
        @port = {}

    CreatePort: () ->
        @$log.debug "CreatePort()"
        @portService.CreatePort(@port)
        .then(
            (data) =>
                @$log.debug "Promise returned #{data} port"
                @port = data
                @$location.path("/")
            ,
            (error) =>
                @$log.error "Unable to create port: #{error}"
            )

controllersModule.controller('CreatePortCtrl', CreatePortCtrl)