
class PortCtrl

    constructor: (@$log, @PortService) ->
        @$log.debug "constructing PortController"
        @ports = []

        @map = {
           center: {
              latitude: 51.219053,
              longitude: 4.404418
              },
           zoom: 15,
           bounds: {}
           }

        @options = {scrollwheel: false};
        @gmarkers = []
        @getAllPortsAndMarkers()

    getAllPortsAndMarkers: () ->
        @$log.debug "getAllPorts()"

        @PortService.listPorts()
        .then(
            (data) =>
                @$log.debug "Promise returned #{data.length} Ports"

                @ports = data

                for (var i = 0; i < data.length; i++):
                    var port = data[i]
                    var marker = {
                    latitude: port.polyon.lat,
                    longitude: port.polygon.lon,
                    title: port.locode + "(" + port.name + ")"
                    }

                    marker['id'] = i
                    @gmarkers.push marker
            ,
            (error) =>
                @$log.error "Unable to get Ports: #{error}"
            )

controllersModule.controller('PortCtrl', PortCtrl)