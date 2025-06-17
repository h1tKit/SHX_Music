import QtQuick
import QtQuick.Controls

Item {
    id:localPage
    width:parent.width
    height:parent.height

    property ListModel model: localModel

    Rectangle{
        anchors.fill: parent
        color: "green"
    }

    ListModel{
        id: localModel
    }

    ListView{
        id:localListView
        width: parent.width
        anchors.top: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.topMargin: 10
        model: model
        spacing: 5

        delegate: Rectangle{
            width: parent.width
            height: 50
            color: "lightgrey"
            radius: 15

            Text {
                //text: title
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 15
                font.pixelSize: 14
                elide: Text.ElideRight
                width: parent.width - 80
            }
        }
    }
}

