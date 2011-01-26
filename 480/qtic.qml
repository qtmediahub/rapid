/****************************************************************************
**
** Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Nokia Corporation and its Subsidiary(-ies) nor
**     the names of its contributors may be used to endorse or promote
**     products derived from this software without specific prior written
**     permission.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
** $QT_END_LICENSE$
**
****************************************************************************/

import Qt 4.7
import "qticcontent"

Window{
    id: root

    Rectangle {
        id: mainElement
        clip: true
        color: "#343434"
        width: 690; height: 264
        anchors.verticalCenter: parent.verticalCenter
        radius: gearBar.height
        anchors.right: parent.right
        anchors.rightMargin: 20

        property bool ignition: false
        property int  gearSetter: -1
        property bool reverting: gearSetter == -2

        Instrument {
            id: instruments
            anchors.left: parent.left
            anchors.leftMargin: 5
        }

        DistanceControl {
            id: distanceControll
            anchors.left: parent.left
            anchors.leftMargin: -distanceControll.width
            anchors.verticalCenter: parent.verticalCenter

        }

        StatusBar {
            id: statusBar
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.left: parent.left
            anchors.right: parent.right
        }

        ToFastBar {
            id: toFastBar
            anchors.bottom: parent.bottom
            anchors.bottomMargin: -30
            anchors.left: parent.left
            anchors.right: parent.right
        }

        GearBar {
            id: gearBar
            gear: mainElement.gearSetter
            anchors.bottom: parent.bottom
            anchors.bottomMargin:  0
            anchors.horizontalCenter: parent.horizontalCenter
        }

        states: [
            State {
                when: !mainElement.ignition
                name: "ignitionOff"
                PropertyChanges { target: statusBar; anchors.bottomMargin: -30 }
            },
            State {
                when: mainElement.reverting
                name: "reverse"
                PropertyChanges { target: instruments; anchors.leftMargin: mainElement.width - 200; }
                PropertyChanges { target: distanceControll; anchors.leftMargin: 5; }
                PropertyChanges { target: distanceControll; animationRunning: true; }
            },
            State {
                when: instruments.speed > 50
                name: "toFast"
                PropertyChanges { target: statusBar; anchors.bottomMargin: 30; }
                PropertyChanges { target: gearBar; anchors.bottomMargin: 30 }
                PropertyChanges { target: toFastBar; anchors.bottomMargin: 0; }
            }
        ]

        transitions: [
            Transition {
                from: "*"; to: "*"
                NumberAnimation { properties: "anchors.bottomMargin"; easing.type: Easing.OutBounce; duration: 1000 }
                NumberAnimation { properties: "anchors.leftMargin"; easing.type: Easing.OutQuad; duration: 500 }
                NumberAnimation { properties: "anchors.rightMargin"; easing.type: Easing.OutQuad; duration: 500 }
            }
        ]

        ParallelAnimation {
            running: true
            NumberAnimation { target: statusBar; property: "distanceBig";   from: 124982;    to: 144982;    duration: 12000000 }
            NumberAnimation { target: statusBar; property: "distanceSmall"; from:    133.82; to:  20133.82; duration: 12000000 }
        }

        Engine { name: qsTr("Cluster"); role: "qtic"; visualElement: root }
    }
}
