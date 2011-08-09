import QtQuick 1.0

Rectangle {
    id: root

    signal clicked

    property alias text: buttonText.text

    x: 10
    width: 180
    height:  30
    color:  "#456789"
    radius: 5

    Text { id: buttonText; anchors.centerIn: parent; font.family: "Arial"; font.pixelSize: 24; color: "#ffffff"}

    MouseArea { anchors.fill: parent; onClicked: root.clicked() }
}


//                    onClicked: { view.state = "back" }
//                      onClicked: { console.debug( "xOrg: " + car.xOrg + " yOrg: " + car.yOrg + " zOrg: " + car.zOrg) }
