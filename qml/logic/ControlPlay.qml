import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia

//控制音乐上一首和暂停播放下一首有关的逻辑

Item {
    id:control
    //这个当前播放列表记录路径位置，需要xys提供接口
    property ListModel playlistModel: model

    ListModel{
        id:model
        ListElement { filePath: "file:///root/tmp/海阔天空.mp3" }
        ListElement { filePath: "file:///root/tmp/Life_Is_Good_Alarm.ogg"}
        ListElement { filePath: "file:///root/tmp/Justin Timberlake-Five Hundred Miles.mp3" }
    }

    property var musicplayer
    property var currentList: []
    property int currentIndex: 0

    property int playMode: 0 // 0-顺序 1-随机 2-单曲循环

    property var playHistory: []
    property int historyPosition: -1 // 当前在历史记录中的位置

    onCurrentIndexChanged: changeSong()

    //组件建立监听
    Component.onCompleted: {
        //连接信号
        updateCurrentList();
        console.log("更新")
        if (currentList.length > 0) {
            currentIndex = 0;
            musicplayer.player.source = currentList[currentIndex];
                }
        musicplayer.player.mediaStatusChanged.connect(autoPlay)
    }
    Component.onDestruction: {
        //断开信号
        musicplayer.player.mediaStatusChanged.disconnect(autoPlay)

     }

    function updateCurrentList() {
            currentList = []; // 清空当前列表
            console.log("更新列表")
            for (var i = 0; i < playlistModel.count; i++) {
                currentList.push(playlistModel.get(i).filePath);
            }
        }
    Connections {
        target: playlistModel
        onCountChanged: updateCurrentList()
    }



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
           musicplayer.player.pause();
        } else {
            musicplayer.player.play();
            console.log("play()")
        }
    }


    //播放下一首逻辑
    function nextSong() {
        console.log("下一首")
        //随机模式需要记录历史记录
        if (playMode === 1) {
            addToHistory(currentIndex);
        }

        if (currentList.length === 0) return;
            if(playMode===0){
                sequentialPlay()
            }if(playMode===1){
                randomPlay()
            }if(playMode===2){
                singleLoop()
            }

    }

    // 播放上一首逻辑
        function prevSong() {
            if (currentList.length === 0) return;

            if (playMode === 1) {
                // 随机模式下使用历史记录（后进先出）
                if (playHistory.length > 0) {
                    // 如果当前歌曲是新播放的（不在历史记录末尾）
                    if (historyPosition < playHistory.length - 1) {
                        // 将当前播放的歌曲加入历史（以便能再次回到这里）
                        addToHistory(currentIndex);
                    }
                    // 取出上一首
                    if (playHistory.length > 0) {
                        currentIndex = playHistory.pop();
                        historyPosition = playHistory.length - 1;
                        changeSong();
                    }else if (historyPosition === 0) {
                    // 已经在最早的历史记录，单曲循环
                    singleLoop()
                    }
                }
            } if(playMode===0) {
                currentIndex = (currentIndex - 1 + currentList.length) % currentList.length;
                changeSong();
            }if(playMode===2){
                singleLoop()
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
        musicplayer.player.play();
    }

    //更新当前播放顺序到Player的Source
    function changeSong() {
        musicplayer.player.source = currentList[currentIndex];
        musicplayer.player.play();
     }

    // 添加到历史记录
    function addToHistory(index) {
        // 如果当前位置不是历史记录末尾，则截断后面的记录(不一定要)
        // if (historyPosition < playHistory.length - 1) {
        //     playHistory = playHistory.slice(0, historyPosition + 1);
        // }

        // 添加新记录
        playHistory.push(index);
        historyPosition = playHistory.length - 1;

        // 限制历史记录长度(不一定要)
        // if (playHistory.length > 50) {
        //     playHistory.shift();
        //     historyPosition--;
        // }
    }




}


