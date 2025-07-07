import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia
import MyModel

Item {
    id:localPage
    property bool isReady: false

    property var filePathTxt: "../../data/localMusic.txt"
    property var favoritefilePathTxt:"../../data/favoriteMusic.txt"
    property var currentIndex: -1
    property var deleteFiles: []

    property var musicplayer

    property alias musicModel: musicModel

    property var selectedList: []

    property var receivedData: [] //接受文件传过来的数据
    property var rootWindow: null // 用于接收 Window 的引用

    signal addToCurrentModelbyDbc(var dbcrequestPath)
    signal addToCurrentModelbyBtn(var btnrequestPath)
    signal addToLoveModel(var addloverequestPath)

    signal removeSongbyBtn(var removerequestPath)

    signal playAllPage()

    function updatePage() {
        localListView.update()
    }

    signal addMusic()

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
            addToLoveButtonInBar.visible = false
            addToCurrentButtonInBar.visible = false
            deleteButtonInBar.visible = false
        }else {
            addToLoveButtonInBar.visible = true
            addToCurrentButtonInBar.visible = true
            deleteButtonInBar.visible = true
        }

    }

    ////////////////////////////////////////////////////////////
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
            text: qsTr("本地音乐")
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
            anchors.leftMargin: 100 + (localPage.width - 800) * 0.1
            height: 30
            width: 300 + (localPage.width - 800) * 0.1
            anchors.verticalCenter:parent.verticalCenter
            onTextChanged: musicModel.search(text)
        }

        RoundRectangleButton {
            id: addToLoveButtonInBar
            visible: false
            width: 30
            height: 30
            anchors.right: addToCurrentButtonInBar.left
            anchors.rightMargin: 10
            anchors.verticalCenter: titleBackground.verticalCenter
            hoverBackgroundColor: "transparent"

            Image {
                id: addToLoveButtonInBarIcon
                source: "qrc:/control/image/love_add.png"
                anchors.fill: parent
            }
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
            anchors.right: addMusicsFromFolder.left
            anchors.rightMargin: 20
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

        RoundRectangleButton {
            id: addMusicsFromFolder
            anchors.right: parent.right
            anchors.rightMargin: 40
            anchors.verticalCenter: parent.verticalCenter
            width: 30
            height: 30
            radius: 8

            Image {
                id: addMusicIcon
                source: "qrc:/control/image/add_square.png"
                anchors.fill: parent
            }

            onTapped: {
                addMusic()
                console.log("addFolder")
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
                spacing: 0
                Item {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    id: playAllItem
                    RoundRectangleButton {
                        id: playAllButton
                        anchors.fill: parent
                        radius: 8

                        onTapped: {
                            localPage.playAllPage()
                            editDialog.playAll()
                        }

                        Image {
                            id: playAllIcon
                            source: "qrc:/control/image/musiclist.png"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            width: 24
                            height: 24
                        }
                    }
                    Text {
                        id: playAllText
                        text: qsTr("播放全部")
                        color: Qt.rgba(0.2,0.2,0.2,1)
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: 14
                        font.pixelSize: 14
                    }
                }
                Rectangle {
                    id: line
                    visible: false
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
            id: titleColumn
            text: qsTr("音乐标题")
            color: Qt.rgba(0.3,0.3,0.3,1)
            font.pixelSize: 14
            anchors.left: parent.left
            anchors.leftMargin: 60
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            id: artistColumn
            text: qsTr("歌手")
            color: Qt.rgba(0.3,0.3,0.3,1)
            font.pixelSize: 14
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: -30
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            id: durationColumn
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
        cacheBuffer: 80
        reuseItems: true

        Component.onCompleted: console.log("localView 初始化完毕")

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
                id: addToLoveButton
                visible: false
                width: 30
                height: 30
                radius: 8
                anchors.right: addToCurrentButton.left
                anchors.rightMargin: 10
                anchors.verticalCenter: single.verticalCenter

                Image {
                    id: addToLoveButtonIcon
                    source: "qrc:/control/image/love_add.png"
                    anchors.fill: parent
                }

                TapHandler {
                    id: addToLoveButtonArea
                    onTapped: {
                        localPage.currentIndex = index
                        localPage.addToLoveModel(musicModel.data(musicModel.createModelIndex(localPage.currentIndex), MusicModel.FilePathRole))
                    }
                }

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
                        localPage.currentIndex = index
                        localPage.addToCurrentModelbyBtn(musicModel.data(musicModel.createModelIndex(localPage.currentIndex), MusicModel.FilePathRole))
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
                    onTapped: {
                        localPage.currentIndex = index
                        localPage.removeSongbyBtn(musicModel.data(musicModel.createModelIndex(localPage.currentIndex), MusicModel.FilePathRole))
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
                target: localPage
                function onStateChanged() {
                    if (localPage.state === "singleOp") {
                        addToLoveButtonArea.enabled = true
                        addToCurrentButtonArea.enabled = true
                        deleteButtonArea.enabled = true

                        clickToPlayLeftArea.enabled = true
                        clickToPlayRightArea.enabled = true
                        clickToPlayFullArea.enabled = false

                        singleSelectedMark.visible = false

                    }else {
                        addToLoveButtonArea.enabled = false
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
                        // "singleOp" show 3 button
                        if (localPage.state === "singleOp") {
                            addToLoveButton.visible = true
                            addToCurrentButton.visible = true
                            deleteButton.visible = true
                        }else {
                            // addToLoveButtonArea.enabled = false
                            // addToCurrentButtonArea.enabled = false
                            // deleteButtonArea.enabled = false
                        }///////////////////////////////////////////
                    }else {
                        single.color = single.originalColor
                        // "multiOp" hide 3 button
                        //if (localPage.state === "multiOp")
                        addToLoveButton.visible = false
                        addToCurrentButton.visible = false
                        deleteButton.visible = false
                    }
                }
            }

            //TODO : put below into a function ( onClicked\ onDoubleClicked

            Item {
                id: clickToPlayFullArea
                enabled: false
                anchors.top: single.top
                anchors.bottom: single.bottom
                anchors.right: single.right
                anchors.left: single.left

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
                anchors.right: addToLoveButton.left
                anchors.left: single.left



                TapHandler {
                    onDoubleTapped: {
                        localPage.currentIndex = index
                        addToCurrentModelbyDbc(musicModel.data(musicModel.createModelIndex(localPage.currentIndex), MusicModel.FilePathRole))
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
                    onDoubleTapped: {
                        localPage.currentIndex = index
                        addToCurrentModelbyDbc(musicModel.data(musicModel.createModelIndex(localPage.currentIndex), MusicModel.FilePathRole))
                    }
                }
            }
        }
    }

    onAddMusic: {
        //FileOperaTions.selectMusicFiles()
    }

    function addMusicFolder(){

    }

    //function

    //1

    function searchBylocalModel(musicPath){
        for(var i = 0; i < localPage.musicModel.getCount(); i++) {
            if (localPage.musicModel.data(localPage.musicModel.createModelIndex(i,0), MusicModel.FilePathRole) === musicPath) {
                //console.log("Found in localPage")
                return i;   //found
            }else {
                //console.log("notFound in localPage")
                //console.log(localPage.musicModel.data(localPage.musicModel.createModelIndex(i,0), MusicModel.FilePathRole))
                //console.log(musicPath)
                continue;  //not found
            }
        }
        //console.log("notFound")
        return -1;
    }


    function removeSongbyLocalModel(musicIndex){
        localPage.musicModel.removeMusic(musicIndex)
    }

    function initLocalModel(filePathTxt){
        console.log("localModel 初始化开始")
        MusicPathOperations.OperationTxt(filePathTxt)
        for(var i = 0; i < MusicPathOperations.pathList.length; i++){
            musicModel.loadFromFileAsync(MusicPathOperations.pathList[i],favoritefilePathTxt)
        }
    }

    // function deleteMusic(filePath, deleteFiles){
    //     MusicPathOperations.DeletePathToTxt(filePathTxt, deleteFiles)
    // }





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

    Component.onCompleted:{
        //localPage.initLocalModel(filePathTxt)
        localListView.update()
        //console.log("localPage...")
        localPage.isReady = true
        if (rootWindow && rootWindow.dataReady) {  // 假设window是Sender.qml的实例
            rootWindow.dataReady.connect(handleData)
        }
        console.log("localPage 初始化完毕")
    }
    function handleData(data) {
        receivedData = data  // 保存接收到的数据
        console.log("接收到数据:", receivedData)
        // 处理接收到的数据
    }

    onReceivedDataChanged:{
        for(var i = 0; i < receivedData.length; i++){
            musicModel.loadFromFileAsync(receivedData[i],favoritefilePathTxt)
        }
    }
}
