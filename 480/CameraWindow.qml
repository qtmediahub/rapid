import QtQuick 1.0
import QtMultimediaKit 1.1

Window {
    id: root
    Camera {
        anchors.fill: parent
    }

    Engine { name: qsTr("Rear Cam"); role: "camera"; visualElement: root }
}
