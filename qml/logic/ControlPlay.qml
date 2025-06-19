import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia
import MyModel

//控制音乐上一首和暂停播放下一首有关的逻辑

Item {
    id:control
    //这个当前播放列表记录路径位置，需要xys提供接口

    property alias playdialog: __playDialog

    property var addMusicPath

    property var musicplayer
    property var currentList: []
    property int currentIndex: -1//: currentView.currentIndex > 0 ? 0 : -1  //初始化时绑定到count

    property int playMode: 0 // 0-顺序 1-随机 2-单曲循环

    property var playHistory: []

    //不需要了
    // property int historyPointer: -1 // 当前在历史记录中的位置
    property bool isNavigatingHistory: false // 是否正在导航历史记录

    property var filePath: "/run/media/root/data/Qt/shixun/SHX_Music/data/currentMusic.txt"

    function initCurrentModel(filePath) {console.log("22222222",control.filePath)
        MusicPathOperations.OperationTxt(control.filePath)
        for(var i = 0; i < MusicPathOperations.pathList.length; i++){
            currentModel.loadFromFile(MusicPathOperations.pathList[i])
            // currentModel.setCount()
        }
        //连接信号
        updateCurrentList();
        if (currentModel.getCount() > 0) {
            currentIndex = 0  // 设置为第一首
            musicplayer.source = currentList[0]  // 预加载第一首
            console.log("默认加载第一首:", currentList[0])
        }
        musicplayer.player.mediaStatusChanged.connect(autoPlay)
    }

    function addToCurrent(addMusicPath) {
        currentModel.loadFromFile(addMusicPath)
        // currentModel.setCount()
    }

    function searchSong(musicPath) {
        for(var i = 0; i < currentModel.getCount(); i++) {
            if (currentModel.data(currentModel.createModelIndex(i,0), MusicModel.FilePathRole) === musicPath) {
                console.log("Found")
                return i;   //found
            }else {
                console.log("notFound")
                console.log(currentModel.data(currentModel.createModelIndex(i,0), MusicModel.FilePathRole))
                console.log(musicPath)
                continue;  //not found
            }
        }
        return -1
    }

    function jumpToSong(index) {
        currentView.currentIndex = index;
        control.currentIndex = index;
    }

    function insertSongToNext(musicPath) {
        currentModel.insertMusic(currentIndex,musicPath)
        console.log("my currentIndex is ",currentIndex)
        // currentIndex++
        updateCurrentList();

        currentView.update()
        currentIndex++; // 明确移动到插入的歌曲位置
        currentView.positionViewAtIndex(currentIndex, ListView.Center); // 确保视图滚动到正确位置
        currentView.forceLayout();  // 强制重新布局
        currentView.currentIndex = currentIndex;  // 显式设置当前索引
        console.log("my currentIndex is ",currentIndex)

        // currentIndex=currentView.index

    }

    MusicModel {
        id: currentModel
    }

    Rectangle {
        id:__playDialog
        //在上一级设置（Window）这里是试验
        width: 200
        height: 400
        x: parent.width - width - 30  // 10 是右边距
        y: parent.height - height - 100 // 10 是底部边距
        parent: Overlay.overlay


        //三个点来适配，
        //model用playlistModel
        //判断正在那一首时用index === controller.currentIndex
        //MouseArea点击歌曲时用controller.playSong(index)
        //需要把当前ListView的index传过去，来支持相互绑定
        ListView{
            id: currentView
            anchors.fill: parent
            spacing: 5
            clip: true
            visible:true
            model: currentModel
            currentIndex:control.currentIndex
            delegate: Rectangle {
                width: ListView.view.width
                height: 40
                color: index === currentIndex ? "#87CEEB" : "transparent"

                Text {
                    id:titletxt
                    text: title
                    anchors.top: parent.top
                    anchors.topMargin:5
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    elide: Text.ElideRight
                    width: parent.width - 20
                    color: "black"
                    font.pixelSize: 12
                }
                Text {
                    id:artisttxt
                    text: artist
                    anchors.top: titletxt.bottom
                    anchors.topMargin:5
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    elide: Text.ElideRight
                    width: parent.width - 20
                    color: "black"
                    font.pixelSize: 10
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        control.currentIndex = index
                        control.playSong(index)
                    }
                }
            }
            ScrollBar.vertical: ScrollBar {}
        }

        // {
        //     currentModel.clearMusic()
        //     currentModel.clearCount()
        // }
    }

    onCurrentIndexChanged:{
        if (currentIndex >= 0 && currentIndex < currentModel.getCount()&& !isNavigatingHistory) {
            //changeSong()
            currentView.currentIndex = currentIndex
            addToHistory(currentIndex);
        }
    }

    Component.onDestruction: {
        //断开信号
        musicplayer.player.mediaStatusChanged.disconnect(autoPlay)

    }

    //更新currentList
    function updateCurrentList() {
        currentList = []; // 清空当前列表
        console.log("更新列表")
        console.log(currentModel.getCount())
        console.log("count = ", currentModel.getCount())
        for (var i = 0; i < currentModel.getCount(); i++) {
            var ind = currentModel.createModelIndex(i,0)
            var sourcePath = "file://" + currentModel.data(ind, MusicModel.FilePathRole)
            currentList.push(sourcePath);
            console.log(currentModel.data(ind, MusicModel.DurationRole))
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
            console.log("自动下一首");
            nextSong();
        }
    }

    //控制播放和暂停逻辑
    function playpause(){
        if (musicplayer.player.playbackState === MediaPlayer.PlayingState) {
            musicplayer.pause();
            console.log("pause()")
        } else {
            musicplayer.play();
            console.log("play()")
        }
    }

    //列表点击时可以播放歌曲
    function playSong(index){
        if (playMode === 1) {
            addToHistory(currentIndex); // 保存当前歌曲到历史
        }
        musicplayer.player.source = currentList[index]
        console.log("index", index)
        currentIndex=index
        musicplayer.player.play();
    }


    //播放下一首逻辑
    function nextSong() {
        console.log("下一首")


        if (currentList.length === 0) return;
        if(playMode===0){
            sequentialPlay()
        }if(playMode===1){
            //将当前歌曲压入历史栈
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
            // 随机模式 - 使用历史记录
            var prevIndex = popHistory();
            if (prevIndex >= 0 && prevIndex < currentList.length) {
                currentIndex = prevIndex;
                changeSong();
            } else {
                // 没有历史记录时保持当前歌曲
                console.log("如果再点击上一首会循环播放")
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
        musicplayer.play();
    }

    // 添加到历史记录
    function addToHistory(index) {
        if (playMode !== 1) return;

        // 避免重复添加相同的索引
        if (playHistory.length === 0 || playHistory[playHistory.length - 1] !== index) {
            playHistory.push(index);
            // historyPointer = playHistory.length - 1;
            console.log("加入一首歌到历史:", index);

            if (playHistory.length > 100) {
                playHistory.shift(); // 移除最旧的记录
            }
        }

    }

    function popHistory(){
        if (playHistory.length > 0) {
            return playHistory.pop();
        }
        return -1; // 栈为空时返回无效索引
    }

    onPlayModeChanged: {
        if (playMode !== 1) {
            clearHistory();
        }
    }

    // 清空历史记录(切换模式)
    function clearHistory() {
        playHistory = [];
        console.log("历史记录已清空");
    }
}


