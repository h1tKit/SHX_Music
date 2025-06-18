import QtQuick

Item {
    id: root

    Rectangle {
        anchors.fill: parent
        color: "red"
    }

    Rectangle {
        rotation: 45
        width: parent.width/3.5
        height: width
        color: "red"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.bottom
        //transformOrigin: Item.Center
    }
}
