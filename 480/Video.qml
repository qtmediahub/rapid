import QtQuick 1.0

Window {
    id: root
    Text { anchors.centerIn: parent; text: "Video"; font.pointSize: 80; color: "red" }

//    Engine { name: qsTr("Video"); role: "video"; visualElement: root }
    Component.onCompleted: {
        videoEngine.visualElement = root
    }
}
