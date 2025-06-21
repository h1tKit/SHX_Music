import QtQuick
import QtMultimedia

Item {
    id: root
    property alias player: _player
    property alias source: _player.source
    property alias volume: _audioOutput.volume
    property alias currentTime: _player.position
    property var duration: _player.duration

    property bool isReady: false

    signal playing()
    signal paused()

    property var play: function(){_player.play()}
    property var pause: function(){_player.pause()}

    MediaPlayer {
        id: _player
        audioOutput: _audioOutput

        onPlaybackStateChanged: {
            //console.log("state changed")
            playbackState === MediaPlayer.PlayingState ? root.playing() : root.paused()
         }
    }

    AudioOutput {
        id: _audioOutput
    }

    Component.onCompleted: {
        isReady = true
    }
}
