import QtQuick
import QtMultimedia

Item {
    id: root
    property alias player: _player

    signal playing()
    signal paused()

    property var play: function(){_player.play(); playing()}
    property var pause: function(){_player.pause(); paused()}

    MediaPlayer {
        id: _player
        audioOutput: _audioOutput
    }

    AudioOutput {
        id: _audioOutput
    }
}
