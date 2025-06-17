import QtQuick
import QtQuick.Controls

Item {
    id:musicDeal

    property string localPath: ""
    property string lovePath: ""
    property string playPath: ""
    property ListModel localModel: _localModel
    property ListModel loveModel: _loveModel
    property ListModel playModel: _playModel

    ListModel{
        id:_localModel
    }

    ListModel{
        id:_loveModel
    }

    ListModel{
        id:_playModel
    }

    function initLocalModel(model, filePath){
        musicPathOperations.OperationTxt(filePath)
        for(var i = 0; i < musicPathOperations.pathList.length; i++){
            musicInfo.parseFile(musicPathOperations.pathList[i])

            _localModel.append({
                "filePath": musicPathOperations.pathList[i],
                "title": musicInfo.metadata.title,
                "artist": musicInfo.metadata.artist,
                "album": musicInfo.metadata.album,
                "year": musicInfo.metadata.year,
                "track": musicInfo.metadata.track,
                "genre": musicInfo.metadata.genre,
                "coverArt": musicInfo.metadata.coverArt,
                "duration": musicInfo.metadata.duration,
                "bitrate": musicInfo.metadata.bitrate,
                "sampleRate": musicInfo.metadata.sampleRate,
                "channels": musicInfo.metadata.channels,
            })
        }
    }
}
