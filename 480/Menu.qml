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
        State { name: "collapsed"
            PropertyChanges { target: menu; x: -274 }  // TODO from const to property ... use in PathView as well ... including font size?
        },
        State { name: "extended"
            PropertyChanges { target: menu; x: 15}  // TODO from const to property ... use in PathView as well ... including font size?
        }
    ]

    transitions: [
        Transition { from: "*"; to: "*";
            NumberAnimation { target: menu; property: "x"; duration: 250; easing.type: "Linear"}
        }
    ]

    BorderImage {
        id: menuPic
        source: "./images/menu.png"

        anchors.top: parent.top
        anchors.bottom: parent.bottom

        border.left: 0; border.top: 90
        border.right: 0; border.bottom: 90
    }

    MouseArea {
        enabled: menu.state == "extended"
        anchors.left: parent.left//menuPic.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        width: rapid.width

        onClicked: { menu.state = "collapsed" }

        Rectangle {
            visible: menu.state == "extended"
            color: "green"
            opacity: 0.0
            anchors.fill: parent
        }

    }



    PathView {
        id: rootMenuList
        anchors.fill: parent

        pathItemCount: 6
        path: Path { // TODO... values..
            startX: menu.width-220;             startY: -rapid.menuFontPixelSize

            PathQuad {
                controlX: menu.width-140;       controlY: menu.height/2.0 - rapid.menuFontPixelSize;
                x: menu.width-230 ;             y: menu.height + rapid.menuFontPixelSize;}
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



