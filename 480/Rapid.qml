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
import "cursor.js" as Cursor

import "rootmenumodelitem.js" as RootMenuModelItem

FocusScope {
    id: rapid

    property int additionalLeftMarginLess: 40
    property int additionalLeftMarginMore: 60
    property int menuFontPixelSize: 56

    property variant qtcube

    property variant musicEngine
    property variant videoEngine
    property variant pictureEngine

    property variant selectedElement
    property variant rootMenuModel: ListModel { }
    property string themeResourcePath: runtime.skin.path + "/480/images"

    property QtObject audioItem

    function takeOverAudio(item) {
        if(audioItem != item) {
            audioItem.stop()
            audioItem = item

            setActiveElement(item)      // TODO: test if working with video-push (changing the from Music-Player die Video)
        }
    }


    function setActiveElementByIndex(index) {
        menu.setCurrentIndex(index)
        setActiveElement(rootMenuModel.get(index).visualElement, rootMenuModel.get(index).url)
    }

    function setActiveElement(newElement, url) {

        if (newElement === undefined) {
            newElement = createQmlObjectFromFile(url, rapid)
        }

        if(newElement !== selectedElement) {

            if(selectedElement != "empty" && typeof(selectedElement) != "undefined")
                selectedElement.state = "hidden"
            newElement.state = "visible"
            selectedElement = newElement;
        }

        selectedElement.forceActiveFocus()
        menu.state = "collapsed"
    }


    function createQmlObjectFromFile(file) {
        var qmlComponent = Qt.createComponent(file)
        if (qmlComponent.status == Component.Ready) {
            return qmlComponent.createObject(rapid)
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


    Keys.onLeftPressed:     if (menu.state == "extended") { menu.oneUp() }
    Keys.onUpPressed:       if (menu.state == "extended") { menu.oneUp() }
    Keys.onRightPressed:    if (menu.state == "extended") { menu.oneDown() }
    Keys.onDownPressed:     if (menu.state == "extended") { menu.oneDown() }
    Keys.onEnterPressed:    if (menu.state == "extended") {
                                rapid.setActiveElementByIndex(menu.getCurrentIndex()) }
    Keys.onMenuPressed: {   if(!menu.state == "extended") {
                                rapid.forceActiveFocus()
                                rapid.focus = true
                                selectedElement.focus = false
                            }
                            menu.switchMenu()
                        }

    Component.onCompleted: {
        selectedElement = "empty"

        Cursor.initialize()

        runtime.backend.loadEngines()

        //var musicWindow = createQmlObjectFromFile("Music.qml")
        //rapid.rootMenuModel.append({name: qsTr("Music"), visualElement: musicWindow, url: "Music.qml"})

        var pictureWindow = createQmlObjectFromFile("Pictures.qml");
        rapid.rootMenuModel.append({name: qsTr("Pictures"), visualElement: pictureWindow, icon: themeResourcePath + "Picture.png", url: "Pictures.qml"})

        //var videoWindow = createQmlObjectFromFile("Video.qml")
        //rapid.rootMenuModel.append({name: qsTr("Video"), visualElement: videoWindow, url: "Video.qml"})

        var weatherWindow = createQmlObjectFromFile("Weather.qml")
        rapid.rootMenuModel.append({name: qsTr("Weather"), visualElement: weatherWindow, url: "Weather.qml"})

        var mapWindow = createQmlObjectFromFile("OviMap.qml")
        rapid.rootMenuModel.append({name: qsTr("Maps"), visualElement: mapWindow, url: "OviMap.qml"})

        var camWindow = createQmlObjectFromFile("CameraWindow.qml")
        rapid.rootMenuModel.append({name: qsTr("RearView"), visualElement: camWindow, url: "CameraWindow.qml"})

        var browserWindow = createQmlObjectFromFile("Browser/BrowserApp.qml")
        rapid.rootMenuModel.append({name: qsTr("Browser"), visualElement: browserWindow, url: "Browser/BrowserApp.qml"})

        qtcube =  createQmlObjectFromFile("Cube.qml")
        if(qtcube != null) {
            qtcube.anchors.top = rapid.top
            qtcube.anchors.right = rapid.right
            qtcube.z = 9999999
        }

        var apps = runtime.backend.findApplications()
        for (var idx in apps) {
            var path = apps[idx]
            if(path.indexOf('terminalmode') != -1) {
                var manifest = createQmlObjectFromFile(path + "qmhmanifest.qml", rapid)
                var uiType = manifest.ui.substring(manifest.ui.lastIndexOf('.')+1)
                if (uiType == "qml") {
                    rapid.rootMenuModel.append({ name: manifest.name, visualElement: undefined, icon: manifest.icon != undefined ? path + manifest.icon : themeResourcePath + "Application.png", url: path + manifest.ui })
                    runtime.frontend.addImportPath(path + "imports")
                } else {
                    console.log('Application ' + manifest.name + ' at ' + path + ' with ui:' + manifest.ui + ' could not be loaded.')
                }
            }
        }

        var clusterWindow = createQmlObjectFromFile("qtic.qml")
        rapid.rootMenuModel.append({name: qsTr("Cluster"), visualElement: clusterWindow, url: "qtic.qml"})

        rapid.setActiveElementByIndex(rootMenuModel.count-1)
        rapid.forceActiveFocus()
    }
}
