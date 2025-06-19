import QtQuick
import QtQuick.Controls
import MyModel
Item {
    id:favoritePage
    visible: false

    property  var filePathTxt:"../../data/favoriteMusic.txt"
    property var musicplayer
    property var favoriteIndex: -1

    property alias musicModel: musicModel

    property var selectedList: []

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
            text: qsTr("我的喜欢")
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
            anchors.right: parent.right
            anchors.rightMargin: 40
            anchors.verticalCenter: parent.verticalCenter
            width: 30
            height: 30

            Image {
                id: opIcon
                source: "qrc:/control/image/menu_edit.png"
                anchors.fill: parent
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
                    }

                onDoubleClicked: {
                    favoriteIndex=index
                    addToCurrentModel(musicModel.data(musicModel.createModelIndex(favoriteIndex), MusicModel.FilePathRole))
                }
            }
            //////////////////////////////////////////////
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
