import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts


Window {
    id: window
    minimumWidth: 900
    minimumHeight: 600
    flags: Qt.Window | Qt.FramelessWindowHint
    color: "transparent"
    visible: true

    signal miniSize()
    signal midSize()
    signal maxSize()

    onWidthChanged: {
        window.width > 1000 ? maxSize() : window.width > 650 ? midSize() : miniSize()
    }

    Rectangle {
        id: root
        anchors.fill: parent
        radius: 12
        color: "white"
        clip: true

        Rectangle {
            id: titleBar
            anchors.left: parent.left
            anchors.right: parent.right
            height: 40
            color: Qt.rgba(0.106, 0.553, 0.788,1)
            radius: parent.radius

            Rectangle {               //fix bottom radius
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 20
                color: parent.color
            }

            Text {
                text: "SHX Music"
                color: "white"
                font.pixelSize: 16

                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.verticalCenter: parent.verticalCenter
            }

            Row {
                id: controlButtons
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                spacing: 4

                RoundRectangleButton {
                    id: minButton
                    width: 36
                    height: 36
                    radius: 18
                    Text {
                        text: "—"
                        font.pixelSize: 16
                        anchors.centerIn: parent
                    }
                    onTapped: window.showMinimized()
                }

                RoundRectangleButton {
                    id: maxButton
                    width: 36
                    height: 36
                    radius: 18
                    Text {
                        text: window.visibility === Window.Maximized ? "❐" : "□"
                        font.pixelSize: 16
                        anchors.centerIn: parent
                    }
                    onTapped: window.toggleMaximize()
                }

                RoundRectangleButton {
                    id: closeButton
                    width: 36
                    height: 36
                    radius: 18
                    hoverBackgroundColor: Qt.rgba(1,0,0,0.65)
                    Text {
                        color: closeButton.isHoverd ? "white" : "black"
                        text: "×"
                        font.pixelSize: 16
                        anchors.centerIn: parent
                    }
                    onTapped: window.close()
                }
            }

            MouseArea {
                anchors.left: parent.left
                anchors.right: controlButtons.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                onPressed: {
                    window.startSystemMove()
                }
                onDoubleClicked: {
                    window.toggleMaximize()
                }
            }
        }

        Rectangle {
            id: mainArea
            width: parent.width
            height: parent.height - titleBar.height
            anchors.top: titleBar.bottom
            color: "transparent"

            ColumnLayout {
                visible: true
                id: rootColumn
                anchors.fill: parent
                spacing: 0

                RowLayout {
                    id: rootRow
                    Layout.fillHeight: true

                    Rectangle {
                        id: menu
                        color: Qt.rgba(0,0,0,0.03)
                        Layout.preferredWidth: 150
                        Layout.fillHeight: true

                        Rectangle {
                            id: line
                            color: Qt.rgba(0,0,0,0.15)
                            width: 1
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right
                        }
                    }

                    Rectangle {
                        id: viewArea
                        Layout.fillWidth: true
                    }
                }

                PlayBar {
                    id: playBar
                    Layout.fillWidth: true
                    Layout.preferredHeight: 100
                }
            }
        }
    }

    Item {
        anchors.fill: parent
        MouseArea {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            width: 10
            height: 10
            cursorShape: Qt.SizeFDiagCursor
            onPressed: {
                window.startSystemResize(Qt.RightEdge | Qt.BottomEdge)
            }
        }
        MouseArea {
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            width: 10
            height: 10
            cursorShape: Qt.SizeBDiagCursor
            onPressed: {
                window.startSystemResize(Qt.LeftEdge | Qt.BottomEdge)
            }
        }
        MouseArea {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            width: 8
            height: parent.height - 16
            cursorShape: Qt.SizeHorCursor
            onPressed: {
                window.startSystemResize(Qt.LeftEdge)
            }
        }
        MouseArea {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            width: 8
            height: parent.height - 16
            cursorShape: Qt.SizeHorCursor
            onPressed: {
                window.startSystemResize(Qt.RightEdge)
            }
        }
        MouseArea {
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 16
            height: 8
            cursorShape: Qt.SizeVerCursor
            onPressed: {
                window.startSystemResize(Qt.TopEdge)
            }
        }
        MouseArea {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 16
            height: 8
            cursorShape: Qt.SizeVerCursor
            onPressed: {
                window.startSystemResize(Qt.BottomEdge)
            }
        }
    }

    function toggleMaximize() {
        if (window.visibility === Window.Maximized) {
            root.radius = 10
            window.showNormal()
        } else {
            window.showMaximized()
            root.radius = 0
        }
    }
}
