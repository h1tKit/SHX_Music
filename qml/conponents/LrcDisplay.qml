import QtQuick

Item {

    ListModel {
        id: lrcModel
        ListElement {
            time: 0
            str: "Valder Fields"
        }
        ListElement {
            time: 1
            str: "I was found on the ground by the fountain about"
        }
        ListElement {
            time: 7
            str: "a fields of a summer stride"
        }
        ListElement {
            time: 10
            str: "lying in the sun after i had tried"
        }
        ListElement {
            time: 14
            str: "lying in the sun by the side"
        }
        ListElement {
            time: 21
            str: "we all agreed that the council would end up three hours over time"
        }
        ListElement {
            time: 29
            str: "shoe laces were tied at the traffic lights"
        }
    }

    Rectangle {
        id: background
        color: "white"
        anchors.fill: parent
    }

    ListView {

    }

    ListView {
        id: lrcView
        anchors.fill: parent
        clip: true
        model: lrcModel
        spacing: 15
        currentIndex: currentLineIndex
        highlightRangeMode: ListView.StrictlyEnforceRange

        delegate: Row {
            width: parent.width
            height: text.height + 10

            Text {
                id: lrcText
                text: model.text
                color: index === currentLineIndex ? Qt.rgba(0.7,0.3,0.2,1) : Qt.rgba(0.4,0.4,0.4,1)
                font.pixelSize: index === currentLineIndex ? 18 : 14
                font.bold: index === currentLineIndex
                horizontalAlignment: Text.AlignHCenter
                width: parent.width
                wrapMode: Text.WordWrap

                Behavior on color { ColorAnimation { duration: 300 } }
                Behavior on font.pixelSize { NumberAnimation { duration: 300 } }
            }
        }

        flickDeceleration: 500
        snapMode: ListView.SnapOneItem
        highlight: Rectangle {
            color: "transparent"
            border.color: "#ff5500"
            border.width: 1
            radius: 4
            height: contentItem.height
            width: parent.width - 20
            y: contentItem.y
            x: 10
        }
    }

}
