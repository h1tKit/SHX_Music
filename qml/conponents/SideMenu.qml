import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    property var windowWidth
    property var windowHeight

    Rectangle {
        id: background
        color: Qt.rgba(0,0,0,0.03)
        anchors.fill: parent

        ColumnLayout {
            anchors.topMargin: 20
            anchors.fill: parent
            spacing: 5
            RoundRectangleButton {
                id: localListButton
                Layout.preferredWidth: root.width
                Layout.preferredHeight: 40

                onTapped:{
                    //contentLoader.source = "LocalPage.qml"
                }
            }
            RoundRectangleButton {
                id: loveListButton
                Layout.preferredWidth: root.width
                Layout.preferredHeight: 40

            }
            RoundRectangleButton {
                id: minMenuButton
                Layout.preferredWidth: root.width
                Layout.preferredHeight: 40

            }
            Item {
                id: bottomSpace
                Layout.fillHeight: true
            }
        }
    }
}
