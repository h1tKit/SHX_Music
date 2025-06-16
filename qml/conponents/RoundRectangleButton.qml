import QtQuick
import QtQuick.Controls

Item {
    id: root
    property string backgroundColor: Qt.rgba(0,0,0,0)
    property string hoverBackgroundColor: Qt.rgba(0,0,0,0.1)
    property int radius
    property bool isHoverd: background.isHovered

    signal tapped()

    Rectangle {
        id: background
        anchors.fill: parent
        color: (isHovered) ? hoverBackgroundColor : backgroundColor
        radius: parent.radius

        property bool isHovered: false

        Behavior on color {
            ColorAnimation {
                duration: 120
                easing.type: Easing.InOutQuad
            }
        }

        Timer {
            id: clickedRecoverTimer
            interval: 120
            onTriggered: {
                if (background.isHovered){
                    background.color = hoverBackgroundColor
                }
            }
        }

        MouseArea {
            anchors.fill: background
            onPressed: {
                background.color = hoverBackgroundColor
                root.tapped()
            }
            onReleased: {
                background.color = backgroundColor
                clickedRecoverTimer.start()
            }
            hoverEnabled: true
            onEntered: {
                background.color = hoverBackgroundColor
                background.isHovered = true
            }
            onExited: {
                background.color = backgroundColor
                background.isHovered = false
            }
        }
    }

}
