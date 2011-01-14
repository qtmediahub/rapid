import QtQuick 1.0

Window {
    id: root
    Rectangle { anchors.fill: parent; color: "yellow" }
    Text { text: "Das ist ein anderer Text" }

    Engine { name: qsTr("Test 2"); role: "test2"; visualElement: root }
}
