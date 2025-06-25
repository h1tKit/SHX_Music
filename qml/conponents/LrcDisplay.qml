import QtQuick
import QtQuick.Window
import QtQuick.Controls
import Lyric

Item {
    id: root
    visible: false

    property var lrcPath
    property string defalutPath: "../../data/empty.lrc"
    property var playingTime

    LyricParser{
        id:lyric
    }

    property bool isPlaying: false
    property int currentLyricIndex: 0
    property bool isScrolling: false

    function initLrc() {
        if(!lyric.parseFile(root.lrcPath)){
            lyric.parseFile(defalutPath)
        }
        lyricsListView.model = lyric.getAllLyrics()
    }

    onIsPlayingChanged: {
        if(isPlaying){
            playTimer.running = true
        }else {
            playTimer.running = false
        }
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: Qt.rgba(0.95,0.95,0.95,1)
    }

    ListView {
        id: lyricsListView
        anchors.fill: parent
        clip: true
        cacheBuffer: 120

        interactive: false
        flickableDirection: Flickable.VerticalFlick

        contentY: -parent.height/2

        delegate: Item {
            id: lyricItem
            width: lyricsListView.width
            height: 56

            Text {
                id: lyricText
                text: modelData
                horizontalAlignment: Text.AlignHCenter

                color: index === currentLyricIndex ? Qt.rgba(0.376, 0.753, 0.788,1) : Qt.rgba(0.4,0.4,0.4,1) //"#ff5500" : "#666"
                font.family: "Noto Sans"
                font.pixelSize: index === currentLyricIndex ? 28 : 18
                font.bold: index === currentLyricIndex
                anchors.verticalCenter: lyricItem.verticalCenter
                width: lyricItem.width
                wrapMode: Text.WordWrap
                maximumLineCount: 2

                Behavior on font.pixelSize {
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.InOutQuart
                    }
                }
            }
        }

        Behavior on contentY {
            NumberAnimation {
                duration: 300
                easing.type: Easing.OutCubic
            }
        }
    }

    onPlayingTimeChanged: {
        updateCurrentLyricIndex()
    }

    onCurrentLyricIndexChanged: {
        lyricsListView.contentY = -parent.height/2 + 56 * currentLyricIndex
    }

    Timer {
        id: playTimer
        interval: 100
        running: isPlaying
        repeat: true

        onTriggered: {
            updateCurrentLyricIndex();
        }
    }

    function updateCurrentLyricIndex() {
        currentLyricIndex = lyric.getCurrentLine(root.playingTime)
    }
}
