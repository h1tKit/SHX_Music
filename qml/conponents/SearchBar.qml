import QtQuick
import QtQuick.Controls

Item {
    id: root

    property alias text: inputArea.text

    Rectangle {
        id: searchArea
        color: Qt.rgba(0.95,0.95,0.95,1)
        anchors.fill: parent

        border.width: 1
        border.color: Qt.rgba(0.106, 0.553, 0.788,1)
        radius: height / 2

    }

    TextField {
        id: inputArea
        anchors.left: searchArea.left
        anchors.leftMargin: 10
        anchors.right: searchIcon.left
        anchors.rightMargin: 10
        anchors.verticalCenter: searchArea.verticalCenter

        color: Qt.rgba(0.35,0.35,0.35,1)
        font.pixelSize: 16

        background: Item{}

    }

    Image {
        id: searchIcon
        source: "qrc:/control/image/search.png"
        width: searchArea.height * 0.5
        height: width
        anchors.verticalCenter: searchArea.verticalCenter
        anchors.right: searchArea.right
        anchors.rightMargin: 8
    }
}


