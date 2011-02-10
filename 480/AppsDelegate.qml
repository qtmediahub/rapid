import QtQuick 1.0

Item {

    id: cell
    clip: true

    property bool isFullScreen: false

    property int column
    property int row
    x: parent.itemWidthWithSpace * column + parent.spacingW*0.5;       width: parent.itemWidthWithSpace-parent.spacingW
    y: parent.itemHeightWithSpace * row   + parent.spacingH*0.5;       height: parent.itemHeightWithSpace-parent.spacingH

    property string source: ""
    property Component sourceComponent: null

    property alias childWidth: loader.width
    property alias childHeight: loader.height


    function hijackedMouseClicked() {
        if(cell.isFullScreen === false)
            console.debug("WARNING: hijackedMouseClicked(event) but app wasn't fullscreen! This is a bug!")

        cell.isFullScreen = false
    }

    states: State {
        when: cell.isFullScreen; name: "fullScreen";
        PropertyChanges { target: cell; x: 0; y: 0; z: 10; width: parent.width; height: parent.height }
        PropertyChanges { target: rapid.qtcube; mouseAreaHijackItem: cell }
    }

    transitions: [
        Transition { to: "fullScreen"
            SequentialAnimation {
                PropertyAction { target: cell; properties: "z"; }
                NumberAnimation { target: cell; properties: "x,y,width,height"; duration: 600; easing.type: Easing.OutBounce }
            } },
        Transition { from: "fullScreen"
            SequentialAnimation {
                NumberAnimation { target: cell; properties: "x,y,width,height"; duration: 600; easing.type: Easing.OutBounce }
                PropertyAction { target: cell; properties: "z"; }
            } }
    ]

    MouseArea {
        anchors.fill: parent;
        onClicked: parent.isFullScreen = true
        z: cell.isFullScreen ? 0 : 2
        //enabled: !cell.isFullScreen <= don't do this, mousearea needed as not-able-to-click-through
    }

    Item { id: outline;
        anchors.fill: parent
        Rectangle {
            color: "black"
            border.color: "silver"
            border.width: 2
            anchors.fill: parent
            anchors.margins: 2
        }
        Rectangle {
            color: "transparent"
            border.color: "white"
            border.width: 1
            anchors.fill: parent
            anchors.margins: 7
        }
    }

    Loader {
        id: loader;

        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        onVisibleChanged: {
            if(loader.visible == false) {
                loader.source = ""
                loader.sourceComponent = null
            }
            else if(cell.source !== "")
                loader.source = cell.source
            else if(cell.sourceComponent !== null)
                loader.sourceComponent = cell.sourceComponent
        }

        scale: Math.min(1, Math.min(cell.height*0.9/loader.height, cell.width*0.9/loader.width))

        onLoaded: { item.clip = true }
    }
}
