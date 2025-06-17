import QtQuick
import QtQuick.Controls

// Item{

// }

Item {
    //喜欢列表，需要xys提供接口
    property var favoriteList:[]
    property int favoriteIndex:0
    // property var currentList: []
    // property int currentIndex: 0

    property bool isfavorite: false //true- 当前喜欢，false-当前不喜欢

    signal favoritetriggerd(bool isFavorite)//收藏状态切换时触发

    // 计算属性确保安全的songPath获取
        readonly property string currentSongPath:
            (currentList && currentList.length > currentIndex && currentIndex >= 0)
            ? currentList[currentIndex]
            : ""

    //触发喜欢按钮
    function judgefavorite(){
        if (!currentSongPath) {
            console.warn("Invalid song path");
            return;
        }

        if(isfavorite){
            addToFavorites(currentSongPath)
        }else{
            removeFromFavorites(currentSongPath)
        }
        favoritetriggerd(isfavorite)
    }


    // //添加喜欢
    function addToFavorites(songPath) {
        if (!favoriteList.includes(songPath)) {
            favoriteList.push(songPath);
            favoriteList = favoriteList.slice();
            favoriteIndex++
            isfavorite=true//update
            // updateFavoriteButton();
        }
    }

    //取消喜欢
    function removeFromFavorites(songPath) {
        var index = favoriteList.indexOf(songPath);
        if (index !== -1) {
            favoriteList.splice(index, 1);
            favoriteList = favoriteList.slice();
            favoriteIndex--
            isfavorite=false//update
            // updateFavoriteButton();
            if (favoriteList.length === 0) {
                console.log("当前没有喜欢歌曲，已清空收藏列表");
            }
        }
    }



}
