import QtQuick 1.0

Item {
    id: root

    property int gear: -1
    width: (g6.x+g6.width) - r.x
    height: 30

    Text { id: r;  text: "R"; anchors.left:root.left; anchors.leftMargin: 0; font.pointSize: 14; anchors.verticalCenter: parent.verticalCenter }
    Text { id: p;  text: "P"; anchors.left:  r.right; anchors.leftMargin: 8; font.pointSize: 14; anchors.verticalCenter: parent.verticalCenter }
    Text { id: n;  text: "N"; anchors.left:  p.right; anchors.leftMargin: 8; font.pointSize: 14; anchors.verticalCenter: parent.verticalCenter }
    Text { id: g1; text: "1"; anchors.left:  n.right; anchors.leftMargin: 8; font.pointSize: 14; anchors.verticalCenter: parent.verticalCenter }
    Text { id: g2; text: "2"; anchors.left: g1.right; anchors.leftMargin: 8; font.pointSize: 14; anchors.verticalCenter: parent.verticalCenter }
    Text { id: g3; text: "3"; anchors.left: g2.right; anchors.leftMargin: 8; font.pointSize: 14; anchors.verticalCenter: parent.verticalCenter }
    Text { id: g4; text: "4"; anchors.left: g3.right; anchors.leftMargin: 8; font.pointSize: 14; anchors.verticalCenter: parent.verticalCenter }
    Text { id: g5; text: "5"; anchors.left: g4.right; anchors.leftMargin: 8; font.pointSize: 14; anchors.verticalCenter: parent.verticalCenter }
    Text { id: g6; text: "6"; anchors.left: g5.right; anchors.leftMargin: 8; font.pointSize: 14; anchors.verticalCenter: parent.verticalCenter }

    Rectangle {
        id: gearRect
        smooth: true
        radius: 3
        color: "transparent"
        border.color: "white"
        border.width: 3

        anchors.verticalCenter: parent.verticalCenter

        height: 23
        width: 20
    }

    states: [
        State { when: gear == -2; name: "R"
            PropertyChanges { target: gearRect; x: r.x - 4 }
        },
        State { when: gear == -1; name: "P"
            PropertyChanges { target: gearRect; x: p.x - 4 }
        },
        State { when: gear == 0; name: "N"
            PropertyChanges { target: gearRect; x: n.x - 4 }
        },
        State { when: gear == 1; name: "1"
            PropertyChanges { target: gearRect; x: g1.x - 4 }
        },
        State { when: gear == 2; name: "2"
            PropertyChanges { target: gearRect; x: g2.x - 4 }
        },
        State { when: gear == 3; name: "3"
            PropertyChanges { target: gearRect; x: g3.x - 4 }
        },
        State { when: gear == 4; name: "4"
            PropertyChanges { target: gearRect; x: g4.x - 4 }
        },
        State { when: gear == 5; name: "5"
            PropertyChanges { target: gearRect; x: g5.x - 4 }
        },
        State { when: gear == 6; name: "6"
            PropertyChanges { target: gearRect; x: g6.x - 4 }
        }
    ]

    transitions: [
        Transition { from: "*"; to: "*";
            NumberAnimation { properties: "x"; easing.type: Easing.Linear; duration: 500 }}
    ]
}
