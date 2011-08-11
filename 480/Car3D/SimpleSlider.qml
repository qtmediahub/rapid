import QtQuick 1.1

Rectangle {
    id: root
    
    width: 180
    height: 26

    property real value: 1- ((slider.x - 2.0) / (root.width - 32.0 - 2.0))
    property bool hovered: false
    
    gradient: Gradient {
        GradientStop { position: 0.0; color: "gray" }
        GradientStop { position: 1.0; color: "white" }
    }
    radius: 8; opacity: 0.7; smooth: true
    Rectangle {
        id: slider
        x: root.width - 32; y: 1; width: 30; height: 24
        radius: 6; smooth: true
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#424242" }
            GradientStop { position: 1.0; color: "black" }
        }
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            drag.target: parent; drag.axis: "XAxis"; drag.minimumX: 2; drag.maximumX: root.width - 32
            onEntered: hovered = true
            onExited: hovered = false
            onPressed: { console.log(root.value) }
        }
    }
}
