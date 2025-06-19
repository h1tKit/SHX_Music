import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia
import MyModel

Item {
    id:localPage
    property bool isReady: false

    property var filePathTxt: "/home/br0/7/SHX_Music/data/localMusic.txt"
    property var currentIndex: -1
    property var deleteFiles: []

    property var musicplayer

    property alias musicModel: musicModel

    property var selectedList: []

    signal addToCurrentModel(var requestPath)
    signal addToLoveModel(var requestPath)

    signal addMusic()


    ////////////////////////////////////////////////////////////
    Rectangle {
        id: background
        color: Qt.rgba(0.95,0.95,0.95,1)
        anchors.fill: parent
    }

    MusicModel{
        id:musicModel
    }

    Rectangle {
        id: titleBackground
        color: Qt.rgba(0.95,0.95,0.95,1)
        height: 50
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        Text {
            id: titleText
            text: qsTr("本地音乐")
            color: Qt.rgba(0.2,0.2,0.2,1)
            font.pixelSize: 20
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.verticalCenter: parent.verticalCenter
        }

        Rectangle {
            id: bottomLine
            color: Qt.rgba(0.85,0.85,0.85,1)
            anchors.bottom: titleBackground.bottom
            anchors.left: titleBackground.left
            anchors.right: titleBackground.right
            height: 1
        }

        RoundRectangleButton {
            id: opButton
            anchors.right: addMusicsFromFolder.left
            anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            width: 30
            height: 30

            onTapped: {
                editDialog.open()
            }

            Image {
                id: opIcon
                source: "qrc:/control/image/menu_edit.png"
                anchors.fill: parent
            }
        }

        RoundRectangleButton {
            id: addMusicsFromFolder
            anchors.right: parent.right
            anchors.rightMargin: 40
            anchors.verticalCenter: parent.verticalCenter
            width: 30
            height: 30
            //hoverBackgroundColor: "transparent"

            Image {
                id: addMusicIcon
                source: "qrc:/control/image/add_square.png"
                anchors.fill: parent
            }

            onTapped: {
                addMusic()
                console.log("addFolder")
            }
        }

    }

    Dialog {
        id: editDialog

        signal multiOp()
        signal playAll()

        width: 120
        height: 80

        x: parent.width - width - 30
        y: subTitleBar.height + 20

        onAccepted: console.log("Ok clicked")
        onRejected: console.log("Cancel clicked")

        background: Rectangle{
            color: Qt.rgba(0.94,0.94,0.94,1)
            border.width: 2
            border.color: Qt.rgba(0.82,0.82,0.82,1)

            ColumnLayout {
                anchors.fill: parent
                spacing: 0
                Item {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    id: playAllItem
                    RoundRectangleButton {
                        id: playAllButton
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        width: 120
                        height: 20

                        onTapped: editDialog.playAll()

                        Image {
                            id: playAllIcon
                            source: "qrc:/control/image/file_add.png"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            width: 20
                            height: 20
                        }
                    }
                    Text {
                        id: playAllText
                        text: qsTr("播放全部")
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: 15
                        font.pixelSize: 15
                    }
                }
                Rectangle {
                    id: line
                    color: Qt.rgba(0.85,0.85,0.85,1)
                    height: 1
                    Layout.fillWidth: true
                }
                Item {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    id: multiOpItem
                    RoundRectangleButton {
                        id: multiOpButton
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        width: 120
                        height: 20

                        onTapped: editDialog.multiOp()

                        Image {
                            id: byFileIcon
                            source: "qrc:/control/image/file_add.png"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            width: 20
                            height: 20

                        }
                    }
                    Text {
                        id: multiOpText
                        text: qsTr("批量操作")
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: 15
                        font.pixelSize: 15
                    }
                }

            }
        }
    }


    Rectangle {
        id: subTitleBar
        color: Qt.rgba(0.95,0.95,0.95,1)
        height: 30
        anchors.top: titleBackground.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        Rectangle {
            id: subTitleBarBottomLine
            color: Qt.rgba(0.85,0.85,0.85,1)
            height: 1
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
        }

        RoundRectangleButton {
            id: selectAllButton
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            width: 30
            height: 30

            hoverBackgroundColor: "blue"
        }

        Text {
            id: title
            text: qsTr("音乐标题")
            color: Qt.rgba(0.3,0.3,0.3,1)
            font.pixelSize: 14
            anchors.left: selectAllButton.left
            anchors.leftMargin: 60
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            id: artist
            text: qsTr("歌手")
            color: Qt.rgba(0.3,0.3,0.3,1)
            font.pixelSize: 14
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: -30
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            id: duration
            text: qsTr("时长")
            color: Qt.rgba(0.3,0.3,0.3,1)
            font.pixelSize: 14
            anchors.right: parent.right
            anchors.rightMargin: 60
            anchors.verticalCenter: parent.verticalCenter
        }
    }





    ListView {
        id: localListView
        width: parent.width
        anchors.top: subTitleBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        model: musicModel
        spacing: 0
        clip: true

        delegate: Rectangle {
            id: single
            height: 40
            width: localListView.width
            color: index % 2 === 1 ? Qt.rgba(0.95,0.95,0.95,1) : Qt.rgba(0.9,0.9,0.9,1)

            property color originalColor: index % 2 === 1 ? Qt.rgba(0.95,0.95,0.95,1) : Qt.rgba(0.9,0.9,0.9,1)

            Text {
                id: singleTitleText
                text: title
                color: Qt.rgba(0.2,0.2,0.2,1)
                font.pixelSize: 14
                anchors.left: single.left
                anchors.leftMargin: 60
                anchors.verticalCenter: single.verticalCenter
            }
            Text {
                id: singleArtistText
                text: artist
                color: Qt.rgba(0.4,0.4,0.4,1)
                anchors.horizontalCenter: single.horizontalCenter
                anchors.horizontalCenterOffset: -30
                anchors.verticalCenter: single.verticalCenter
            }
            Text {
                id: singleDurationText
                text: duration
                color: Qt.rgba(0.4,0.4,0.4,1)
                anchors.right: single.right
                anchors.rightMargin: 60
                anchors.verticalCenter: single.verticalCenter
            }
//////////////////////////////////////////////
            Rectangle {
                id: singleSelectedMark
                width: 16
                height: 16
                radius: 8
                color: "transparent"
                border.width: 2
                border.color: Qt.rgba(0.106, 0.553, 0.788,1)
                anchors.left: single.left
                anchors.leftMargin: 13
                anchors.verticalCenter: single.verticalCenter
                state: "unselected"

                states: [
                    State {
                        name: "selected"
                        PropertyChanges {
                            target: singleSelectedMark
                            color: Qt.rgba(0.106, 0.553, 0.788,1)
                        }
                    },
                    State {
                        name: "unselected"
                        PropertyChanges {
                            target: singleSelectedMark
                            color: "transparent"
                        }
                    }
                ]

                onStateChanged: {
                    if(state === "selected") {
                        selectedList.push(filePath)
                        console.log("Selected ", filePath)
                    }else {
                        var i = selectedList.indexOf(filePath)
                        if (i !== -1) {
                            selectedList.splice(i, 1)
                            console.log("unSelected ", filePath)
                        }
                    }
                }
            }

            MouseArea {
                anchors.fill: single
                hoverEnabled: true
                onEntered: single.color = Qt.rgba(0.8,0.8,0.8,1)
                onExited: single.color = single.originalColor
            }

            MouseArea {
                anchors.fill: singleSelectedMark
                onClicked: {
                    singleSelectedMark.state = singleSelectedMark.state === "selected" ? "unselected" : "selected"
                }
            }

            MouseArea {
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.left: singleSelectedMark.right

                onClicked: {
                    console.log("musicModel.getCount() : ", musicModel.getCount())
                    currentIndex = index
                    //musicModel.removeMusic(currentIndex)
                    // var deleteIndex = currentIndex;
                    // if(!deleteFiles.includes[deleteIndex]){
                    //     deleteFiles.push(deleteIndex)
                    //     console.log(deleteIndex)
                    // }
                    var modelIndex = musicModel.createModelIndex(currentIndex, 0);
                    console.log(musicModel.data(modelIndex, MusicModel.FilePathRole))
                    var path = "file://" + musicModel.data(modelIndex, MusicModel.FilePathRole)
                    console.log(path)
                    musicplayer.player.source = path
                    //deleteMusic(filePathTxt, deleteFiles)

                    //MusicPathOperations.DeletePathTotxt(filePathTxt, )
                }

                onDoubleClicked: {
                    currentIndex=index
                    addToCurrentModel(musicModel.data(musicModel.createModelIndex(currentIndex), MusicModel.FilePathRole))
                }
            }
//////////////////////////////////////////////
        }
    }

    onAddMusic: {

    }

    function addMusicFolder(){

    }

    //1
    function initLocalModel(filePathTxt){
        MusicPathOperations.OperationTxt(filePathTxt)
        for(var i = 0; i < MusicPathOperations.pathList.length; i++){
            musicModel.loadFromFile(MusicPathOperations.pathList[i])
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
