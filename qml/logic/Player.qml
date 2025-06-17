import QtQuick
import QtMultimedia

Item {

    property alias player: _player


    MediaPlayer {
        id: _player
        audioOutput: _audioOutput
    }

    AudioOutput {
        id: _audioOutput
    }
}
