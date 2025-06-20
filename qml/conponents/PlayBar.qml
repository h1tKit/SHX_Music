import QtQuick
import QtQuick.Layouts
import QtMultimedia

Item {
    id: root

    property int radius: 12
    property var controler
    property var player
    //
    property var listdialog

    Rectangle {
        id: background
        color: Qt.rgba(0.95,0.95,0.95,1)
        anchors.fill: parent

        bottomLeftRadius: root.radius
        bottomRightRadius: root.radius

        Rectangle {
            id: line
            color: Qt.rgba(0.85,0.85,0.85,1)
            height: 1
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
        }
    }

    Rectangle {
        id: musicImage
        color: "transparent"
        width: 80
        height: 80
        radius: 40
        border.width: 1
        border.color: Qt.rgba(0,0,0,0.15)
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
    }

    Rectangle {
        id: details
        color: "transparent"
        width: 80
        height: 50
        anchors.left: musicImage.right
        anchors.leftMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 5

    }

    RoundRectangleButton {
        id: loveButton
        width: 34
        height: 34
        radius: 17
        hoverBackgroundColor: "transparent"
        anchors.left: details.right
        anchors.leftMargin: 30
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 14
        state: "love"

        states: [
            State {
                name: "love"
                PropertyChanges {
                    target: loveIcon
                    source : "qrc:/control/image/love.png"
                }
            },
            State {
                name: "not"
                PropertyChanges {
                    target: loveIcon
                    source : "qrc:/control/image/love_empty.png"
                }
            }
        ]

        onTapped: {
            state = (state === "love" ? "not" : "love")
        }

        Image {
            id: loveIcon
            anchors.fill: parent
            scale: 1
        }
    }

    RowLayout {
        id: playSlider
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 200
        anchors.right: parent.right
        anchors.rightMargin: 200
        spacing: 20

        Text {
            id: currentTime
            text: formatTime(player.currentTime)
            color: Qt.rgba(0.4,0.4,0.4,1)
        }

        TSlider {
            id: slider
            doneColor: Qt.rgba(0.106, 0.553, 0.788,1)
            undoneColor: Qt.rgba(0.7,0.7,0.7,1)
            handleColor: "white"
            handleCentralColor: Qt.rgba(0.106, 0.553, 0.788,1)
            handle.border.width: 1
            handle.border.color: Qt.rgba(0,0,0,0.15)
            Layout.preferredHeight: 6
            Layout.fillWidth: true

            from: 0
            to: player.player.duration
            value: player.player.position
            onDraged: player.player.position = setValue
        }

        Text {
            id: totalTime
            text: formatTime(player.duration)
            color: Qt.rgba(0.4,0.4,0.4,1)
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
            id: preButton
            radius: 20
            backgroundColor: Qt.rgba(0.133, 0.608, 0.859,1)
            hoverBackgroundColor: Qt.rgba(0.106, 0.553, 0.788,1)
            Layout.preferredHeight: 60
            Layout.preferredWidth: 60

            onTapped: {
                controler.prevSong()
            }

            Image {
                id: preIcon
                source: "qrc:/control/image/skip_previous.png"
                anchors.fill: parent
                scale: 0.6
            }
        }
        RoundRectangleButton {
            id: playButton
            radius: 20
            backgroundColor: Qt.rgba(0.133, 0.608, 0.859,1)
            hoverBackgroundColor: Qt.rgba(0.106, 0.553, 0.788,1)
            Layout.preferredHeight: 60
            Layout.preferredWidth: 60
            state: "paused"

            onTapped: {
                //state = state === "playing" ? "paused" : "playing"
                controler.playpause()
            }

            Connections {
                target: player
                onPlaying: {playButton.state = "playing"}
                onPaused: {playButton.state = "paused"}
            }

            states: [
                State {
                    name: "playing"
                    PropertyChanges {
                        target: playIcon
                        source: "qrc:/control/image/pause.png"
                    }
                },
                State {
                    name: "paused"
                    PropertyChanges {
                        target: playIcon
                        source: "qrc:/control/image/play.png"
                    }
                }
            ]

            Image {
                id: playIcon
                source: "qrc:/control/image/play.png"
                anchors.fill: parent
                scale: 0.6
            }
        }
        RoundRectangleButton {
            id: nextButton
            radius: 20
            backgroundColor: Qt.rgba(0.133, 0.608, 0.859,1)
            hoverBackgroundColor: Qt.rgba(0.106, 0.553, 0.788,1)
            Layout.preferredHeight: 60
            Layout.preferredWidth: 60

            onTapped: {
                controler.nextSong()
            }

            Image {
                id: nextIcon
                source: "qrc:/control/image/skip_next.png"
                anchors.fill: parent
                scale: 0.6
            }
        }
    }

    RoundRectangleButton {
        id: playModeButton
        width: 34
        height: 34
        hoverBackgroundColor: "transparent"
        anchors.right: volumeButton.left
        anchors.rightMargin: 30
        anchors.verticalCenter: parent.verticalCenter

        onStateChanged: {
            controler.playMode = (state === "sequence" ? 0 : (state === "random" ? 1 : 2))
        }

        state: "sequence"

        onTapped: {
            state = (state === "sequence" ? "random" : (state === "random" ? "loop" : "sequence"))
        }

        states: [
            State {
                name: "random"
                PropertyChanges {
                    target: playModeIcon
                    source: "qrc:/control/image/random.png"
                }
            },
            State {
                name: "sequence"
                PropertyChanges {
                    target: playModeIcon
                    source: "qrc:/control/image/loop.png"
                }
            },
            State {
                name: "loop"
                PropertyChanges {
                    target: playModeIcon
                    source: "qrc:/control/image/single_loop.png"
                }
            }
        ]

        Image {
            id: playModeIcon
            anchors.fill: parent
        }
    }

    VolumeSlider {
        id: volumeSlider
        visible: false
        width: 40
        height: 150
        anchors.horizontalCenter: volumeButton.horizontalCenter
        anchors.bottom: volumeButton.top
        anchors.bottomMargin: 20

        onVolumeValueChanged: {
            player.volume = volumeSlider.volumeValue
            volumeButton.preVolume = volumeSlider.volumeValue
            volumeButton.state = "normal"
        }

        onIsHoverdChanged: {
            if (isHoverd){
                console.log("ENTER VOLUMESLIDER")
                hoverButtonShowTimer.stop()
            }else {
                if (!volumeButtonMouseArea.containsMouse) {
                    hoverButtonShowTimer.start()
                }
            }
        }
    }

    Timer {
        id: hoverButtonShowTimer
        interval: 500
        onTriggered: {
            volumeSlider.visible = false
        }
    }

    RoundRectangleButton {
        id: volumeButton

        width: 30
        height: 30
        hoverBackgroundColor: "transparent"
        anchors.right: listButton.left
        anchors.rightMargin: 30
        anchors.verticalCenter: parent.verticalCenter
        state: "normal"

        property real preVolume: 0.4

        MouseArea {
            id: volumeButtonMouseArea
            anchors.fill: parent
            hoverEnabled: true
            property bool containsMouse: false

            onEntered: {
                containsMouse = true
                hoverButtonShowTimer.stop()
                volumeSlider.visible = true
            }
            onExited: {
                containsMouse = false
                if (!volumeSlider.isHoverd) {
                    hoverButtonShowTimer.start()
                }
            }
            onClicked: {
                console.log("CLICK")
                volumeButton.state = (volumeButton.state === "normal" ? "mute" : "normal")
            }
        }

        onStateChanged: {
            if (state === "mute") {
                volumeSlider.mute = true
                player.volume = 0
            }else {
                volumeSlider.mute = false
                player.volume = preVolume
            }
        }

        states: [
            State {
                name: "normal"
                PropertyChanges {
                    target: volumeIcon
                    source: "qrc:/control/image/volume.png"
                }
            },
            State {
                name: "mute"
                PropertyChanges {
                    target: volumeIcon
                    source: "qrc:/control/image/volume_mute.png"
                }
            }
        ]

        Image {
            id: volumeIcon
            source: "qrc:/control/image/volume.png"
            anchors.fill: parent
        }
    }

    RoundRectangleButton {
        id: listButton
        width: 30
        height: 30
        hoverBackgroundColor: "transparent"
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        state: "close"

        Image {
            id: listIcon
            source: "qrc:/control/image/musiclist.png"
            anchors.fill: parent
        }

        states: [
            State {name: "open"},
            State {name: "close"}
        ]

        onTapped: {
            //listButton.state = listButton.state === "open" ? "close" : "open"
            //controler.setVisible = (listButton.state === "open")
            controler.setVisible = true
            console.log("listButtonTapped")
        }
    }

    function formatTime(milliseconds) {
        if (!milliseconds || milliseconds <= 0)
            return "00:00"

        var totalSeconds = Math.floor(milliseconds / 1000)
        //console.log("Total Seconds : ", totalSeconds)
        var minutes = Math.floor(totalSeconds / 60)
        var seconds = totalSeconds % 60
        //
        return minutes.toString().padStart(2, '0') +
                ":" +
                seconds.toString().padStart(2, '0')
    }
}
