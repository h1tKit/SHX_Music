import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MyModel
Item {
    id:favoritePage
    visible: false

    property  var filePathTxt:"../../data/favoriteMusic.txt"
    property var musicplayer
    property var favoriteIndex: -1

    property alias musicModel: musicModel

    property var selectedList: []

    signal addToCurrentModelbyDbc(var dbcrequestPath)
    signal addToCurrentModelbyBtn(var btnrequestPath)
    signal removeLoveModelbyBtn(var removeLoverequestPath)

    signal playAllPage()

    state: "singleOp"

    states: [
        State {
            name: "singleOp"
        },
        State {
            name: "multiOp"
        }
    ]

    onStateChanged: {
        if(state === "singleOp") {
            addToCurrentButtonInBar.visible = false
            deleteButtonInBar.visible = false
        }else {
            addToCurrentButtonInBar.visible = true
            deleteButtonInBar.visible = true
        }

    }

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

        SearchBar {
            anchors.left:titleText.right
            anchors.leftMargin: 100 + (favoritePage.width - 800) * 0.1
            height: 30
            width: 300 + (favoritePage.width - 800) * 0.1
            anchors.verticalCenter:parent.verticalCenter
            onTextChanged: musicModel.search(text)
        }

        RoundRectangleButton {
            id: addToCurrentButtonInBar
            visible: false
            width: 30
            height: 30
            anchors.right: deleteButtonInBar.left
            anchors.rightMargin: 10
            anchors.verticalCenter: titleBackground.verticalCenter

            Image {
                id: addToCurrentButtonInBarIcon
                source: "qrc:/control/image/add.png"
                anchors.fill: parent
            }
        }
        RoundRectangleButton {
            id: deleteButtonInBar
            visible: false
            width: 30
            height: 30
            anchors.right: opButton.left
            anchors.verticalCenter: titleBackground.verticalCenter
            anchors.rightMargin: 50

            Image {
                id: deleteButtonInBarIcon
                source: "qrc:/control/image/remove.png"
                anchors.fill: parent
            }
        }

        RoundRectangleButton {
            id: opButton
            anchors.right: parent.right
            anchors.rightMargin: 40
            anchors.verticalCenter: parent.verticalCenter
            width: 30
            height: 30
            radius: 8

            onTapped: {
                editDialog.open()
            }

            Image {
                id: opIcon
                source: "qrc:/control/image/menu_edit.png"
                anchors.fill: parent
            }
        }
    }


    Dialog {
        id: editDialog

        signal multiOp()
        signal playAll()

        width: 120
        height: 41

        x: parent.width - width - 30
        y: subTitleBar.height + 20

        // onAccepted: console.log("Ok clicked")
        // onRejected: console.log("Cancel clicked")

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
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        width: 120
                        height: 40

                        onTapped: {
                            favoritePage.playAllPage()
                            editDialog.playAll()
                        }

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
                        color: Qt.rgba(0.2,0.2,0.2,1)
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

        Text {
            id: title
            text: qsTr("音乐标题")
            color: Qt.rgba(0.3,0.3,0.3,1)
            font.pixelSize: 14
            anchors.left: parent.left
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

        ScrollBar.vertical: ScrollBar {}

        delegate: Rectangle {
            id: single
            height: 40
            width: localListView.width
            color: index % 2 === 1 ? Qt.rgba(0.95,0.95,0.95,1) : Qt.rgba(0.9,0.9,0.9,1)

            property color originalColor: index % 2 === 1 ? Qt.rgba(0.95,0.95,0.95,1) : Qt.rgba(0.9,0.9,0.9,1)

            required property var title
            required property var artist
            required property var duration
            required property var filePath
            required property var index

            Text {
                id: indexText
                text: (index + 1).toString()
                color: Qt.rgba(0.4,0.4,0.4,1)
                font.pixelSize: 14
                anchors.left: single.left
                anchors.leftMargin: 12
                anchors.verticalCenter: single.verticalCenter
            }

            Text {
                id: singleTitleText
                text: title
                color: Qt.rgba(0.2,0.2,0.2,1)
                font.pixelSize: 14
                anchors.left: single.left
                anchors.leftMargin: 60
                anchors.verticalCenter: single.verticalCenter
                elide: Text.ElideRight
                width: 200
            }
            Text {
                id: singleArtistText
                text: artist
                color: Qt.rgba(0.4,0.4,0.4,1)
                anchors.horizontalCenter: single.horizontalCenter
                anchors.horizontalCenterOffset: -30
                anchors.verticalCenter: single.verticalCenter
                elide: Text.ElideRight
                width: 200
                horizontalAlignment: Text.AlignHCenter  // 文本水平居中
            }
            Text {
                id: singleDurationText
                text: formatTime(duration)
                color: Qt.rgba(0.4,0.4,0.4,1)
                anchors.right: single.right
                anchors.rightMargin: 60
                anchors.verticalCenter: single.verticalCenter
            }


            RoundRectangleButton {
                id: addToCurrentButton
                visible: false
                width: 30
                height: 30
                radius: 8
                anchors.right: deleteButton.left
                anchors.rightMargin: 10
                anchors.verticalCenter: single.verticalCenter

                Image {
                    id: addToCurrentButtonIcon
                    source: "qrc:/control/image/add.png"
                    anchors.fill: parent
                }

                TapHandler {
                    id: addToCurrentButtonArea
                    onTapped: {
                        favoriteIndex = index
                        addToCurrentModelbyBtn(musicModel.data(musicModel.createModelIndex(favoriteIndex), MusicModel.FilePathRole))
                    }
                }
            }
            RoundRectangleButton {
                id: deleteButton
                visible: false
                width: 30
                height: 30
                radius: 8
                anchors.right: singleDurationText.left
                anchors.verticalCenter: single.verticalCenter
                anchors.rightMargin: 50

                Image {
                    id: deleteButtonIcon
                    source: "qrc:/control/image/remove.png"
                    anchors.fill: parent
                }

                TapHandler {
                    id: deleteButtonArea
                    onTapped:{
                        favoriteIndex = index
                        removeLoveModelbyBtn(musicModel.data(musicModel.createModelIndex(favoriteIndex), MusicModel.FilePathRole))
                    }
                }
            }
            Rectangle {
                id: singleSelectedMark
                visible: false
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
                    }else {
                        var i = selectedList.indexOf(filePath)
                        if (i !== -1) {
                            selectedList.splice(i, 1)
                        }
                    }
                }
            }

            Connections {
                target: favoritePage
                function onStateChanged() {
                    if (favoritePage.state === "singleOp") {
                        addToCurrentButtonArea.enabled = true
                        deleteButtonArea.enabled = true

                        clickToPlayLeftArea.enabled = true
                        clickToPlayRightArea.enabled = true
                        clickToPlayFullArea.enabled = false

                        singleSelectedMark.visible = false

                    }else {
                        addToCurrentButtonArea.enabled = false
                        deleteButtonArea.enabled = false

                        clickToPlayLeftArea.enabled = false
                        clickToPlayRightArea.enabled = false
                        clickToPlayFullArea.enabled = true

                        singleSelectedMark.visible = true

                    }
                }
            }

            HoverHandler {
                id: fullHover
                onHoveredChanged: {
                    if(hovered){
                        single.color = Qt.rgba(0.8,0.8,0.8,1)
                        // "singleOp" show 2 button
                        if (localPage.state === "singleOp") {
                            addToCurrentButton.visible = true
                            deleteButton.visible = true
                        }else {
                            // addToCurrentButtonArea.enabled = false
                            // deleteButtonArea.enabled = false
                        }///////////////////////////////////////////
                    }else {
                        single.color = single.originalColor
                        // "multiOp" hide 2 button
                        //if (localPage.state === "multiOp")
                        addToCurrentButton.visible = false
                        deleteButton.visible = false
                    }
                }
            }


            //TODO : put below into a function ( onClicked\ onDoubleClicked

            Item {
                id: clickToPlayFullArea
                enabled: false
                anchors.fill: single

                TapHandler {
                    onTapped: {
                        singleSelectedMark.state = singleSelectedMark.state === "selected" ? "unselected" : "selected"
                    }
                }
            }

            Item {
                id: clickToPlayLeftArea
                anchors.top: single.top
                anchors.bottom: single.bottom
                anchors.right: addToCurrentButton.left
                anchors.left: single.left

                TapHandler {
                    onTapped: {

                    }
                    onDoubleTapped: {
                        favoriteIndex = index
                        addToCurrentModelbyDbc(musicModel.data(musicModel.createModelIndex(favoriteIndex), MusicModel.FilePathRole))
                    }
                }
            }

            Item {
                id: clickToPlayRightArea
                anchors.top: single.top
                anchors.bottom: single.bottom
                anchors.right: single.right
                anchors.left: deleteButton.right

                TapHandler {
                    onTapped: {

                    }
                    onDoubleTapped: {
                        favoriteIndex=index
                        addToCurrentModelbyDbc(musicModel.data(musicModel.createModelIndex(favoriteIndex), MusicModel.FilePathRole))
                    }
                }
            }
        }
    }




    function searchByloveModel(musicPath){
        for(var i = 0; i < favoritePage.musicModel.getCount(); i++) {
            if (favoritePage.musicModel.data(favoritePage.musicModel.createModelIndex(i,0), MusicModel.FilePathRole) === musicPath) {
                return i;   //found
            }else {
                //console.log(favoritePage.musicModel.data(favoritePage.musicModel.createModelIndex(i,0), MusicModel.FilePathRole))
                //console.log(musicPath)
                continue;  //not found
            }
        }
        //console.log("notFound")
        return -1;
    }

    function insertSongToLast(musicpath){
        favoritePage.musicModel.loadFromFileAsync(musicpath,filePathTxt)

        var newIndex = searchByloveModel(musicpath)
        if(newIndex !== -1&&favoritePage.musicModel.data(favoritePage.musicModel.createModelIndex(newIndex), MusicModel.IsLoveRole)===false){
            favoritePage.musicModel.changeIsLove(newIndex)
        }
    }



    function removeLoveModel(musicIndex){
        if(musicIndex!==-1){
            favoritePage.musicModel.changeIsLove(musicIndex)
            favoritePage.musicModel.removeMusic(musicIndex)
        }
    }



    function initfavoriteModel(filePathTxt){
        console.log("FavoriteModel初始化开始")
        MusicPathOperations.OperationTxt(filePathTxt)
        console.log("FavoriteModel Length ", MusicPathOperations.pathList.length)
        for(var i = 0; i < MusicPathOperations.pathList.length; i++){
            musicModel.loadFromFileAsync(MusicPathOperations.pathList[i],filePathTxt)
        }
    }

    function formatTime(milliseconds) {
        if (!milliseconds || milliseconds <= 0)
            return "00:00"

        var totalSeconds = milliseconds
        var minutes = Math.floor(totalSeconds / 60.0)
        var seconds = totalSeconds % 60
        //
        return minutes.toString().padStart(2, '0') +
                ":" +
                seconds.toString().padStart(2, '0')
    }

    Component.onCompleted: {
        favoritePage.update()
    }
}
