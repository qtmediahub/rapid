import QtQuick 1.0

Item {
    id: root

    property int gear: -1
    width: (g6.x+g6.width) - r.x
    height: 30

    property int fontPixelSize: 19

    Text { id: r;  text: "R"; anchors.left:root.left; anchors.leftMargin: 0; font.pixelSize: root.fontPixelSize; anchors.verticalCenter: parent.verticalCenter }
    Text { id: p;  text: "P"; anchors.left:  r.right; anchors.leftMargin: 8; font.pixelSize: root.fontPixelSize; anchors.verticalCenter: parent.verticalCenter }
    Text { id: n;  text: "N"; anchors.left:  p.right; anchors.leftMargin: 8; font.pixelSize: root.fontPixelSize; anchors.verticalCenter: parent.verticalCenter }
    Text { id: g1; text: "1"; anchors.left:  n.right; anchors.leftMargin: 8; font.pixelSize: root.fontPixelSize; anchors.verticalCenter: parent.verticalCenter }
    Text { id: g2; text: "2"; anchors.left: g1.right; anchors.leftMargin: 8; font.pixelSize: root.fontPixelSize; anchors.verticalCenter: parent.verticalCenter }
    Text { id: g3; text: "3"; anchors.left: g2.right; anchors.leftMargin: 8; font.pixelSize: root.fontPixelSize; anchors.verticalCenter: parent.verticalCenter }
    Text { id: g4; text: "4"; anchors.left: g3.right; anchors.leftMargin: 8; font.pixelSize: root.fontPixelSize; anchors.verticalCenter: parent.verticalCenter }
    Text { id: g5; text: "5"; anchors.left: g4.right; anchors.leftMargin: 8; font.pixelSize: root.fontPixelSize; anchors.verticalCenter: parent.verticalCenter }
    Text { id: g6; text: "6"; anchors.left: g5.right; anchors.leftMargin: 8; font.pixelSize: root.fontPixelSize; anchors.verticalCenter: parent.verticalCenter }

    Rectangle {
        id: gearRect
        smooth: true
        radius: 3
        color: "transparent"
        border.color: "white"
        border.width: 3

        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: p.horizontalCenter

        height: 23
        width: 20
    }

    states: [
        State { when: gear == -2; name: "R"
            AnchorChanges { target: gearRect; anchors.horizontalCenter: r.horizontalCenter }
        },
        State { when: gear == -1; name: "P"
            AnchorChanges { target: gearRect; anchors.horizontalCenter: p.horizontalCenter }
        },
        State { when: gear == 0; name: "N"
            AnchorChanges { target: gearRect; anchors.horizontalCenter: n.horizontalCenter }
        },
        State { when: gear == 1; name: "1"
            AnchorChanges { target: gearRect; anchors.horizontalCenter: g1.horizontalCenter }
        },
        State { when: gear == 2; name: "2"
            AnchorChanges { target: gearRect; anchors.horizontalCenter: g2.horizontalCenter }
        },
        State { when: gear == 3; name: "3"
            AnchorChanges { target: gearRect; anchors.horizontalCenter: g3.horizontalCenter }
        },
        State { when: gear == 4; name: "4"
            AnchorChanges { target: gearRect; anchors.horizontalCenter: g4.horizontalCenter }
        },
        State { when: gear == 5; name: "5"
            AnchorChanges { target: gearRect; anchors.horizontalCenter: g5.horizontalCenter }
        },
        State { when: gear == 6; name: "6"
            AnchorChanges { target: gearRect; anchors.horizontalCenter: g6.horizontalCenter }
        }
    ]

    transitions: Transition { AnchorAnimation { duration: 500 } }
}
