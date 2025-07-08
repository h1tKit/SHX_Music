import QtQuick
import QtQuick.Controls
import QtQuick.Window
import Lyric

Window {
    id: root

    minimumHeight: 160
    minimumWidth: 900

    color: "transparent"

    flags:  Qt.Window  | Qt.WindowStaysOnTopHint | Qt.X11BypassWindowManagerHint | Qt.FramelessWindowHint// | Qt.NoTitleBarBackgroundHint

    property string lrcFilePath: "../../data/empty.lrc"
    property string defalutPath: "../../data/empty.lrc"

    property var time
    property bool isClosed: true

    onLrcFilePathChanged: {
        if(!lyric.parseFile(lrcFilePath)){
            lyric.parseFile(root.defalutPath)
        }
    }

    function closeLrc(){
        root.close()
        isClosed = true
    }

    onTimeChanged: {
        console.log(time)
    }

    LyricParser{
        id:lyric
    }

    HoverHandler {
        onHoveredChanged: {
            if(hovered){
                lockButton.visible = true
                if(lockButton.state === "unlocked"){
                    lrcArea.color = Qt.rgba(0.2,0.2,0.2,0.2)
                    controlBar.color = Qt.rgba(0.15,0.15,0.15,0.25)
                    closeButton.visible = true
                }else {     //only lockButton is visible
                    lrcArea.color = "transparent"
                    controlBar.color = "transparent"
                    closeButton.visible = false
                }

            }else {         //hide all
                lrcArea.color = "transparent"
                controlBar.color = "transparent"
                closeButton.visible = false
                lockButton.visible = false
            }
        }
    }

    DragHandler {
        id: lrcDrager
        onActiveChanged: {
            if(active){
                root.startSystemMove()
            }
        }
    }

    Rectangle {
        id: controlBar
        width: root.width
        height: 25
        color: "transparent"

        Rectangle {
            id: lockButton
            anchors.left: controlBar.left
            anchors.verticalCenter: controlBar.verticalCenter
            color: "transparent"
            width: 20
            height: 20
            radius: 4

            states: [
                State {
                    name: "unlocked"
                },
                State {
                    name: "locked"
                }
            ]

            state: "unlocked"

            onStateChanged: {
                if(state === "locked"){
                    lrcDrager.enabled = false
                    lockIcon.source = "qrc:/control/image/locked.svg"
                }else {
                    lrcDrager.enabled = true
                    lockIcon.source = "qrc:/control/image/unlocked.svg"
                }
            }

            TapHandler {
                onTapped: {
                    console.log("TAPPED ", lockButton.state)
                    lockButton.state = (lockButton.state === "locked" ? "unlocked" : "locked")
                }
            }

            Image {
                id: lockIcon
                source: "qrc:/control/image/unlocked.svg"
                anchors.fill: parent
            }
        }

        Rectangle {
            id: closeButton
            visible: false
            anchors.right: controlBar.right
            anchors.verticalCenter: controlBar.verticalCenter
            color: "transparent"
            width: 20
            height: 20
            radius: 4

            TapHandler {
                onTapped: {
                    root.closeLrc()
                }
            }

            HoverHandler {
                onHoveredChanged: {
                    if(hovered){
                        closeButton.color = Qt.rgba(1,0,0,0.5)
                        closeIcon.color = "white"
                    }else {
                        closeButton.color = "transparent"
                        closeIcon.color = Qt.rgba(0.4,0.4,0.4,0.5)
                    }
                }
            }

            Text {
                id: closeIcon
                color: Qt.rgba(0.4,0.4,0.4,0.5)
                text: "×"
                font.pixelSize: 16
                anchors.centerIn: parent
            }
        }
    }

    Rectangle {
        id: lrcArea
        y: controlBar.height
        width: root.width
        height: root.height - controlBar.height
        color: "transparent"

        Text {
            id: lyricText
            text: lyric.getLyric(root.time)
            width: parent.width
            height: parent.height
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 50
            font.bold: true
            font.family: "Noto Sans"
            color: Qt.rgba(0.098, 0.639, 0.929)
            wrapMode: Text.WordWrap
            maximumLineCount: 2
            antialiasing: true
        }
    }
}
