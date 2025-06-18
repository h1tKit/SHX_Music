import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

Item {
    property var controller

    property alias playdialog: __playDialog


    Dialog{
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
            anchors.fill: parent
            spacing: 5
            clip: true
            visible:true
            model:controller.playlistModel
            delegate: Rectangle {
                   width: ListView.view.width
                   height: 40
                   color: index === controller.currentIndex ? "#87CEEB" : "transparent"

                   Text {
                       id:titletxt
                       text: title
                       anchors.top: parent.top
                       anchors.topMargin:5
                       anchors.left: parent.left
                       anchors.leftMargin: 5
                       elide: Text.ElideRight
                       width: parent.width - 20
                       color: "white"
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
                       color: "white"
                       font.pixelSize: 10
                   }

                   MouseArea {
                       anchors.fill: parent
                       onClicked: controller.playSong(index)
                   }
               }
            ScrollBar.vertical: ScrollBar {}
        }
    }

}
