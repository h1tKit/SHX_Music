/*
name : RoundRectangleButton
version : 2.0
by huang kun
*/
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

        HoverHandler {
            onHoveredChanged: {
                if(hovered){
                    background.color = hoverBackgroundColor
                    background.isHovered = true
                }else {
                    background.color = backgroundColor
                    background.isHovered = false
                }
            }
        }

        TapHandler {
            onPressedChanged: {
                if(pressed){
                    background.color = hoverBackgroundColor
                    root.tapped()
                }else {
                    background.color = backgroundColor
                    clickedRecoverTimer.start()
                }
            }
        }
    }
}
