import QtQuick
import QtQuick.Layouts

Item {
    id: root

    ColumnLayout {
        id: column
        anchors.fill: parent
        spacing: 0

        Item {
            id: subTitleBackground
            Layout.preferredHeight: 50
            Layout.fillWidth: true

            Text {
                id: subTitleText
                text: qsTr("本地音乐")
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Rectangle {
            id: line
            color: Qt.rgba(0.85,0.85,0.85,1)
            width: 1
            Layout.fillWidth: true
        }

    }
}
