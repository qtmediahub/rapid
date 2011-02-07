import QtQuick 1.0

Item {

    id: cell

    property double childScale
    property bool isFullScreen: false
    z: isFullScreen ? 10 : 0

    property int column
    property int row

    x: parent.itemWidthWithSpace * column;       width: parent.itemWidthWithSpace-parent.spacingW
    y: parent.itemHeightWithSpace * row;         height: parent.itemHeightWithSpace-parent.spacingH

    Rectangle { id: background; anchors.fill: parent
        radius: cell.width/5; color: "black";  opacity: 0.4
    }

    states: State {
        when: cell.isFullScreen; name: "fullScreen";
        PropertyChanges { target: cell; x: 0; y: 0; childScale: 1.0; width: parent.width; height: parent.height }
        PropertyChanges { target: background; opacity: 1 ; radius: 0 }
        PropertyChanges { target: minimizeButon; anchors.rightMargin: 10; }
    }

    transitions: Transition {
        NumberAnimation { target: cell; properties: "x,y,childScale,width,height"; duration: 600; easing.type: Easing.OutBounce }
        NumberAnimation { target: background; properties: "opacity,radius"; duration: 600; }
        NumberAnimation { target: minimizeButon; properties: "anchors.rightMargin"; duration: 1000; easing.type: Easing.OutBounce; easing.amplitude: 0.3 }
    }

    MouseArea {
        anchors.fill: parent;
        onClicked: parent.isFullScreen = true
        z: cell.isFullScreen ? 0 : 2
//        enabled: !cell.isFullScreen <= don't do this, mousearea needed as not-able-to-click-through
    }

    Rectangle {
        id: minimizeButon;
        property int sideLength: Math.min(parent.width,parent.height) / 10

        width: sideLength; height: sideLength
        anchors.verticalCenter: parent.verticalCenter;
        anchors.right: parent.right; anchors.rightMargin: -1000
        x: -1000
        z: 999
        radius: width / 4
        color: "#444444"

        Image {
            source: "./images/icon_x.png"
            anchors.centerIn: parent
//            font.pixelSize: parent.width
        }

        opacity: cell.isFullScreen ? 0.8 : 0

        MouseArea {
            anchors.fill: parent
            enabled: cell.isFullScreen
            onClicked: cell.isFullScreen = false
        }
    }
}
