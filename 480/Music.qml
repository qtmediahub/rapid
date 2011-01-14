import QtQuick 1.0

Window {
    id: root
    Text { anchors.centerIn: parent; text: "Music"; font.pointSize: 80; color: "red"}

//    Engine { name: qsTr("Music"); role: "music"; visualElement: root }
    Component.onCompleted: {
        musicEngine.visualElement = root
    }
}
