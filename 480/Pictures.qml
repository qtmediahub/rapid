import QtQuick 1.0

Window {
    id: root
    Text { anchors.centerIn: parent; text: "Pictures"; font.pointSize: 80; color: "red" }
//    Engine { name: qsTr("Pictures"); role: "picture"; visualElement: root }

    Component.onCompleted: {
        pictureEngine.visualElement = root
    }
}
