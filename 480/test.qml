import QtQuick 1.0

Window {
    id: root
    Rectangle { anchors.fill: parent; color: "green" }
    Text { text: "Das ist ein Text" }

    Engine { name: qsTr("Test 1"); role: "test"; visualElement: root }
}
