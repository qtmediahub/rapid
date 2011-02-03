/****************************************************************************

This file is part of the QtMediaHub project on http://www.gitorious.org.

Copyright (c) 2009 Nokia Corporation and/or its subsidiary(-ies).*
All rights reserved.

Contact:  Nokia Corporation (qt-info@nokia.com)**

You may use this file under the terms of the BSD license as follows:

"Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
* Neither the name of Nokia Corporation and its Subsidiary(-ies) nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."

****************************************************************************/

import QtQuick 1.0
import ActionMapper 1.0

FocusScope {
    id: rapid

    width: 800
    height: 480

    property int applicationX: sideBar.width +3 //or to "maximize: -23
    property int applicationWidht: rapid.width - applicationX
    property int applicationHeight: rapid.height // TODO ... config file?
    property int menuFontPixelSize: 48


    property variant selectedEngine
    property variant selectedElement

    property variant qtcube

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
        selectedElement.forceActiveFocus()

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

    Keys.onPressed: {// Left, Up, Right, Down, Forward, Back,
        if (    actionmap.eventMatch(event, ActionMapper.Left) ||
                actionmap.eventMatch(event, ActionMapper.Up)    ) {
            if(menu.extended) { menu.oneUp() }
        }
        else if(actionmap.eventMatch(event, ActionMapper.Right) ||
                actionmap.eventMatch(event, ActionMapper.Down)  ) {
            if(menu.extended) { menu.oneDown() }
        }
        else if (actionmap.eventMatch(event, ActionMapper.Enter)) {
            console.debug("pressed: FORWARD")
            if(menu.extended) {
                rapid.setActiveEngine(menu.getCurrent())
            }
        }
        else if (actionmap.eventMatch(event, ActionMapper.Menu)) {
            console.debug("pressed: BACK")
            if(!menu.extended) {
                console.debug("     ..... + force")
                rapid.forceActiveFocus()
                rapid.focus = true
                selectedElement.focus = false
            }

            menu.switchMenu()
        }
    }

    Component.onCompleted: {
        selectedElement = "empty"

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

        var weatherLoader = Qt.createComponent("Weather.qml");
        if (weatherLoader.status == Component.Ready) {
            weatherLoader.createObject(rapid)
        }
        else if (weatherLoader.status == Component.Error) { console.log(weatherLoader.errorString()) }

        var mapLoader = Qt.createComponent("OviMap.qml");
        if (mapLoader.status == Component.Ready) {
            mapLoader.createObject(rapid)
        }
        else if (mapLoader.status == Component.Error) { console.log(mapLoader.errorString()) }

        var internetLoader = Qt.createComponent("Browser/BrowserApp.qml");
        if (internetLoader.status == Component.Ready) {
            internetLoader.createObject(rapid)
        }
        else if (internetLoader.status == Component.Error) { console.log(internetLoader.errorString()) }

        var qticLoader = Qt.createComponent("qtic.qml");
        if (qticLoader.status == Component.Ready) {
            qticLoader.createObject(rapid)
        }
        else if (qticLoader.status == Component.Error) { console.log(qticLoader.errorString()) }

        var camLoader = Qt.createComponent("CameraWindow.qml");
        if (camLoader.status == Component.Ready) {
            camLoader.createObject(rapid)
        }
        else if (camLoader.status == Component.Error) { console.log(camLoader.errorString()) }

        var qtCubeLoader = Qt.createComponent(backend.resourcePath + "/misc/cube/cube.qml")
        if (qtCubeLoader.status == Component.Ready) {
            qtcube = qtCubeLoader.createObject(rapid)
            qtcube.anchors.top = rapid.top
            qtcube.anchors.right = rapid.right
            qtcube.z = 9999999
        } else if (qtCubeLoader.status == Component.Error) {
            backend.log(qtCubeLoader.errorString())
            qtcube = dummyItem
        }


        rapid.forceActiveFocus()
    }
}
