
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

    getPortMark: (port, index) ->
        {
            latitude: port.polygon.lat,
            longitude: port.polygon.lon,
            title: port.locode + '(' + port.name + ')',
            id: index
        }

    getAllPortsAndMarkers: () ->
        @$log.debug "getAllPorts()"

        @PortService.listPorts()
        .then(
            (data) =>
                @$log.debug "Promise returned #{data.length} Ports"
                @ports = data
                @gmarkers = (@getPortMark port, i for port, i in data)
            ,
            (error) =>
                @$log.error "Unable to get Ports: #{error}"
            )

controllersModule.controller('PortCtrl', PortCtrl)