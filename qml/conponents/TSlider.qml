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
    property real value : Math.round(handle.x / (un.width - handle.width) * (to - from) + from)
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
        radius: parent.height/2
        color: "gray"

        Rectangle {
            //进度条当前已经经过的部分，即当前进度
            visible: true
            id: track

            height: parent.height
            radius: parent.height/2

            width: handle.x + handle.width/2

            color: Qt.rgba(1, 0.608, 0.137,1)
        }

        Rectangle {
            //进度条的“手柄？”
            id: handle
            anchors.verticalCenter: un.verticalCenter
            x: (root.value - root.from) / (root.to - root.from) * (un.width - handle.width)

            height: 20
            width: 20
            radius: 10

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
                    central.scale = 1.4
                    preScale = 1.4
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

                onMouseXChanged: {
                    if(pressed) {
                        if(mouseX + handle.x <= handle.width/2) {
                            handle.x = 0
                        }else if(mouseX + handle.x >= un.width - handle.width/2) {
                            handle.x = un.width - handle.width
                        }else {
                            handle.x = mouseX + handle.x - handle.width/2
                        }
                        track.width = handle.x + handle.width/2
                        //拖动handle影响dragValue输出
                        root.dragValue = Math.round(handle.x / (un.width - handle.width) * (root.to - root.from) + root.from)
                        draged(root.dragValue)
                    }
                }
            }
        }

        MouseArea {
            id: unMouseArea
            anchors.fill: parent
            //propagateComposedEvents: true

            onPressed: {
                if(mouseX > handle.x && mouseX < handle.x + handle.width) {
                    central.scale = 0.7
                }
            }
            onReleased: {
                if(mouseX > handle.x && mouseX < handle.x + handle.width) {
                    central.scale = centralMouseArea.preScale
                }
            }

            onMouseXChanged: {
                if(mouseX <= handle.width/2) {
                    handle.x = 0
                }else if(mouseX >= un.width - handle.width/2) {
                    handle.x = un.width - handle.width
                }else {
                    handle.x = mouseX - handle.width/2
                }
                track.width = handle.x + handle.width/2
                //拖动handle影响dragValue输出
                root.dragValue = Math.round(handle.x / (un.width - handle.width) * (root.to - root.from) + root.from)
                draged(root.dragValue)
            }
        }
    }
    onValueChanged: {
        //外部输入value影响handle位置
        track.width = Qt.binding(function(){return handle.x + handle.width/2})
        handle.x = Qt.binding(function(){return (root.value - root.from) / (root.to - root.from) * (un.width - handle.width)})
    }

}

