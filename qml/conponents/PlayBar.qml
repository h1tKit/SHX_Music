import QtQuick
import QtQuick.Layouts
import QtMultimedia

Item {
    id: root

    property int radius: 12
    property var controler
    property var player
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
        spacing: 5

        Rectangle {
            id: currentTime
            color: "transparent"
            Layout.preferredWidth: 30
            Layout.preferredHeight: 15
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
            to: player1.player.duration
            value: player1.player.position
            onDraged: player1.player.position = setValue
        }

        Rectangle {
            id: totalTime
            color: "transparent"
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
                onPlaying: playButton.state = "playing"
                onPaused: playButton.state = "paused"
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
        width: 40
        height: 130
        anchors.horizontalCenter: volumeButton.horizontalCenter
        anchors.bottom: volumeButton.top
        anchors.bottomMargin: 20
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

        onTapped: {
            state = (state === "normal" ? "mute" : "normal")
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

        Image {
            id: listIcon
            source: "qrc:/control/image/musiclist.png"
            anchors.fill: parent
        }

        onTapped: {
            listdialog.playdialog.open()
        }
    }

}
