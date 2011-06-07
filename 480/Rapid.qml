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
import "cursor.js" as Cursor

import "rootmenumodelitem.js" as RootMenuModelItem
import QMHPlugin 1.0

FocusScope {
    id: rapid

    property int additionalLeftMarginLess: 40
    property int additionalLeftMarginMore: 60
    property int menuFontPixelSize: 48


    property variant qtcube

    property variant musicEngine
    property variant videoEngine
    property variant pictureEngine

    property variant selectedElement
    property variant rootMenuModel: ListModel { }
    property string themeResourcePath: runtime.skin.path + "/../confluence/3rdparty/skin.confluence"

    property QtObject audioItem
    function takeOverAudio(item) {
        if(audioItem != item) {
            audioItem.stop()
            audioItem = item

            setActiveElement(item)      // TODO: test if working with video-push (changing the from Music-Player die Video)
        }
    }


    function setActiveElementByIndex(index) { setActiveElement(rootMenuModel.get(index).visualElement)  }
    function setActiveElement(newElement) {
        if(newElement !== selectedElement) {

            if(selectedElement != "empty" && typeof(selectedElement) != "undefined")
                selectedElement.state = "hidden"
            newElement.state = "visible"
            //selectedElement.forceActiveFocus()
            selectedElement = newElement;
        }

        menu.state = "collapsed"
    }


    function createQmlObjectFromFile(file, properties) {
        var qmlComponent = Qt.createComponent(file)
        if (qmlComponent.status == Component.Ready) {
            return qmlComponent.createObject(rapid, properties ? properties : {})
        }
        runtime.backend.log(qmlComponent.errorString())
        return null
    }

    function addToRootMenu(obj, activationHandler) {
        rootMenuModel.append(obj)
        RootMenuModelItem.activationHandlers[rootMenuModel.count-1] = activationHandler
    }


    Rectangle { id: background; anchors.fill: parent; color: "black" }

    Menu {
        id: menu
        state: "collapsed"
        z: 999999999999

        onStateChanged: {
            if(menu.state == "extended") {
                selectedElement.focus = false
                rapid.forceActiveFocus()
                rapid.focus = true
            }
        }
    }

    Keys.onPressed: {// Left, Up, Right, Down, Forward, Back,
        if (    actionmap.eventMatch(event, ActionMapper.Left) ||
                actionmap.eventMatch(event, ActionMapper.Up)    ) {
            if(menu.state == "extended") { menu.oneUp() }
        }
        else if(actionmap.eventMatch(event, ActionMapper.Right) ||
                actionmap.eventMatch(event, ActionMapper.Down)  ) {
            if(menu.state == "extended") { menu.oneDown() }
        }
        else if (actionmap.eventMatch(event, ActionMapper.Enter)) {
            if(menu.state == "extended") {
                rapid.setActiveEngine(menu.getCurrent())
            }
        }
        else if (actionmap.eventMatch(event, ActionMapper.Menu)) {
            if(!menu.state == "extended") {
                rapid.forceActiveFocus()
                rapid.focus = true
                selectedElement.focus = false
            }

            menu.switchMenu()
        }
    }

    Component.onCompleted: {
        selectedElement = "empty"

        Cursor.initialize()

        runtime.backend.loadEngines()
        var engineNames = runtime.backend.loadedEngineNames()

        if (engineNames.indexOf("music") != -1) {
            musicEngine = runtime.backend.engine("music")
            var musicWindow = createQmlObjectFromFile("Music.qml", { /*mediaEngine: musicEngine*/ });
            rapid.addToRootMenu(new RootMenuModelItem.RootMenuModelItem(qsTr("Music"), QMHPlugin.Music, musicWindow, musicEngine))
            audioItem = musicWindow
        }

        if (engineNames.indexOf("picture") != -1) {
            pictureEngine = runtime.backend.engine("picture")
            var pictureWindow = createQmlObjectFromFile("Pictures.qml", { /*mediaEngine: musicEngine*/ });
            rapid.addToRootMenu(new RootMenuModelItem.RootMenuModelItem(qsTr("Pictures"), QMHPlugin.Pictures, pictureWindow, pictureEngine))
        }

        if (engineNames.indexOf("video") != -1) {
            videoEngine = runtime.backend.engine("video")
            var videoWindow = createQmlObjectFromFile("Video.qml", { /*mediaEngine: musicEngine*/ });
            rapid.addToRootMenu(new RootMenuModelItem.RootMenuModelItem(qsTr("Video"), QMHPlugin.Video, videoWindow, videoEngine))
        }

        var weatherWindow = createQmlObjectFromFile("Weather.qml")
        rapid.addToRootMenu(new RootMenuModelItem.RootMenuModelItem(qsTr("Weather"), QMHPlugin.Weather, weatherWindow))

        var mapWindow = createQmlObjectFromFile("OviMap.qml")
        rapid.addToRootMenu(new RootMenuModelItem.RootMenuModelItem(qsTr("Maps"), QMHPlugin.Map, mapWindow))

        var camWindow = createQmlObjectFromFile("CameraWindow.qml")
        rapid.addToRootMenu(new RootMenuModelItem.RootMenuModelItem(qsTr("RearView"), QMHPlugin.Application, camWindow))

        var browserWindow = createQmlObjectFromFile("Browser/BrowserApp.qml")
        rapid.addToRootMenu(new RootMenuModelItem.RootMenuModelItem(qsTr("Browser"), QMHPlugin.Web, browserWindow))

        var qticWindow = createQmlObjectFromFile("qtic.qml")
        rapid.addToRootMenu(new RootMenuModelItem.RootMenuModelItem(qsTr("Instrument"), QMHPlugin.Application, qticWindow))

//        rapid.addToRootMenu(new RootMenuModelItem.RootMenuModelItem(qsTr("Apps"), QMHPlugin.Application, createQmlObjectFromFile("Apps.qml")))
//        rapid.addToRootMenu(new RootMenuModelItem.RootMenuModelItem(qsTr("TerminalMode"), QMHPlugin.Application, createQmlObjectFromFile("TerminalModeWindow.qml")))

        qtcube =  createQmlObjectFromFile(runtime.backend.resourcePath + "/misc/cube/cube.qml")
        qtcube.anchors.top = rapid.top
        qtcube.anchors.right = rapid.right
        qtcube.z = 9999999

        setActiveElement(qticWindow)
        rapid.forceActiveFocus()
    }
}
