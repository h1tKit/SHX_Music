import QtQuick

Rectangle {
    id: body

    property bool mute: false
    property bool isHoverd: false
    property real volumeValue: 0.0
    property real inicialVolume: 0.4

    color: Qt.rgba(0.95,0.95,0.95,1)
    border.width: 1
    border.color: Qt.rgba(0.85,0.85,0.85,1)

    HoverHandler {
        onHoveredChanged: {
            if(hovered){
                body.isHoverd = true
            }else {
                if (slider.isHandleHovered) {
                    body.isHoverd = true
                }else {
                    body.isHoverd = false
                }
            }
        }
    }

    Rectangle {
        id: bottomPart
        visible: false
        rotation: 45
        width: parent.width/3.5
        height: width
        color: Qt.rgba(0.95,0.95,0.95,1)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.bottom

        border.width: 1
        border.color: Qt.rgba(0.85,0.85,0.85,1)
    }

    Rectangle {
        id: cut
        color: Qt.rgba(0.95,0.95,0.95,1)
        anchors.fill: parent
        radius: parent.radius
        anchors.margins: 1
    }

    Text {
        id: volumnText
        text: slider.value.toString()
        font.pixelSize: 12
        color: Qt.rgba(0.5,0.5,0.5,1)
        anchors.top: body.top
        anchors.topMargin: 3
        anchors.horizontalCenter: body.horizontalCenter
    }

    HSlider {
        id: slider
        doneColor: mute ? Qt.rgba(0.45,0.45,0.45,1) : Qt.rgba(0.106, 0.553, 0.788,1)
        undoneColor: Qt.rgba(0.7,0.7,0.7,1)
        handleColor: "white"
        handleCentralColor: mute ? Qt.rgba(0.45,0.45,0.45,1) : Qt.rgba(0.106, 0.553, 0.788,1)
        handle.border.width: 1
        handle.border.color: Qt.rgba(0,0,0,0.15)
        anchors.top: volumnText.bottom
        anchors.bottom: body.bottom
        anchors.horizontalCenter: body.horizontalCenter
        anchors.margins: 3
        width: 5

        from: 0
        to: 100
        value: inicialVolume * (to - from) + from

        transform: [
        Scale {
                origin.x: slider.width/2
                origin.y: slider.height/2
                yScale: -1
            }
        ]
    }
    Connections {
        target: slider
        function onDraged(setValue) {
            mute = false
            body.volumeValue = setValue / (slider.to - slider.from)
            volumnText.text = setValue.toString()
        }
    }
}
