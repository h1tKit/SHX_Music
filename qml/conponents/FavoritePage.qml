import QtQuick
import QtQuick.Controls
import MyModel
Item {
    id:favoritePage
    visible: false

    property  var filePathTxt:"/run/media/root/data/Qt/shixun/SHX_Music/data/favoriteMusic.txt"
    property var controller
    property var musicplayer
    property var favoriteIndex: -1

    property alias musicModel: musicModel

    Rectangle{
        anchors.fill: parent
        color: "blue"
    }

    MusicModel{
        id:musicModel
    }

    ListView{
        id:favoriteView
        width: parent.width
        anchors.fill: parent
        model: musicModel
        spacing: 5

        delegate: Rectangle {
            width: favoriteView.width
            height: 50
            color: "lightgrey"
            radius: 15

            Text {
                id:titletxt
                text: title
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 15
                font.pixelSize: 14
                elide: Text.ElideRight
                width: parent.width -350
            }
            Text {

                text: artist
                anchors.top: titletxt.bottom
                anchors.topMargin:5
                anchors.left: parent.left
                anchors.leftMargin: 10
                elide: Text.ElideRight
                width: parent.width -350
                font.pixelSize: 10
            }
            Button{
                id:lovebutton
                text:"remove"
                width: 40
                height: 40
                anchors.left: titletxt.right
                anchors.leftMargin:0
                anchors.top: parent.top
                anchors.topMargin: 5
                onClicked: {
                    console.log("取消喜欢")
                    removeLoveModel(musicModel.data(musicModel.createModelIndex(index), MusicModel.FilePathRole))
                }
            }

            MouseArea{
                // anchors.fill: parent
                anchors{
                    left: parent.left
                    right:lovebutton.left
                    top:parent.top
                    bottom: parent.bottom
                }

                onClicked:{
                //todo

                }

                onDoubleClicked: {
                    favoriteIndex=index
                    addToCurrentModel(musicModel.data(musicModel.createModelIndex(favoriteIndex), MusicModel.FilePathRole))

                }
            }

        }
    }
    signal addToCurrentModel(var requestPath)


    signal removeLoveModel(var requestPath)
    //to do

    function initLocalModel(filePathTxt){
        MusicPathOperations.OperationTxt(filePathTxt)
        for(var i = 0; i < MusicPathOperations.pathList.length; i++){
            musicModel.loadFromFile(MusicPathOperations.pathList[i])
        }
    }

    Component.onCompleted: {
        favoritePage.update()
    }


}
