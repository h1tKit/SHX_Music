/*
name : TSlider
version : 1.0
by huang kun

进度条用于计算占比的长度为 总长度-手柄宽度
value主要用来接收传入的值，用于外界改变进度条进度
dragValue是拖动进度条到某值，用于反馈给外界
*/

import QtQuick

Item {
    id: root
    property real value : Math.round(handle.y / (un.height - handle.height) * (to - from) + from)
    property real from
    property real to
    property real dragValue

    property alias doneColor: track.color
    property alias undoneColor: un.color
    property alias handleColor: handle.color
    property alias handleCentralColor: central.color
    property alias handle: handle

    signal draged(real setValue)

    Rectangle {
        //进度条的底，大小即为root的大小
        id: un

        anchors.fill: parent
        radius: parent.width/2
        color: "gray"

        Rectangle {
            //进度条当前已经经过的部分，即当前进度
            visible: true
            id: track

            width: parent.width
            radius: parent.width/2

            height: handle.y + handle.height/2

            color: Qt.rgba(1, 0.608, 0.137,1)
        }

        Rectangle {
            //进度条的“手柄？”
            id: handle
            anchors.horizontalCenter: un.horizontalCenter
            x: (root.value - root.from) / (root.to - root.from) * (un.height - handle.height)

            height: 16
            width: 16
            radius: 8

            color: "gray"
            Rectangle {
                id: central
                anchors.centerIn: parent
                height: 10
                width: 10
                radius: 5
                color: Qt.rgba(1, 0.608, 0.137,1)

                Behavior on scale {
                    NumberAnimation {
                        duration: 100
                        easing.type: Easing.OutInQuad
                    }
                }
            }
            MouseArea {
                id: centralMouseArea
                property real preScale : 1
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    central.scale = 1.2
                    preScale = 1.2
                }
                onExited: {
                    central.scale = 1
                    preScale = 1
                }
                onPressed: {
                    central.scale = 0.7
                }
                onReleased: {
                    central.scale = preScale
                }

                onMouseYChanged: {
                    if(pressed) {
                        if(mouseY + handle.y <= handle.height/2) {
                            handle.y = 0
                        }else if(mouseY + handle.y >= un.height - handle.height/2) {
                            handle.y = un.height - handle.height
                        }else {
                            handle.y = mouseY + handle.y - handle.height/2
                        }
                        track.height = handle.y + handle.height/2
                        //拖动handle影响dragValue输出
                        root.dragValue = Math.round(handle.y / (un.height - handle.height) * (root.to - root.from) + root.from)
                        draged(root.dragValue)
                    }
                }
            }
        }

        MouseArea {
            id: unMouseArea
            anchors.left: handle.left
            anchors.right: handle.right
            anchors.top: un.top
            anchors.bottom: un.bottom
            //propagateComposedEvents: true

            onPressed: {
                if(mouseY > handle.y && mouseY < handle.y + handle.height) {
                    central.scale = 0.7
                }
            }
            onReleased: {
                if(mouseY > handle.y && mouseY < handle.y + handle.height) {
                    central.scale = centralMouseArea.preScale
                }
            }

            onMouseYChanged: {
                if(mouseY <= handle.height/2) {
                    handle.y = 0
                }else if(mouseY >= un.height - handle.height/2) {
                    handle.y = un.height - handle.height
                }else {
                    handle.y = mouseY - handle.height/2
                }
                track.height = handle.y + handle.height/2
                //拖动handle影响dragValue输出
                root.dragValue = Math.round(handle.y / (un.height - handle.height) * (root.to - root.from) + root.from)
                draged(root.dragValue)
            }
        }
    }
    onValueChanged: {
        //外部输入value影响handle位置
        track.height = Qt.binding(function(){return handle.y + handle.height/2})
        handle.y = Qt.binding(function(){return (root.value - root.from) / (root.to - root.from) * (un.height - handle.height)})
    }

}

