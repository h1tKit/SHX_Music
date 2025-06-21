import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root

    signal openLocalList()
    signal openLoveList()
    signal resizeMenu()

    Rectangle {
        id: background
        color: Qt.rgba(0.95,0.95,0.95,1)
        anchors.fill: parent

        Rectangle {
            id: line
            color: Qt.rgba(0.85,0.85,0.85,1)
            width: 1
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: parent.bottom
        }
    }

    Rectangle {
        id: selectedMark
        color: Qt.rgba(0.106, 0.553, 0.788,1)
        width: 5
        height: 40
        anchors.left: parent.left
        y: 20

        Behavior on y {
            NumberAnimation {
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }
    }

    onOpenLocalList: {
        selectedMark.y = 20
        localListText.color = Qt.rgba(0.2,0.2,0.2,1)
        loveListText.color = Qt.rgba(0.4,0.4,0.4,1)
    }
    onOpenLoveList:  {
        selectedMark.y = 80
        localListText.color = Qt.rgba(0.4,0.4,0.4,1)
        loveListText.color = Qt.rgba(0.2,0.2,0.2,1)
    }

    ColumnLayout {
        id: buttonColumn
        anchors.topMargin: 20
        anchors.fill: parent
        spacing: 20

        RoundRectangleButton {
            id: localListButton
            Layout.preferredWidth: root.width
            Layout.preferredHeight: 40
            hoverBackgroundColor: "transparent"

            onTapped: openLocalList()

            Image {
                id: localListIcon
                source: "qrc:/control/image/music.png"
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                width: 20
                height: 20
            }
            Text {
                id: localListText
                text: qsTr("本地音乐")
                color: Qt.rgba(0.2,0.2,0.2,1)
                anchors.left: localListIcon.right
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 20
            }
        }
        RoundRectangleButton {
            id: loveListButton
            Layout.preferredWidth: root.width
            Layout.preferredHeight: 40
            hoverBackgroundColor: "transparent"

            onTapped: openLoveList()

            Image {
                id: loveListIcon
                source: "qrc:/control/image/love.png"
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                width: 20
                height: 20
            }
            Text {
                id: loveListText
                text: qsTr("我的喜欢")
                color: Qt.rgba(0.4,0.4,0.4,1)
                anchors.left: loveListIcon.right
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 20
            }
        }

        Item {
            id: bottomSpace
            Layout.fillHeight: true
        }
    }
}
