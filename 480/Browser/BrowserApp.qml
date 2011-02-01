/** This file is part of QtQuickIVIDemo**

Copyright © 2010 Nokia Corporation and/or its subsidiary(-ies).*
All rights reserved.

Contact:  Nokia Corporation qt-info@nokia.com

You may use this file under the terms of the BSD license as follows:

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

* Redistributions of source code must retain the above copyright
  notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer in the
  documentation and/or other materials provided with the distribution.
* Neither the name of Nokia Corporation and its Subsidiary(-ies) nor
  the names of its contributors may be used to endorse or promote
  products derived from this software without specific prior written
  permission.


THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
*/
import Qt 4.7
import "../"
import "../../components"

// BrowserApp is the entry point to
// the Browser application
Window {
    id: root

    property alias urlInput: urlInput


    signal setToolbarModel(variant model)
    onSetToolbarModel: toolbar.model = model

    Toolbar {
        id: toolbar
        height: 70
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.leftMargin: 0
        anchors.rightMargin: 0
        z: 999999
        onBtnClicked: { mainView.handleToolbarEvent(event) }
    }



    // Properties from DynamicApp
//    toolbarHandler: mainView
//    property variant toolbarHandler: mainView


//    x: width

    // Create toolbar buttons for Browser
    ButtonsDataBookmarks { id: toolbarBtnsBookmarks }
    ButtonsDataBrowser { id: toolbarBtnsBrowser }

    BrowserMainView {
        id: mainView
        state: "bookmarks"
        anchors.fill: parent
        anchors.bottomMargin: toolbar.height
    }

    // Url input field is displayed when
    // URL button in toolbar is pressed
    UrlInputBox {
        id: urlInput
        anchors.left: parent.left
        anchors.bottom: toolbar.top
        anchors.right: parent.right
        anchors.rightMargin: 0
        onUrlEntered: {
            urlInput.setVisible(false);
            mainView.openUrl(urlInput.url);
        }
    }

    // The 'current' state is entered when the Log application becomes active
    // AND the application dimensions have been set by the Loader component.
    // Essentially, this means that the application is expanded from zero
    // height to full height. When deactivating the application, a reverse
    // transition is done.
    states:
        State {
        name: "current"
        when: activeApp
        StateChangeScript { script: refresh() }
        PropertyChanges { target:app; x: 0 }
        // Set toolbar buttons according to (previous)
        // state of the Browser application
        StateChangeScript {
            script: {
                if (mainView.state == "browser")
                    setToolbarModel(toolbarBtnsBrowser);
                else
                    setToolbarModel(toolbarBtnsBookmarks);
            }
        }
    }

    transitions: [
        Transition {
            to: "current"
            NumberAnimation { properties: "x";easing.type: "InOutQuad"; duration: 500 }
        },
        Transition {
            from: "current"
            NumberAnimation { properties: "x";easing.type: "InOutQuad"; duration: 500 }
            ScriptAction { script: urlInput.setVisible(false) }
        }
    ]


    Engine { name: qsTr("Internet"); role: "internet"; visualElement: root }
}