import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
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
                viewArea.initLocalModel("/run/media/root/data/Qt/shixun/SHX_Music/data/localMusic.txt")
                favoritePage.initLocalModel("/run/media/root/data/Qt/shixun/SHX_Music/data/favoriteMusic.txt")
            }

            onOpenLocalList: {
                viewArea.visible=true
                favoritePage.visible=false
            }

            onOpenLoveList: {
                viewArea.visible=false
                favoritePage.visible=true
            }
        }

        LocalPage {
            id: viewArea        //right top area
            musicplayer: player1
            controller: control

            Layout.fillWidth: true
            Layout.fillHeight: true

            onAddToCurrentModel: {
                var i = control.searchSong(requestPath)
                if(i===-1){
                    // control.InsertCurrentModel()
                }else{
                    control.jumpToSong(i)
                    var modelIndex =viewArea.musicModel.createModelIndex(currentIndex,0);
                    var path = "file://" + viewArea.musicModel.data(modelIndex, viewArea.musicModel.FilePathRole)
                    musicplayer.source = path
                    musicplayer.player.position=0
                    musicplayer.play()
                    // addToHistory(currentIndex);
                }
            }
        }

        FavoritePage{
            id:favoritePage
            musicplayer:player1
            controller: control

            Layout.fillWidth: true
            Layout.fillHeight: true

            onAddToCurrentModel: {
                var i = control.searchSong(requestPath)
                if(i===-1){
                    // control.InsertCurrentModel()
                }else{
                    control.jumpToSong(i)
                    var modelIndex =favoritePage.musicModel.createModelIndex(favoriteIndex,0);
                    var path = "file://" + favoritePage.musicModel.data(modelIndex, favoritePage.musicModel.FilePathRole)
                    musicplayer.source = path
                    musicplayer.player.position=0
                    musicplayer.play()
                    // addToHistory(favoriteIndex);
                }
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
