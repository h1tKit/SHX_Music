import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia
import MyModel
import "../conponents"
//控制音乐所有有关播放的逻辑

Item {
    id:control
    property alias dialogVisible: _playDialog.visible

    signal opened()
    signal closed()
    signal updateDetail(var songTitle, var artist, var cover)
    signal updateLrc(var lrcPath)

    //signal sourceEmpty()



    property alias playdialog: _playDialog
    property alias currentModel: currentModel

    property var addMusicPath

    property var musicplayer

    //这个当前播放列表记录路径位置
    property var currentList: []
    property int currentIndex: -1//: currentView.currentIndex > 0 ? 0 : -1  //初始化时绑定到count

    property int playMode: 0 // 0-顺序 1-随机 2-单曲循环

    property var playHistory: []

    property bool isNavigatingHistory: false // 是否正在导航历史记录

    property var filePath: "../../data/currentMusic.txt"
    property var favoritefilePath :"../../data/favoriteMusic.txt"



    function initCurrentModel(filePath) {console.log("22222222",control.filePath)
        if (currentModel) {
            currentModel.clearMusic()
        }
        MusicPathOperations.OperationTxt(control.filePath)
        for(var i = 0; i < MusicPathOperations.pathList.length; i++){
            currentModel.loadFromFileAsync(MusicPathOperations.pathList[i],favoritefilePath)
        }
    }

    Connections{
        target: currentModel
        onLoadingFinished: {
            initcurrentlist()
        }
    }

    function initcurrentlist(){
        // console.log("currentModel final is ",currentModel.getCount())
        updateCurrentList();
        if (currentModel.getCount() > 0) {
            currentIndex = 0  // 设置为第一首
            musicplayer.source = currentList[0]  // 预加载第一首
            //console.log("默认加载第一首:", currentList[0])
        }
        musicplayer.player.mediaStatusChanged.connect(autoPlay)
    }


    onCurrentIndexChanged:{
        if (currentIndex >= 0 && currentIndex < currentModel.getCount()&& !isNavigatingHistory) {
            //changeSong()
            currentView.currentIndex = currentIndex
            //console.log("oncurrentchanged IslovebyCurrent",currentModel.data(currentModel.createModelIndex(currentIndex), MusicModel.IsLoveRole))
        }
        var ind = currentModel.createModelIndex(currentIndex,0)
        updateDetail(currentModel.data(ind, MusicModel.TitleRole), currentModel.data(ind, MusicModel.ArtistRole), currentModel.data(ind, MusicModel.CoverArtRole))
        updateLrc(currentModel.data(ind, MusicModel.LyricPathRole))
        console.log("__+_+_+_+_+",currentModel.data(ind, MusicModel.FilePathRole))
        console.log("__+_+_+_+_+",currentModel.data(ind, MusicModel.LyricPathRole))
    }

    Component.onDestruction: {
        musicplayer.player.mediaStatusChanged.disconnect(autoPlay)

    }

    function addToCurrent(addMusicPath) {
        currentModel.loadFromFileAsync(addMusicPath,favoritefilePath)
    }

    function searchSong(musicPath) {
        for(var i = 0; i < currentModel.getCount(); i++) {
            if (currentModel.data(currentModel.createModelIndex(i,0), MusicModel.FilePathRole) === musicPath) {
                return i;   //found
            }else {
                //console.log(currentModel.data(currentModel.createModelIndex(i,0), MusicModel.FilePathRole))
                //console.log(musicPath)
                continue;  //not found
            }
        }
        //console.log("notFound")
        return -1;
    }


    function searchSongbyReserve(musicPath) {
            if (currentModel.getCount() <=0) {
                //console.log("模型为空，无数据可搜索currentModel.getCount()",currentModel.getCount());
                return -1;
            }
            for(var i = currentModel.getCount() - 1; i >= 0; i--) {
                if (currentModel.data(currentModel.createModelIndex(i,0), MusicModel.FilePathRole) === musicPath) {
                    //console.log("Found")
                    return i;   //found
                }else {
                    //console.log("notFound now")
                    //console.log(currentModel.data(currentModel.createModelIndex(i,0), MusicModel.FilePathRole))
                    //console.log("searchsong()musicPath",musicPath)
                    continue;  //not found
                }
            }
            //console.log("notFound",)
            return -1;
        }


    //跳转
    function jumpToSong(index) {
        currentView.currentIndex = index;
        control.currentIndex = index;
    }


    //删除一首歌
    function removeSongInCurrentModel(musicIndex){

        //console.log("remove a song currentIndex",currentIndex)
        if(musicIndex!==-1){
            if(musicIndex===currentIndex){
                if(currentModel.getCount()===1){
                    removeAllInCurrentModel()
                    return
                }
                nextSong()
                updateCurrentList();
            }if(musicIndex > currentIndex){
                currentModel.removeMusic(musicIndex)
                updateCurrentList();
            }if(musicIndex < currentIndex){
                currentModel.removeMusic(musicIndex)
                currentIndex--
                updateCurrentList();
            }

        }
    }

    //清空全部
    function removeAllInCurrentModel(){
        currentModel.clearMusic()
        currentIndex=-1
        musicplayer.source= ""
        //sourceEmpty()
        //console.log("SOURCE EMPTY")
    }

    //双击插入一首歌事件
    function insertSongToNextbyDbc(musicPath,sourceModel = null,targetIndexpath = -1) {
        //空播放列表，有完整model
        if (currentModel.getCount() === 0 && sourceModel) {
            //console.log("正在执行完整model到空列表")
            replaceWithSourceModel(sourceModel,targetIndexpath);
            return;
        }

        //空播放列表，只提供了单个路径
        if (currentModel.getCount() === 0) {
            //console.log("正在执行单个路径到空列表")
            currentModel.insertMusic(-1,musicPath)
            updateCurrentList();
            currentIndex = 0;
        } else{
            //非空播放列表，正常传路径
            currentModel.insertMusic(currentIndex,musicPath)
            //console.log("正在执行正常到非空列表")
            updateCurrentList();
            currentView.update()
            currentIndex++;
            currentView.positionViewAtIndex(currentIndex, ListView.Center);
            currentView.currentIndex = currentIndex;
            //console.log("my currentIndex is ",currentIndex)
        }
        currentView.forceLayout();  // 强制重新布局

    }

    //按钮插入一首歌事件
    function insertSongToNextbyBtn(musicPath){
            if (currentModel.getCount() === 0) {
                //console.log("正在执行单个路径到空列表")
                currentModel.insertMusic(-1,musicPath)
                updateCurrentList();
                currentIndex = 0;
                musicplayer.source = currentList[0]
            }else{
                currentModel.insertMusic(currentIndex,musicPath)
                //console.log("正在执行正常到非空列表")
                updateCurrentList();
                currentView.update()
                currentView.positionViewAtIndex(currentIndex, ListView.Center);
                currentView.currentIndex = currentIndex;
                //console.log("my currentIndex is ",currentIndex)
            }
        }

    //可以实现全部播放
    function replaceWithSourceModel(sourceModel, targetPath) {
        // 检查model是否有效
        if (!sourceModel || sourceModel.getCount() === 0) {
            //console.warn("sourceModel为空或无效，导入取消");
            return -1;
        }

        // 清空当前模型并导入源模型数据
        currentModel.clearMusic();
        currentModel.copyModel(sourceModel)
        updateCurrentList();

        //如果是通过点击歌曲到空列表的方式更新model.查找目标歌曲在新列表中的位置
        if (targetPath) {
            var newIndex = searchSong(targetPath);
            if (newIndex !== -1) {
                currentIndex = newIndex;
            } else {
                currentIndex = 0;
            }
        } else {
            currentIndex = 0; // 没有就默认播放第一首
        }

    }




    MusicModel {
        id: currentModel
    }

    Dialog {
        id:_playDialog

        visible: false

        //width: 200
        //height: parent.height
        width: parent.width
        height: parent.height

        x: parent.width - width
        y: parent.height - height


        background: Rectangle {
            id: background
            width: parent.width
            height: parent.height

            //anchors.fill: parent
            color: Qt.rgba(0.95,0.95,0.95,1)
            radius: 14
            bottomRightRadius: 0
            topRightRadius: 0
            border.width: 1
            border.color: Qt.rgba(0.75,0.75,0.75,1)
            antialiasing: true

            Rectangle {
                id: subBar
                color: Qt.rgba(0.106, 0.553, 0.788,1)
                height: 40
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.left: parent.left
                topLeftRadius: 14


                RoundRectangleButton {
                    id: removeAllButton
                    anchors.right: subBar.right
                    anchors.rightMargin: 5 + (subBar.width - 300) * 0.08
                    anchors.left: removeAllText.left
                    anchors.bottom: subBar.bottom
                    anchors.top: subBar.top
                    radius: 14
                    hoverBackgroundColor: Qt.rgba(0.8,0.1,0.1,0.8)

                    onIsHoverdChanged: {
                        if (isHoverd) {
                            removeAllIcon.scale = 1.2
                        }else {
                            removeAllIcon.scale = 1
                        }
                    }

                    onTapped: {
                        // console.log("currentModel final is ",currentModel.getCount())
                        removeAllInCurrentModel()

                    }
                }
                Text {
                    id: removeAllText
                    text: "清空"
                    color: Qt.rgba(0.95,0.95,0.95,1)
                    anchors.verticalCenter: subBar.verticalCenter
                    anchors.right: removeAllIcon.left
                    anchors.rightMargin: 5
                    font.pixelSize: 16
                }

                Image {
                    id: removeAllIcon
                    source: "qrc:/control/image/delete.png"
                    anchors.right: subBar.right
                    anchors.rightMargin: 5 + (subBar.width - 300) * 0.08
                    anchors.verticalCenter: subBar.verticalCenter
                    width: 20
                    height: 20
                }
            }

        }


        //判断正在那一首时用index === controller.currentIndex
        //MouseArea点击歌曲时用controller.playSong(index)
        //需要把当前ListView的index传过去，来支持相互绑定
        ListView{
            id: currentView
            width: parent.width
            height: parent.height - subBar.height

            y: subBar.height
            spacing: 5
            clip: true
            visible:true
            model: currentModel
            currentIndex:control.currentIndex
            delegate: Rectangle {
                id: single
                radius: 12
                width: currentView.width
                height: 40
                color: index === currentIndex ? Qt.rgba(0.106, 0.553, 0.788, 0.8) : index % 2 == 0 ? Qt.rgba(0.95,0.95,0.95,1) : Qt.rgba(0.85,0.85,0.85,1)
                property color preColor: index === currentIndex ? Qt.rgba(0.106, 0.553, 0.788, 0.8) : index % 2 == 0 ? Qt.rgba(0.95,0.95,0.95,1) : Qt.rgba(0.85,0.85,0.85,1)

                Text {
                    id:titletxt
                    text: title
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    elide: Text.ElideRight
                    width: Math.floor(parent.width * 0.5)
                    color: Qt.rgba(0.15,0.15,0.15,1)
                    font.pixelSize: 14
                }
                Text {
                    id:artisttxt
                    text: artist
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 25
                    elide: Text.ElideRight
                    width: Math.floor(parent.width * 0.3)
                    color: Qt.rgba(0.2,0.2,0.2,1)
                    font.pixelSize: 12
                }
                Image {
                    id: removeFromCurrentButton
                    visible: false
                    source: "qrc:/control/image/remove.png"
                    anchors.right: single.right
                    anchors.rightMargin: 5 + (single.width - 300) * 0.1
                    anchors.verticalCenter: single.verticalCenter
                    width: 28
                    height: 28
                }

                MouseArea {
                    id: singleFullArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        control.currentIndex = index
                        control.playSong(index)
                    }

                }

                MouseArea {
                    id: removeFromCurrentButtonArea
                    anchors.fill: removeFromCurrentButton
                    onClicked: {
                        removeSongInCurrentModel(index)
                    }
                }
                Connections {
                    target: singleFullArea
                    function onEntered() {
                        removeFromCurrentButton.visible = true
                        single.color = index === currentIndex ? Qt.rgba(0.106, 0.553, 0.788, 0.8) : Qt.rgba(0.1,0.5,0.8,0.5)
                    }
                    function onExited() {
                        removeFromCurrentButton.visible = false
                        single.color = index === currentIndex ? Qt.rgba(0.106, 0.553, 0.788, 0.8) : index % 2 == 0 ? Qt.rgba(0.95,0.95,0.95,1) : Qt.rgba(0.85,0.85,0.85,1)
                        single.color = Qt.binding(function() {return index === currentIndex ? Qt.rgba(0.106, 0.553, 0.788, 0.8) : index % 2 == 0 ? Qt.rgba(0.95,0.95,0.95,1) : Qt.rgba(0.85,0.85,0.85,1) })
                    }
                }

            }
            ScrollBar.vertical: ScrollBar {}
        }

        // {
        //     currentModel.clearMusic()
        //     currentModel.clearCount()
        onOpened: {
            control.opened()
            control.state = "open"
        }

        onClosed: {
            control.closed()
            control.state = "close"
        }
    }



    //更新currentList
    function updateCurrentList() {
        currentList = []; // 清空当前列表
        //console.log("更新列表")
        //console.log(currentModel.getCount())
        //console.log("count = ", currentModel.getCount())
        for (var i = 0; i < currentModel.getCount(); i++) {
            var ind = currentModel.createModelIndex(i,0)
            var sourcePath = "file://" + currentModel.data(ind, MusicModel.FilePathRole)
            currentList.push(sourcePath);
            //console.log(currentModel.data(ind, MusicModel.DurationRole))
        }
        if (currentList.length > 0) {
            if (currentIndex < 0 || currentIndex >= currentList.length) {
                currentIndex = 0
            }
        }else {
            currentIndex = -1
        }
    }

    // Connections {
    //     target: currentModel
    //     onCurrentIndexChanged: updateCurrentList()
    // }

    //自动播放下一首
    function autoPlay(){
        if (musicplayer.player.mediaStatus === MediaPlayer.EndOfMedia) {
            //console.log("自动下一首");
            nextSong();
        }
    }

    //控制播放和暂停逻辑
    function playpause(){
        if (musicplayer.player.playbackState === MediaPlayer.PlayingState) {
            musicplayer.pause();
            //console.log("pause()")
        } else {
            musicplayer.play();
            //console.log("play()")
        }
    }

    //列表点击时可以播放歌曲
    function playSong(index){
        if (playMode === 1) {
            addToHistory(currentIndex);
        }
        musicplayer.player.source = currentList[index]
        //console.log("index", index)
        currentIndex=index
        musicplayer.player.position=0
        musicplayer.player.play();
    }


    //播放下一首逻辑
    function nextSong() {
        //console.log("下一首")

        if (currentList.length === 0) return;
        if(playMode===0){
            sequentialPlay()
        }if(playMode===1){
            addToHistory(currentIndex)
            randomPlay();
        }if(playMode===2){
            singleLoop()
        }

    }

    // 播放上一首逻辑
    function prevSong() {
        // if (playHistory.length === 0) return;


        if(playMode === 0){
            currentIndex = (currentIndex - 1 + currentList.length) % currentList.length;
            changeSong();
        }

        if(playMode === 1){
            var prevIndex = popHistory();
            if (prevIndex >= 0 && prevIndex < currentList.length) {
                //console.log("shangyishou")
                isNavigatingHistory = true;
                currentIndex = prevIndex;
                changeSong();
                isNavigatingHistory=false;
            } else {
                //console.log("如果再点击上一首会循环播放")
                singleLoop();
            }

        }if (playMode === 2) {
            singleLoop();
        }
    }

    //顺序播放逻辑
    function sequentialPlay(){
        currentIndex = (currentIndex + 1) % currentList.length;
        changeSong();
    }

    //随机播放逻辑
    function randomPlay() {
        var newIndex;
        do {
            newIndex = Math.floor(Math.random() * currentList.length);
        } while (newIndex === currentIndex && currentList.length > 1);
        currentIndex = newIndex;
        changeSong();
    }

    //单曲循环逻辑
    function singleLoop() {
        musicplayer.player.position=0
        musicplayer.play();
    }

    //更新当前播放顺序到Player的Source
    function changeSong() {
        musicplayer.source = currentList[control.currentIndex];
        //console.log("change song")
        musicplayer.player.position=0
        musicplayer.play();
    }

    function addToHistory(index) {
        if (playMode !== 1) return;

        if (playHistory.length === 0 || playHistory[playHistory.length - 1] !== index) {
            playHistory.push(index);
            // historyPointer = playHistory.length - 1;
            //console.log("加入一首歌到历史:", index);

            if (playHistory.length > 100) {
                playHistory.shift();
            }
        }
    }

    function popHistory(){
        if (playHistory.length > 0) {
            return playHistory.pop();
        }
        return -1;
    }

    onPlayModeChanged: {
        if (playMode !== 1) {
            clearHistory();
        }
    }

    function clearHistory() {
        playHistory = [];
        //console.log("历史记录已清空");
    }
}


