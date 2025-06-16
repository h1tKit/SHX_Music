import QtQuick
import QtQuick.Layouts

Item {
    id: root

    Rectangle {
        id: background
        color: Qt.rgba(0,0,0,0.03)
        anchors.fill: parent

        Rectangle {
            id: line
            color: Qt.rgba(0,0,0,0.15)
            height: 1
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
        }
    }

    Rectangle {
        id: imageArt
        color: "pink"
        width: 80
        height: 80
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
    }

    Rectangle {
        id: details
        color: "green"
        width: 80
        height: 50
        anchors.left: imageArt.right
        anchors.leftMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 5

    }

    Rectangle {
        id: loveButton
        width: 30
        height: 30
        anchors.left: details.right
        anchors.leftMargin: 30
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
    }

    RowLayout {
        id: playSlider
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 200
        anchors.right: parent.right
        anchors.rightMargin: 200
        spacing: 5

        Rectangle {
            id: currentTime
            Layout.preferredWidth: 30
            Layout.preferredHeight: 15
        }

        TSlider {
            id: slider
            Layout.preferredHeight: 6
            Layout.fillWidth: true
        }

        Rectangle {
            id: totalTime
            Layout.preferredWidth: 30
            Layout.preferredHeight: 15
        }
    }


    RowLayout {
        id: centralControler
        anchors.horizontalCenter: parent.horizontalCenter
        //anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        spacing: 40

        RoundRectangleButton {
            radius: 20
            backgroundColor: Qt.rgba(0.133, 0.608, 0.859,1)
            hoverBackgroundColor: Qt.rgba(0.106, 0.553, 0.788,1)
            Layout.preferredHeight: 60
            Layout.preferredWidth: 60

        }
        RoundRectangleButton {
            radius: 20
            backgroundColor: Qt.rgba(0.133, 0.608, 0.859,1)
            hoverBackgroundColor: Qt.rgba(0.106, 0.553, 0.788,1)
            Layout.preferredHeight: 60
            Layout.preferredWidth: 60
        }
        RoundRectangleButton {
            radius: 20
            backgroundColor: Qt.rgba(0.133, 0.608, 0.859,1)
            hoverBackgroundColor: Qt.rgba(0.106, 0.553, 0.788,1)
            Layout.preferredHeight: 60
            Layout.preferredWidth: 60
        }

    }

    Rectangle {
        id: playModeButton
        width: 30
        height: 30
        anchors.right: volumeButton.left
        anchors.rightMargin: 30
        anchors.verticalCenter: parent.verticalCenter
    }

    Rectangle {
        id: volumeButton
        width: 30
        height: 30
        color: Qt.rgba(0.5,0.7,0.3,1)
        anchors.right: listButton.left
        anchors.rightMargin: 30
        anchors.verticalCenter: parent.verticalCenter
    }

    Rectangle {
        id: listButton
        width: 30
        height: 30
        color: "blue"
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
    }

}
