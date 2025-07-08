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
    signal sourceEmpty()
    signal sourceNotEmpty()
    signal sourceUpdate()

    property var play: function(){_player.play()}
    property var pause: function(){_player.pause()}

    onSourceChanged: {
        sourceUpdate()
    }

    MediaPlayer {
        id: _player
        audioOutput: _audioOutput

        onPlaybackStateChanged: {
            //console.log("state changed")
            playbackState === MediaPlayer.PlayingState ? root.playing() : root.paused()
         }

        onSourceChanged: {
            if ( isUrlEmpty(source) ) {
                sourceEmpty()
            }else {
                console.log("NOT EMPTY>>>>>>>>>>>>>>>")
                sourceNotEmpty()
            }
        }
    }

    AudioOutput {
        id: _audioOutput
    }

    Component.onCompleted: {
        isReady = true
    }

    //
    function isUrlEmpty(url) {
        if (!url) return true;
        if (typeof url === 'string' && url.trim() === "") return true;
        const emptyUrls = ["", "file:///", "file://", "about:blank"];
        return emptyUrls.includes(url.toString());
    }
}
