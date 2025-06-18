import QtQuick

Item {
    id: root

    //background
    Rectangle {
        id: body
        anchors.fill: parent
        color: Qt.rgba(0.95,0.95,0.95,1)

        border.width: 1
        border.color: Qt.rgba(0.85,0.85,0.85,1)
    }

    Rectangle {
        id: bottomPart
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
        anchors.margins: 1
    }

    Text {
        id: volumnText
        text: slider.value.toString()
        font.pixelSize: 12
        color: Qt.rgba(0.5,0.5,0.5,1)
        anchors.top: root.top
        anchors.topMargin: 3
        anchors.horizontalCenter: root.horizontalCenter
    }

    HSlider {
        id: slider
        doneColor: Qt.rgba(0.106, 0.553, 0.788,1)
        undoneColor: Qt.rgba(0.7,0.7,0.7,1)
        handleColor: "white"
        handleCentralColor: Qt.rgba(0.106, 0.553, 0.788,1)
        handle.border.width: 1
        handle.border.color: Qt.rgba(0,0,0,0.15)
        anchors.top: volumnText.bottom
        anchors.bottom: root.bottom
        anchors.horizontalCenter: root.horizontalCenter
        anchors.margins: 3
        width: 5

        from: 0
        to: 100

        transform: [
        Scale {
                origin.x: slider.width/2
                origin.y: slider.height/2
                yScale: -1
            }
        ]
        // onDraged: {
        //     console.log(setValue)
        // }
    }
}
