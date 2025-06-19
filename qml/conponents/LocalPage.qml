import QtQuick
import QtQuick.Controls
import MyModel

Item {
    id:localPage
    property bool isReady: false

    property var filePathTxt: "/home/br0/7/SHX_Music/data/localMusic.txt"
    property var currentIndex: -1
    property var deleteFiles: []

    property var musicplayer

    Rectangle{
        anchors.fill: parent
        color: "green"
    }

    MusicModel{
        id:musicModel
    }

    property alias musicModel: musicModel

    ListView {
        id: localListView
        width: parent.width
        anchors.fill: parent  // 修正布局锚点
        model: musicModel
        spacing: 5

        delegate: Rectangle {
            width: localListView.width
            height: 50
            color: "lightgrey"
            radius: 15

            Text {
                text: title  // 直接使用角色名访问title
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 15
                font.pixelSize: 14
                elide: Text.ElideRight
                width: parent.width - 80

            }
            MouseArea {
                anchors.fill: parent
                /////
                onClicked: {
                    console.log("mCount ", musicModel.getCount())
                    currentIndex = index
                    //musicModel.removeMusic(currentIndex)
                    var deleteIndex = currentIndex;
                    if(!deleteFiles.includes[deleteIndex]){
                        deleteFiles.push(deleteIndex)
                        console.log(deleteIndex)
                    }
                    var modelIndex = musicModel.createModelIndex(currentIndex, 0);
                    console.log(musicModel.data(modelIndex, MusicModel.FilePathRole))
                    var path = "file://" + musicModel.data(modelIndex, MusicModel.FilePathRole)
                    console.log(path)
                    musicplayer.player.source = path
                    //deleteMusic(filePathTxt, deleteFiles)

                    //MusicPathOperations.DeletePathTotxt(filePathTxt, )
                }

                onDoubleClicked: {
                    addToCurrentModel(musicModel.data(musicModel.createModelIndex(currentIndex), MusicModel.FilePathRole))
                }
            }
        }
    }

    signal addToCurrentModel(var requestPath)
        // path -> currentModel

    signal addToLoveModel(var requestPath)

    //1
    function initLocalModel(filePathTxt){
        MusicPathOperations.OperationTxt(filePathTxt)
        for(var i = 0; i < MusicPathOperations.pathList.length; i++){
            musicModel.loadFromFile(MusicPathOperations.pathList[i])
            musicModel.setCount()
        }
    }

    function deleteMusic(filePath, deleteFiles){
        MusicPathOperations.DeletePathToTxt(filePathTxt, deleteFiles)
    }

    Component.onCompleted:{
        //localPage.initLocalModel(filePathTxt)
        localListView.update()
        console.log("localPage...")
        localPage.isReady = true
    }
}
