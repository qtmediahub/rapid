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

Item {
    id: menuItem
    width: parent.width; height: entry.height

    MouseArea { id: mr; anchors.fill: menuItem; anchors.margins: -15
        onClicked: { trigger() }
    }


    function trigger() {
        PathView.view.currentIndex = index
        rapid.setActiveEngine(model.modelData)
    }

    Text {
        id: entry
        property int angle: 0

        anchors { right: parent.right; verticalCenter: parent.verticalCenter }

        transformOrigin: Item.Right
        transform: Rotation { origin.x: entry.width/2.0; origin.y: entry.height/2.0; axis { x: 1; y: 0; z: 0 } angle: entry.angle }

        font.pixelSize: rapid.menuFontPixelSize
        font.family: "Nokia large"
        color: "white"
        text: model.modelData.name
        horizontalAlignment: Text.AlignRight
        font.weight: Font.Normal

        states: [
            State {
                name: 'isCurrentItem'
                when: PathView.isCurrentItem
                PropertyChanges { target: entry; font.weight: Font.Bold; angle: 360; scale: 1.13 }
            }
        ]
        transitions: Transition {
            SequentialAnimation {
                NumberAnimation { properties: "scale, angle"; duration: 300; easing.type: Easing.Linear }
            }
        }
    }


    Rectangle {
        id: testMouseArea
        color: "blue"
        opacity: 0.0
        anchors.fill: mr
    }
//    Rectangle {
//        id: testMouseArea2
//        color: "yellow"
//        opacity: 0.3
//        anchors.fill: entry
//    }
}
