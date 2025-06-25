import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import MyModel
import "../logic"


Window {
    id: window
    minimumWidth: 900
    minimumHeight: 600
    flags: Qt.Window | Qt.FramelessWindowHint
    color: "transparent"
    visible: true

    property var reciverFromFile: []

    signal miniSize()
    signal midSize()
    signal maxSize()
    signal dataReady(var data)

    onReciverFromFileChanged:{          //发送在文件读取的文件给localpage
        dataReady(reciverFromFile)
    }

    onWidthChanged: {
        window.width > 1000 ? maxSize() : window.width > 650 ? midSize() : miniSize()
    }

    Player {
        id: player1
        player.audioOutput.volume: 0.4

        onPlaying: lyricPage.isPlaying = true

        onPaused: lyricPage.isPlaying = false
    }

    ControlPlay {
        id: control
        musicplayer: player1

        width: 300 + (window.width - 900) * 0.3
        height: (window.height - titleBar.height - playBar.height) * 0.8

        anchors.bottom: playBar.top
        anchors.right: parent.right
        Component.onCompleted: initCurrentModel()

        Connections {
            target: control
            function onUpdateLrc(lrcPath) {
                console.log("PATH ", lrcPath)
                lyricPage.lrcPath = lrcPath
                lyricPage.initLrc()
            }
        }
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
        favoritepage: favoritePage

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 100
        z: 999

        Connections {
            target: playBar
            function onUpdatePlaySliderTime(time) {
                lyricPage.playingTime = time
            }
        }
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
                favoritePage.initfavoriteModel("../../data/favoriteMusic.txt")
            }
            onOpenLocalList: {
                localPage.visible=true
                favoritePage.visible=false
                lyricPage.visible = false
            }

            onOpenLoveList: {
                localPage.visible=false
                favoritePage.visible=true
                lyricPage.visible = false
            }

            onOpenLyric: {
                localPage.visible = false
                favoritePage.visible = false
                lyricPage.visible = true
            }
        }

        LocalPage {
            id: localPage         //right top area
            musicplayer: player1
            rootWindow: window

            Layout.fillWidth: true
            Layout.fillHeight: true

            onPlayAllPage: {
                if(control.replaceWithSourceModel(localPage.musicModel) !== -1) {

                    player1.source = control.currentList[0]
                    player1.player.position=0
                    player1.play()
                }else {
                    console.log("错误， 传递空model")
                }
            }

            Connections {
                target: localPage
                function onRemoveSongbyBtn(removerequestPath){
                    var i = localPage.searchBylocalModel(removerequestPath)
                    var modelIndex = localPage.musicModel.createModelIndex(localPage.currentIndex,0);
                    var musicpath = localPage.musicModel.data(modelIndex, localPage.musicModel.FilePathRole)
                    if(i===-1){
                        console.log("错误，不应该找不到")
                    }else{
                        localPage.removeSongbyLocalModel(i)
                        console.log("删除一首本地音乐")
                    }
                }

                function onAddToLoveModel(addloverequestPath) {
                    //console.log("addloverequestpath",addloverequestPath)
                    var i = favoritePage.searchByloveModel(addloverequestPath)
                    var modelIndex = localPage.musicModel.createModelIndex(localPage.currentIndex,0);
                    var musicpath = localPage.musicModel.data(modelIndex, localPage.musicModel.FilePathRole)
                    var path = "file://" + localPage.musicModel.data(modelIndex, localPage.musicModel.FilePathRole)
                    if(i===-1){
                        favoritePage.insertSongToLast(musicpath)
                        console.log("添加进喜欢列表")
                    }else{
                        console.log("当前喜欢列表已有这首歌")
                    }
                }

                function onAddToCurrentModelbyDbc(dbcrequestPath) {
                    //console.log("localrequestpath",dbcrequestPath)
                    var i = control.searchSongbyReserve(dbcrequestPath)
                    // var i = control.searchSong(dbcrequestPath)

                    var modelIndex =localPage.musicModel.createModelIndex(localPage.currentIndex,0);
                    var musicpath = localPage.musicModel.data(modelIndex, localPage.musicModel.FilePathRole)
                    var path = "file://" + localPage.musicModel.data(modelIndex, localPage.musicModel.FilePathRole)
                    if(i===-1){
                        control.insertSongToNextbyDbc(musicpath,localPage.musicModel,musicpath)

                        //console.log("musicpath",musicpath)
                        //console.log("The insert path",localPage.musicModel.data(modelIndex, localPage.musicModel.FilePathRole))
                        //console.log("添加新歌:", musicpath)

                    }else{
                        control.jumpToSong(i)
                        //console.log("跳转到已有歌曲:", i)

                    }
                    control.playSong(control.currentIndex)
                }

                function onAddToCurrentModelbyBtn(btnrequestPath) {
                    var i = control.searchSong(btnrequestPath)

                    var modelIndex =localPage.musicModel.createModelIndex(localPage.currentIndex,0);
                    var musicpath = localPage.musicModel.data(modelIndex, localPage.musicModel.FilePathRole)
                    var path = "file://" + localPage.musicModel.data(modelIndex, localPage.musicModel.FilePathRole)
                    //单纯添加到下一首，及不播放，也不切换光标
                    control.insertSongToNextbyBtn(musicpath)
                    //console.log("musicpath",musicpath)
                    //console.log("The insert path",localPage.musicModel.data(modelIndex, localPage.musicModel.FilePathRole))
                    //console.log("添加新歌:", musicpath)
                }
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

            onPlayAllPage: {
                if(control.replaceWithSourceModel(favoritePage.musicModel) !== -1) {
                    player1.source = control.currentList[0]
                    player1.player.position=0
                    player1.play()
                }else {
                    console.log("错误， 传递空model")

                }
            }

            Connections {
                target: favoritePage
                function onRemoveLoveModelbyBtn(removeLoverequestPath) {
                    var i = favoritePage.searchByloveModel(removeLoverequestPath)
                    var modelIndex = favoritePage.musicModel.createModelIndex(favoritePage.favoriteIndex,0);
                    var musicpath = favoritePage.musicModel.data(modelIndex, favoritePage.musicModel.FilePathRole)
                    if(i===-1){
                        console.log("错误，不应该没找到")
                    }else{
                        favoritePage.removeLoveModel(i)
                        console.log("从喜欢列表删除")
                    }
                }

                function onAddToCurrentModelbyDbc(dbcrequestPath) {
                    var i = control.searchSongbyReserve(dbcrequestPath)
                    // var i = control.searchSong(dbcrequestPath)


                    var modelIndex =favoritePage.musicModel.createModelIndex(favoritePage.favoriteIndex,0);
                    var musicpath = favoritePage.musicModel.data(modelIndex, favoritePage.musicModel.FilePathRole)
                    var path = "file://" + favoritePage.musicModel.data(modelIndex, favoritePage.musicModel.FilePathRole)
                    if(i===-1){
                        control.insertSongToNextbyDbc(musicpath,favoritePage.musicModel,musicpath)
                        console.log("添加新歌:", musicpath)

                    }else{
                        control.jumpToSong(i)
                        console.log("跳转到已有歌曲:", i)

                    }
                    control.playSong(control.currentIndex)
                }

                function onAddToCurrentModelbyBtn(btnrequestPath) {
                    var i = control.searchSong(btnrequestPath)

                    var modelIndex =favoritePage.musicModel.createModelIndex(favoritePage.favoriteIndex,0);
                    var musicpath = favoritePage.musicModel.data(modelIndex, favoritePage.musicModel.FilePathRole)
                    var path = "file://" + favoritePage.musicModel.data(modelIndex, favoritePage.musicModel.FilePathRole)
                    //单纯添加到下一首，及不播放，也不切换光标
                    control.insertSongToNextbyBtn(musicpath)
                    console.log("添加新歌:", musicpath)
                }
            }
        }

        LrcDisplay {
            id: lyricPage
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }

    Dialog {
        id: addMusicDialog

        signal openByFile()
        signal openByFolder()

        width: 120
        height: 81

        x: window.width - width
        y: titleBar.height + 45

        //onAccepted: console.log("Ok clicked")
        //onRejected: console.log("Cancel clicked")

        background: Rectangle{
            anchors.fill: parent
            radius: 8
            color: Qt.rgba(0.94,0.94,0.94,1)
            border.width: 2
            border.color: Qt.rgba(0.82,0.82,0.82,1)

            ColumnLayout {
                anchors.fill: parent
                spacing: 1
                Item {
                    id: byFileItem
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    RoundRectangleButton {
                        id: byFileButton
                        anchors.fill: parent
                        radius: 8

                        onTapped: addMusicDialog.openByFile()
                    }
                    Image {
                        id: byFileIcon
                        source: "qrc:/control/image/file_add.png"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        width: 24
                        height: 24
                    }
                    Text {
                        id: byFileText
                        text: qsTr("添加文件")
                        color: Qt.rgba(0.2,0.2,0.2,1)
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: 14
                        font.pixelSize: 14
                    }
                }
                Item {
                    id: byFolderItem
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    RoundRectangleButton {
                        id: byFolderButton
                        anchors.fill: parent
                        radius: 8

                        onTapped: addMusicDialog.openByFolder()
                    }
                    Image {
                        id: byFolderIcon
                        source: "qrc:/control/image/folder_add.png"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        width: 24
                        height: 24
                    }
                    Text {
                        id: byFolderText
                        text: qsTr("添加文件夹")
                        color: Qt.rgba(0.2,0.2,0.2,1)
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: 14
                        font.pixelSize: 14
                    }
                }
            }
        }

        MusicFileDialog{
            id:mfDialog
            onFilesSelected:{
                //console.log("接收到 ", mfDialog.selectedFilePaths.length, " 个文件")
                reciverFromFile = mfDialog.selectedFilePaths;
                //console.log("=========",reciverFromFile[0])
            }
        }

        onOpenByFile: {
            mfDialog.filesDialog.open()
        }

        onOpenByFolder:{
            mfDialog.folderDialog.visible = true
        }
    }


    Item {
        id: resizeWindow
        anchors.fill: parent

        property real edgeSize: 6
        property real cornerSize: 7

        Item {
            id: leftTopArea
            anchors.left: parent.left
            anchors.top: parent.top
            width: resizeWindow.cornerSize
            height: resizeWindow.cornerSize

            HoverHandler {
                cursorShape: Qt.SizeFDiagCursor
            }
            TapHandler {
                onPressedChanged: {
                    if(pressed) window.startSystemResize(Qt.LeftEdge | Qt.TopEdge)
                }
            }
        }
        Item {
            id: leftBottomArea
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            width: resizeWindow.cornerSize
            height: resizeWindow.cornerSize

            HoverHandler {
                cursorShape: Qt.SizeBDiagCursor
            }
            TapHandler {
                onPressedChanged: {
                    if(pressed) window.startSystemResize(Qt.LeftEdge | Qt.BottomEdge)
                }
            }
        }
        Item {
            id: rightTopArea
            anchors.right: parent.right
            anchors.top: parent.top
            width: resizeWindow.cornerSize
            height: resizeWindow.cornerSize

            HoverHandler {
                cursorShape: Qt.SizeBDiagCursor
            }
            TapHandler {
                onPressedChanged: {
                    if(pressed) window.startSystemResize(Qt.RightEdge | Qt.TopEdge)
                }
            }
        }
        Item {
            id: rightBottomArea
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            width: resizeWindow.cornerSize
            height: resizeWindow.cornerSize

            HoverHandler {
                cursorShape: Qt.SizeFDiagCursor
            }
            TapHandler {
                onPressedChanged: {
                    if(pressed) window.startSystemResize(Qt.RightEdge | Qt.BottomEdge)
                }
            }
        }
        Item {
            id: leftArea
            anchors.left: parent.left
            anchors.top: leftTopArea.bottom
            anchors.bottom: leftBottomArea.top
            width: resizeWindow.edgeSize

            HoverHandler {
                cursorShape: Qt.SizeHorCursor
            }
            TapHandler {
                onPressedChanged: {
                    if(pressed) window.startSystemResize(Qt.LeftEdge)
                }
            }
        }
        Item {
            id: rightArea
            anchors.right: parent.right
            anchors.top: rightTopArea.bottom
            anchors.bottom: rightBottomArea.top
            width: resizeWindow.edgeSize

            HoverHandler {
                cursorShape: Qt.SizeHorCursor
            }
            TapHandler {
                onPressedChanged: {
                    if(pressed) window.startSystemResize(Qt.RightEdge)
                }
            }
        }
        Item {
            id: topArea
            anchors.left: leftTopArea.right
            anchors.top: parent.top
            anchors.right: rightTopArea.left
            height: resizeWindow.edgeSize

            HoverHandler {
                cursorShape: Qt.SizeVerCursor
            }
            TapHandler {
                onPressedChanged: {
                    if(pressed) window.startSystemResize(Qt.TopEdge)
                }
            }
        }
        Item {
            id: bottomArea
            anchors.left: leftBottomArea.right
            anchors.bottom: parent.bottom
            anchors.right: rightBottomArea.left
            height: resizeWindow.edgeSize

            HoverHandler {
                cursorShape: Qt.SizeVerCursor
            }
            TapHandler {
                onPressedChanged: {
                    if(pressed) window.startSystemResize(Qt.BottomEdge)
                }
            }
        }
    }

    onHeightChanged: {
        localPage.updatePage()
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

    Component.onCompleted: {
        console.log("程序窗口已创建")
    }

    Component.onDestruction: {
        MusicPathOperations.writeToTxt("../../data/localMusic.txt", localPage.musicModel)
        MusicPathOperations.writeToTxt("../../data/favoriteMusic.txt", favoritePage.musicModel)
        MusicPathOperations.writeToTxt("../../data/currentMusic.txt", control.currentModel)
        console.log("音乐列表已保存")
    }
}
