import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import "../logic"


Window {
    id: window
    minimumWidth: 900
    minimumHeight: 600
    flags: Qt.Window | Qt.FramelessWindowHint
    color: "transparent"
    visible: true

    signal miniSize()
    signal midSize()
    signal maxSize()

    onWidthChanged: {
        window.width > 1000 ? maxSize() : window.width > 650 ? midSize() : miniSize()
    }

    Player {
        id: player1
        player.audioOutput.volume: 0.4
        //player.source: control.currentList[0]
    }

    ControlPlay {
        id: control
        musicplayer: player1

        anchors.bottom: playBar.bottom
        anchors.right: parent.right
        //anchors.top: parent.top
        Component.onCompleted: initCurrentModel()
    }

    //
    PlayListDialog{
        id:playDialog1
        controller:control
    }


    Rectangle {
        id: titleBar
        anchors.left: parent.left
        anchors.right: parent.right
        height: 40
        color: Qt.rgba(0.106, 0.553, 0.788,1)

        topLeftRadius: 12
        topRightRadius: 12

        Rectangle {               //fix bottom radius
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 20
            color: parent.color
        }

        Text {
            id: titleText
            text: "SHX Music"
            color: "white"
            font.pixelSize: 16

            anchors.left: parent.left
            anchors.leftMargin: 15
            anchors.verticalCenter: parent.verticalCenter
        }

        Row {
            id: windowControlButtons
            anchors.right: parent.right
            anchors.rightMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            spacing: 4

            RoundRectangleButton {
                id: minButton
                width: 30
                height: 30
                radius: 10
                Text {
                    text: "—"
                    font.pixelSize: 16
                    anchors.centerIn: parent
                }
                onTapped: window.showMinimized()
            }

            RoundRectangleButton {
                id: maxButton
                width: 30
                height: 30
                radius: 10
                Text {
                    text: window.visibility === Window.Maximized ? "❐" : "□"
                    font.pixelSize: 16
                    anchors.centerIn: parent
                }
                onTapped: window.toggleMaximize()
            }

            RoundRectangleButton {
                id: closeButton
                width: 30
                height: 30
                radius: 10
                hoverBackgroundColor: Qt.rgba(1,0,0,0.65)
                Text {
                    color: closeButton.isHoverd ? "white" : "black"
                    text: "×"
                    font.pixelSize: 16
                    anchors.centerIn: parent
                }
                onTapped: window.close()
            }
        }

        MouseArea {
            id: titleControlArea
            anchors.left: parent.left
            anchors.right: windowControlButtons.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            onPressed: {
                window.startSystemMove()
            }
            onDoubleClicked: {
                window.toggleMaximize()
            }
        }
    }//title ends here

    PlayBar {
        id: playBar
        radius: 12
        player: player1
        controler: control
        //
        listdialog: playDialog1
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 100
        z: 999
    }

    RowLayout {
        id: midArea
        anchors.top: titleBar.bottom
        anchors.bottom: playBar.top
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 0

        SideMenu {
            id: menu
            Layout.preferredWidth: 150
            Layout.fillHeight: true

            Component.onCompleted: {
                localPage.initLocalModel("../../data/localMusic.txt")
                favoritePage.initLocalModel("../../data/favoriteMusic.txt")
            }
            onOpenLocalList: {
                localPage.visible=true
                favoritePage.visible=false
            }

            onOpenLoveList: {
                localPage.visible=false
                favoritePage.visible=true
                console.log("OPEN LOVE++++++++++++")
            }
        }

        LocalPage {
            id: localPage         //right top area
            musicplayer: player1

            Layout.fillWidth: true
            Layout.fillHeight: true

            onAddToCurrentModel: {
                var i = control.searchSong(requestPath)
                var modelIndex =localPage.musicModel.createModelIndex(currentIndex,0);
                var musicpath = localPage.musicModel.data(modelIndex, localPage.musicModel.FilePathRole)
                var path = "file://" + localPage.musicModel.data(modelIndex, localPage.musicModel.FilePathRole)
                if(i===-1){
                    control.insertSongToNext(musicpath,localPage.musicModel,musicpath)

                    console.log("musicpath",musicpath)
                    console.log("The insert path",localPage.musicModel.data(modelIndex, localPage.musicModel.FilePathRole))
                    console.log("添加新歌:", musicpath)

                }else{
                    control.jumpToSong(i)
                    console.log("跳转到已有歌曲:", i)

                }
                control.playSong(control.currentIndex)
            }
            onAddMusic: {
                addMusicDialog.open()
            }
        }
        FavoritePage{
            id:favoritePage
            musicplayer:player1

            Layout.fillWidth: true
            Layout.fillHeight: true

            onAddToCurrentModel: {
                var i = control.searchSong(requestPath)
                var modelIndex =favoritePage.musicModel.createModelIndex(favoriteIndex,0);
                var musicpath = favoritePage.musicModel.data(modelIndex, favoritePage.musicModel.FilePathRole)
                var path = "file://" + favoritePage.musicModel.data(modelIndex, favoritePage.musicModel.FilePathRole)
                if(i===-1){
                    control.insertSongToNext(musicpath,favoritePage.musicModel,musicpath)

                    console.log("musicpath",musicpath)
                    console.log("The insert path",favoritePage.musicModel.data(modelIndex, favoritePage.musicModel.FilePathRole))

                }else{
                    control.jumpToSong(i)

                }
                control.playSong(control.currentIndex)
            }
        }
    }



    Dialog {
        id: addMusicDialog

        signal openByFile()
        signal openByFolder()

        width: 200
        height: 100

        x: window.width - width
        y: titleBar.height + 45

        onAccepted: console.log("Ok clicked")
        onRejected: console.log("Cancel clicked")

        background: Rectangle{
            color: Qt.rgba(0.94,0.94,0.94,1)
            border.width: 2
            border.color: Qt.rgba(0.82,0.82,0.82,1)

            RoundRectangleButton {
                id: byFile
                hoverBackgroundColor: "transparent"
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter
                width: 50
                height: 50

                onTapped: addMusicDialog.openByFile()

                Image {
                    id: byFileIcon
                    source: "qrc:/control/image/file_add.png"
                    anchors.fill: parent
                }
            }
            Rectangle {
                id: verticalLine
                color: Qt.rgba(0.85,0.85,0.85,1)
                anchors.top: parent.top
                anchors.topMargin: 20
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter
                width: 2
            }

            RoundRectangleButton {
                id: byFolder
                hoverBackgroundColor: "transparent"
                anchors.right: parent.right
                anchors.rightMargin: 20
                anchors.verticalCenter: parent.verticalCenter
                width: 50
                height: 50

                onTapped: addMusicDialog.openByFolder()

                Image {
                    id: byFolderIcon
                    source: "qrc:/control/image/folder_add.png"
                    anchors.fill: parent
                }
            }
        }
        onOpenByFile: {
            // 创建文件对话框组件
            var fileDialogComponent = Qt.createComponent("MusicFileDialog.qml")

            if (fileDialogComponent.status === Component.Ready) {
                // 实例化对话框
                var fileDialog = fileDialogComponent.createObject(byFile, {
                                                                      "title": "选择文件",
                                                                      "selectedFile": Qt.resolvedUrl("."),
                                                                      // "onAccepted": function() {
                                                                      //     console.log("选择的文件:", fileDialog.fileUrls[0])
                                                                      //     fileDialog.destroy()  // 关闭后销毁
                                                                      // },
                                                                      // "onRejected": function() {
                                                                      //     console.log("对话框已取消")
                                                                      //     fileDialog.destroy()  // 关闭后销毁
                                                                      // }
                                                                  })

                // 显示对话框
                fileDialog.open()

                //do
            } else {
                console.error("无法加载文件对话框组件:", fileDialogComponent.errorString())
            }
        }
    }


    Item {//resizeWindow
        anchors.fill: parent
        MouseArea {
            anchors.right: parent.right
            anchors.top: parent.top
            width: 10
            height: 10
            cursorShape: Qt.SizeBDiagCursor
            onPressed: {
                window.startSystemResize(Qt.RightEdge | Qt.TopEdge)
            }
        }
        MouseArea {
            anchors.left: parent.left
            anchors.top: parent.top
            width: 10
            height: 10
            cursorShape: Qt.SizeFDiagCursor
            onPressed: {
                window.startSystemResize(Qt.LeftEdge | Qt.TopEdge)
            }
        }
        MouseArea {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            width: 10
            height: 10
            cursorShape: Qt.SizeFDiagCursor
            onPressed: {
                window.startSystemResize(Qt.RightEdge | Qt.BottomEdge)
            }
        }
        MouseArea {
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            width: 10
            height: 10
            cursorShape: Qt.SizeBDiagCursor
            onPressed: {
                window.startSystemResize(Qt.LeftEdge | Qt.BottomEdge)
            }
        }
        MouseArea {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            width: 8
            height: parent.height - 16
            cursorShape: Qt.SizeHorCursor
            onPressed: {
                window.startSystemResize(Qt.LeftEdge)
            }
        }
        MouseArea {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            width: 8
            height: parent.height - 16
            cursorShape: Qt.SizeHorCursor
            onPressed: {
                window.startSystemResize(Qt.RightEdge)
            }
        }
        MouseArea {
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 16
            height: 8
            cursorShape: Qt.SizeVerCursor
            onPressed: {
                window.startSystemResize(Qt.TopEdge)
            }
        }
        MouseArea {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 16
            height: 8
            cursorShape: Qt.SizeVerCursor
            onPressed: {
                window.startSystemResize(Qt.BottomEdge)
            }
        }
    }

    function toggleMaximize() {
        if (window.visibility === Window.Maximized) {
            titleBar.topLeftRadius = 12
            titleBar.topRightRadius = 12
            playBar.radius = 12
            window.showNormal()
        } else {
            window.showMaximized()
            titleBar.topLeftRadius = 0
            titleBar.topRightRadius = 0
            playBar.radius = 0
        }
    }
}
