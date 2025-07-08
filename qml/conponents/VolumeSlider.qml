import QtQuick
import QtQuick.Controls

Dialog {
    id: root

    property bool mute: false
    property bool isHoverd: false
    property real volumeValue: 0.0
    property real inicialVolume: 0.4

    property bool stillVisible: false

    property alias radius: body.radius

    background: Rectangle {
        id: body

        anchors.fill: parent

        color: Qt.rgba(0.95,0.95,0.95,1)
        border.width: 1
        border.color: Qt.rgba(0.85,0.85,0.85,1)

        HoverHandler {
            onHoveredChanged: {
                if(hovered){
                    isHoverd = true
                }else {
                    if (slider.isHandleHovered) {
                        isHoverd = true
                    }else {
                        isHoverd = false
                    }
                }
            }
        }

        Text {
            id: emptyText
            visible: false
            text: "100"
            font.pixelSize: 12
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: body.right
            anchors.rightMargin: 8
        }

        Text {
            id: volumnText
            text: slider.value.toString()
            font.pixelSize: 12
            color: Qt.rgba(0.5,0.5,0.5,1)
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: body.right
            anchors.rightMargin: 8
        }

        HSlider {
            id: slider
            doneColor: mute ? Qt.rgba(0.45,0.45,0.45,1) : Qt.rgba(0.106, 0.553, 0.788,1)
            undoneColor: Qt.rgba(0.7,0.7,0.7,1)
            handleColor: "white"
            handleCentralColor: mute ? Qt.rgba(0.45,0.45,0.45,1) : Qt.rgba(0.106, 0.553, 0.788,1)
            handle.border.width: 1
            handle.border.color: Qt.rgba(0,0,0,0.15)
            anchors.right: emptyText.left
            anchors.rightMargin: 3
            anchors.left: body.left
            anchors.leftMargin: 8
            anchors.verticalCenter: body.verticalCenter

            height: 5

            from: 0
            to: 100
            value: inicialVolume * (to - from) + from

            //onDraging: console.log("DRAGING...")
        }
        Connections {
            target: slider
            function onDraged(setValue) {
                mute = false
                volumeValue = setValue / (slider.to - slider.from)
                volumnText.text = setValue.toString()
            }
        }
    }

    onClosed: {
        if(stillVisible){
            root.open()
        }
    }
}



