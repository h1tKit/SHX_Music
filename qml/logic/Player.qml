import QtQuick
import QtMultimedia

Item {
    id: root
    property alias player: _player

    signal playing()
    signal paused()

    property var play: function(){_player.play()}
    property var pause: function(){_player.pause()}

    MediaPlayer {
        id: _player
        audioOutput: _audioOutput

        onPlaybackStateChanged: {
            console.log("state changed")
            playbackState === MediaPlayer.PlayingState ? root.playing() : root.paused()
         }
    }

    AudioOutput {
        id: _audioOutput
    }
}
