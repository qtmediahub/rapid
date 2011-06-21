import QtQuick 1.0

Item {

    id: root
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

    property bool hasSelectFocus: (parent.focusRow == row && parent.focusColumn == column)

    function hijackedMouseClicked() {
        if(root.isFullScreen === false)
            console.debug("WARNING: hijackedMouseClicked(event) but app wasn't fullscreen! This is a bug!")

        root.isFullScreen = false
    }

    states: State {
        when: root.isFullScreen; name: "fullScreen";
        PropertyChanges { target: root; x: 0; y: 0; z: 10; width: parent.width; height: parent.height }
        PropertyChanges { target: rapid.qtcube; mouseAreaHijackItem: root }
    }

    transitions: [
        Transition { to: "fullScreen"
            SequentialAnimation {
                PropertyAction { target: root; properties: "z"; }
                NumberAnimation { target: root; properties: "x,y,width,height"; duration: 600; easing.type: Easing.OutBounce }
            } },
        Transition { from: "fullScreen"
            SequentialAnimation {
                NumberAnimation { target: root; properties: "x,y,width,height"; duration: 600; easing.type: Easing.OutBounce }
                PropertyAction { target: root; properties: "z"; }
            } }
    ]

    MouseArea {
        anchors.fill: parent;
        onClicked: {
            root.isFullScreen = true
            root.parent.setFocusCoord(root.row, root.column)
        }
        z: root.isFullScreen ? 0 : 2
        //enabled: !root.isFullScreen <= don't do this, mousearea needed as not-able-to-click-through
    }

    Item { id: outline;
        anchors.fill: parent
        Rectangle {
            color: "black"
            border.color: "silver"
            border.width: root.hasSelectFocus ? 8 : 2
            anchors.fill: parent
            anchors.margins: 2
        }
        Rectangle {
            color: "transparent"
            border.color: "white"
            border.width: root.hasSelectFocus ? 4 : 1
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
            else if(root.source !== "")
                loader.source = root.source
            else if(root.sourceComponent !== null)
                loader.sourceComponent = root.sourceComponent
        }

        scale: Math.min(1, Math.min(root.height*0.9/loader.height, root.width*0.9/loader.width))

        onLoaded: { item.clip = true }
    }


    Component.onCompleted: {
        parent.addItem(root, row, column)
//        parent.delegateArray[parent.index(column, row)] = a1
    }
}
