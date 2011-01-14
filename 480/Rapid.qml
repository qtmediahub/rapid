import QtQuick 1.0

Item {
    id: rapid

    height: 480
    width: 800

    property int applicationX: sideBar.width + 3
    property int applicationWidht: rapid.width - applicationX
    property int applicationHeight: rapid.height // TODO ... config file?
    property int menuFontPixelSize: 38

    property variant testWindow // TODO benoetigt?
    property variant test2Window // TODO benoetigt?


    property variant selectedEngine
    property variant selectedElement



    function setActiveEngine(engine)
    {
        console.debug("setActiveEngine(" + engine + ")")

        if(selectedEngine != engine)
        {
            if(selectedElement != "empty") // TODO confluce does this via states and setts "visible" there to make sure it's hidden again ... not sure about that
                selectedElement.state = "hidden"

            selectedEngine = engine
            selectedElement = engine.visualElement
            var elementProperties = engine.visualElementProperties
            for(var i = 0; i + 2 <= elementProperties.length; i += 2)
                selectedElement[elementProperties[i]] = elementProperties[i+1]
        }

        //show(selectedElement) => in the end:
        //selectedElement = element // hier schon gesetz
        //state = "showingSelectedElement"
//        console.debug("en")

        selectedElement.state = "visible"

        menu.state = "collapsed"
    }


    Rectangle { id: background; anchors.fill: parent; color: "black" }

    Menu {
        id: menu
        state: "collapsed"
        z: sideBar.z - 1
    }

    BorderImage {
        id: sideBar
        z: 999999999999
        source: "./images/sidebar.png"

        anchors.top: parent.top
        anchors.bottom: parent.bottom

        border.left: 20; border.top: 90
        border.right: 0; border.bottom: 90

        MouseArea {
            anchors.fill: parent
            onClicked: menu.switchMenu();
        }
    }

    Component.onCompleted: {
        selectedElement = "empty"

        var testLoader = Qt.createComponent("test.qml");
        if (testLoader.status == Component.Ready) {
            testWindow = testLoader.createObject(rapid)
        }
        else if (testLoader.status == Component.Error) { console.log(testLoader.errorString()) }

        var testLoader2 = Qt.createComponent("test2.qml");
        if (testLoader2.status == Component.Ready) {
            test2Window = testLoader2.createObject(rapid)
        }
        else if (testLoader.status == Component.Error) { console.log(testLoader.errorString()) }

        var musicLoader = Qt.createComponent("Music.qml");
        if (musicLoader.status == Component.Ready) {
            /*musicWindow = */musicLoader.createObject(rapid)
        }
        else if (musicLoader.status == Component.Error) { console.log(musicLoader.errorString()) }

        var picturesLoader = Qt.createComponent("Pictures.qml");
        if (picturesLoader.status == Component.Ready) {
            /*picturesWindow = */picturesLoader.createObject(rapid)
        }
        else if (picturesLoader.status == Component.Error) { console.log(picturesLoader.errorString()) }

        var videoLoader = Qt.createComponent("Video.qml");
        if (videoLoader.status == Component.Ready) {
            /*videoWindow = */videoLoader.createObject(rapid)
        }
        else if (videoLoader.status == Component.Error) { console.log(videoLoader.errorString()) }


        var animatedTilesLoader = Qt.createComponent("AnimatedTiles.qml");
        if (animatedTilesLoader.status == Component.Ready) {
            /*videoWindow = */animatedTilesLoader.createObject(rapid)
        }
        else if (animatedTilesLoader.status == Component.Error) { console.log(animatedTilesLoader.errorString()) }

    }


}
