/*
name : HSlider
version : 2.0
by huang kun

进度条用于计算占比的长度为 总长度-手柄宽度
value主要用来接收传入的值，用于外界改变进度条进度
dragValue是拖动进度条到某值，用于反馈给外界
*/

import QtQuick

Item {
    id: root

    signal draging()

    property bool isHandleHovered: false

    property real value: 0// : Math.round(handle.y / (un.height - handle.height) * (to - from) + from)
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
            radius: parent.radius

            height: (root.value - from)/(to - from) * (un.height - handle.height) //Qt.binding(function(){return handle.y + handle.height/2})

            color: Qt.rgba(1, 0.608, 0.137,1)
        }

        Rectangle {
            //进度条的“手柄？”
            id: handle
            anchors.horizontalCenter: un.horizontalCenter

            height: 16
            width: 16
            radius: 8

            color: "gray"
            Rectangle {
                id: central
                property real preScale : 1
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
            HoverHandler {
                id: handleHover
                onHoveredChanged: {
                    if(hovered){
                        root.isHandleHovered = true
                        central.scale = 1.2
                        central.preScale = 1.2
                    }else {
                        root.isHandleHovered = false
                        central.scale = 1
                        central.preScale = 1
                    }
                }
            }
            TapHandler {
                onPressedChanged: {
                    if(pressed){
                        central.scale = 0.7
                    }else {
                        central.scale = central.preScale
                    }
                }
            }

            DragHandler {
                id: drager
                target: handle
                yAxis.minimum: 0
                yAxis.maximum: un.height - handle.height
                dragThreshold: 0

                onActiveChanged: {
                    if(active){
                        root.draging()
                    }
                }
            }
            onYChanged: {
                //拖动handle影响dragValue输出
                track.height = Qt.binding(function(){return handle.y + handle.height/2})
                if(drager.active || unDragHandler.active || unPointHandler.active){
                    root.dragValue = Math.round(handle.y / (un.height - handle.height) * (root.to - root.from) + root.from)
                    draged(root.dragValue)
                }
            }
        }

        PointHandler {
            id: unPointHandler
            onActiveChanged: {
                if(active){
                    if(unPointHandler.point.position.y <= handle.height/2){
                        handle.y = 0
                    }else if(unPointHandler.point.position.y >= un.height - handle.height/2){
                        handle.y = un.height - handle.height
                    }else {
                        handle.y = unPointHandler.point.position.y - handle.height / 2
                    }
                }
            }
        }
        DragHandler {
            id: unDragHandler
            target: handle
            yAxis.minimum: 0
            yAxis.maximum: un.height - handle.height
            dragThreshold: 0

            onActiveChanged: {
                if(active){
                    root.draging()
                }
            }
        }
    }

    onValueChanged: {
        //外部输入value影响handle位置
        track.height = Qt.binding(function(){return handle.y + handle.height/2})
        handle.y = Qt.binding(function(){return (root.value - root.from) / (root.to - root.from) * (un.height - handle.height)})
    }

}

