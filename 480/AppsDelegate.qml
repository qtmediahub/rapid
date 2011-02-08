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

    function hijackedMouseClicked() {
        if(cell.isFullScreen === false)
            console.debug("WARNING: hijackedMouseClicked(event) but app wasn't fullscreen! This is a bug!")

        cell.isFullScreen = false
    }

    states: State {
        when: cell.isFullScreen; name: "fullScreen";
        PropertyChanges { target: cell; x: 0; y: 0; childScale: 1.0; width: parent.width; height: parent.height }
        PropertyChanges { target: background; opacity: 1 ; radius: 0 }
        PropertyChanges { target: rapid.qtcube; mouseAreaHijackItem: cell }
    }

    transitions: Transition {
            NumberAnimation { target: cell; properties: "x,y,childScale,width,height"; duration: 600; easing.type: Easing.OutBounce }
            NumberAnimation { target: background; properties: "opacity,radius"; duration: 600; }
        }

    MouseArea {
        anchors.fill: parent;
        onClicked: parent.isFullScreen = true
        z: cell.isFullScreen ? 0 : 2
        //enabled: !cell.isFullScreen <= don't do this, mousearea needed as not-able-to-click-through
    }

    Rectangle { id: background; anchors.fill: parent
        radius: cell.width/5; color: "black";  opacity: 0.4
    }

}
