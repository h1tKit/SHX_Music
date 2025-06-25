import QtQuick
import QtQuick.Layouts
import QtMultimedia

Item {
    id: root

    property int radius: 12
    property var controler
    property var favoritepage
    property var player
    //
    property var listdialog

    signal updatePlaySliderTime(var time)

    // property alias lovebutton: loveButton

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

    Connections {
        target: player
        function onPlaying() {
            animation.running = true
            animation.paused = false
        }
        function onPaused() {
            animation.paused = true
        }
        function onSourceEmpty() {
            details.visible = false
            currentTime.text = "00:00"
            totalTime.text = "00:00"
//TODO
        }
        function onSourceNotEmpty() {
            details.visible = true
            currentTime.text = Qt.binding(function() {
                return formatTime(player.currentTime)})
            totalTime.text = Qt.binding(function() {
                return formatTime(player.duration)})
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
        clip: true

        Image {
            id: coverArt

            source: "qrc:/control/image/CD.png"
            anchors.fill: parent

            transform:  Rotation {
                id: rotationAnim
                origin.x: coverArt.width/2
                origin.y: coverArt.height/2
                axis { x: 0; y: 0; z: 1 }
                angle: 0
                NumberAnimation on angle {
                    id: animation
                    from: 0
                    to: 360
                    duration: 25000
                    loops: Animation.Infinite
                    running: false
                }
            }
        }
    }

    Rectangle {
        id: details
        color: "transparent"
        width: 80
        height: 50
        anchors.left: musicImage.right
        anchors.leftMargin: 10
        anchors.top: playSlider.bottom
        anchors.topMargin: 5

        Text {
            id: detailTitle
            width: 180
            anchors.top: parent.top
            anchors.left: parent.left
            font.pixelSize: 17
            color: Qt.rgba(0.3,0.3,0.3,1)
            elide: Text.ElideRight
        }
        Text {
            id: detailArtist
            width: 180
            anchors.top: detailTitle.bottom
            anchors.topMargin: 5
            anchors.left: parent.left
            font.pixelSize: 12
            color: Qt.rgba(0.35,0.35,0.35,1)
            elide: Text.ElideRight
        }

    }

    RoundRectangleButton {
        id: loveButton
        visible: false
        width: 34
        height: 34
        radius: 17
        hoverBackgroundColor: "transparent"
        anchors.right: playModeButton.left
        anchors.rightMargin: 30
        anchors.verticalCenter: parent.verticalCenter

        state: "not"


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

        onStateChanged: {
            // console.log("state ",state)
            // if(state === "love"){
            //     var currentpath = controler.currentList[controler.currentIndex]
            //     var i = favoritepage.searchByloveModel(currentpath)
            //     var modelIndex = favoritepage.musicModel.createModelIndex(controler.currentIndex,0);
            //     var musicpath = favoritepage.musicModel.data(modelIndex, favoritepage.musicModel.FilePathRole)
            //     if(i===-1){
            //         console.log("添加进喜欢列表")
            //         favoritepage.insertSongToLast(musicpath)
            //     }else{
            //         console.log("错误，从not变为love，不应该找到")
            //     }
            // }
            // if(state === "not"){
            //     //todo remove
            // }
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

            Connections {
                function onDraged(setValue) {player.player.position = setValue}
            }

            onValueChanged: {
                updatePlaySliderTime(value)
            }
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
                function onPlaying() {playButton.state = "playing"}
                function onPaused() {playButton.state = "paused"}
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
        radius: 8

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
        radius: 9

        x: parent.width - 70 - volumeButton.width/2 - width/2
        y: - height + 25

        onVolumeValueChanged: {
            player.volume = volumeSlider.volumeValue
            volumeButton.preVolume = volumeSlider.volumeValue
            volumeButton.state = "normal"
        }

        onIsHoverdChanged: {
            if (isHoverd){
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
        radius: 8
        //hoverBackgroundColor: "transparent"
        anchors.right: listButton.left
        anchors.rightMargin: 30
        anchors.verticalCenter: parent.verticalCenter
        state: "normal"

        property real preVolume: 0.4

        HoverHandler {
            id: volumeButtonMouseArea
            property bool containsMouse: false
            onHoveredChanged: {
                //console.log("Hovered changed")
                if(hovered){
                    volumeSlider.stillVisible = true
                    volumeButtonMouseArea.containsMouse = true
                    hoverButtonShowTimer.stop()
                    volumeSlider.visible = true
                }else {
                    volumeSlider.stillVisible = false
                    volumeButtonMouseArea.containsMouse = false
                    if (!volumeSlider.isHoverd) {
                        hoverButtonShowTimer.start()
                    }
                }
            }
        }

        TapHandler {
            onTapped: {
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

    Connections {
        target: controler
        function onOpened() {
            listButton.state = "opened"
            listButton.enabled = false
        }
        function onClosed() {
            listButton.state = "closed"
            listButton.enabled = true
        }
        function onUpdateDetail(songTitle, artist) {
            if(songTitle === undefined) songTitle = ""
            if(artist === undefined) artist = ""
            detailTitle.text = songTitle
            detailArtist.text = artist
        }
    }

    RoundRectangleButton {
        id: listButton
        width: 30
        height: 30
        radius: 8

        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        state: "closed"

        Image {
            id: listIcon
            source: "qrc:/control/image/musiclist.png"
            anchors.fill: parent
        }

        states: [
            State {name: "opened"},
            State {name: "closed"}
        ]

        onTapped: {
            if (state === "closed") {
                controler.dialogVisible = true
            }
        }
    }

    function formatTime(milliseconds) {
        if (!milliseconds || milliseconds <= 0) {
            return "00:00"
        }
        var totalSeconds = Math.floor(milliseconds / 1000)
        var minutes = Math.floor(totalSeconds / 60)
        var seconds = totalSeconds % 60
        return minutes.toString().padStart(2, '0') +
                ":" +
                seconds.toString().padStart(2, '0')
    }
}
