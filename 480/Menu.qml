import QtQuick 1.0

Item {
    id: menu

    //width: menuPic.width; height: menuPic.height; // TODO
    width: menuPic.width
    anchors.top: parent.top
    anchors.bottom: parent.bottom

    function switchMenu() {
        if(menu.state == "collapsed")
            menu.state = "extended"
        else // if?
            menu.state = "collapsed"
    }

    states: [
        State {
            name: "collapsed"
            PropertyChanges {
                target: menu
                x: -214
            }

        },
        State {
            name: "extended"
            PropertyChanges { target: menu; x: 40}   // ... qml seam to find the right value on its own :)
        }
    ]

    transitions: [
        Transition { from: "*"; to: "*";
            NumberAnimation { target: menu; property: "x"; duration: 250; easing.type: "Linear"}
        }
    ]


    Image {
    }

    BorderImage {
        id: menuPic
        source: "./images/menu.png"

        anchors.top: parent.top
        anchors.bottom: parent.bottom

        border.left: 0; border.top: 90
        border.right: 0; border.bottom: 90
    }

    Rectangle {
        color: "green"
        opacity: 0.0
        anchors.fill: parent
    }


    PathView {
        id: rootMenuList
        anchors.fill: parent

        pathItemCount: 6
        path: Path { // TODO... values..
            startX: menu.width-200;             startY: 0

            PathQuad {
                controlX: menu.width-120;       controlY: menu.height/2.0 - rapid.menuFontPixelSize;
                x: menu.width-190 ;             y: menu.height;}
        }

        dragMargin: rootMenuList.width

        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5
        highlightRangeMode: PathView.StrictlyEnforceRange


        model: backend.engines //menuList
        delegate:
            RootMenuListItem { }

        //        signal itemSelected
        //Oversized fonts being downscaled
        //        spacing: 30// TODO?
        //        keyNavigationWraps: true
        //        focus: true



        //        highlight: Image {
        //            source:  themeResourcePath + "/media/black-back2.png"
        //            opacity:  0.5
        //        }

        //        onCurrentIndexChanged: {
        //            background.role = currentItem.role
        //            !!menuSoundEffect ? menuSoundEffect.play() : undefined
        //        }

        //        Keys.onEnterPressed:
        //            currentItem.trigger()
        //        Keys.onReturnPressed:
        //            currentItem.trigger()
        //        Keys.onRightPressed:
        //            rootMenu.openSubMenu()
        //        KeyNavigation.left: playMediaButton
        //        KeyNavigation.tab: playMediaButton
    }

}



