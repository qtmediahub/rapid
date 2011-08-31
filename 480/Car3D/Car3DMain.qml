/****************************************************************************

This file is part of the Car3D project on http://www.gitorious.org.

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
import Qt3D 1.0
import "../"

Window {
    id: root

    Viewport {
        id: view
        x: -100
        y: -100
        width: parent.width+100
        height: parent.height+100

        blending: true

        navigation: false
        camera: Camera {
            id: viewCamera
            eye: cameraVectorStandartLeft

            property variant cameraVectorTop:             Qt.vector3d(0,20,5)
            property variant cameraVectorStandartLeft:    Qt.vector3d(10,10,10)
            property variant cameraVectorStandartRight:   Qt.vector3d(-10,10,10)
            property variant cameraVectorLeftRearWheel:   Qt.vector3d( 5.36862850189209,  -1.9257551431655884, -6.858921051025391)
            property variant cameraVectorLeftFrontWheel:  Qt.vector3d( 4.87527322769165,  -2.2272424697875977,  7.130680084228516)
            property variant cameraVectorRightFrontWheel: Qt.vector3d(-4.495344638824463, -1.9561352729797363,  7.452577590942383)
            property variant cameraVectorRightRearWheel:  Qt.vector3d(-5.560815334320068, -2.0435914993286133, -6.669074058532715)

            property variant cameraVectorRightFrontHeadlight: Qt.vector3d(-2.625450372695923, 0.09611012041568756, 8.244413375854492)
            property variant cameraVectorLeftFrontHeadlight:  Qt.vector3d( 2.7446298599243164, 0.20685024559497833, 8.203463554382324)

            Behavior on eye {
                SequentialAnimation {
                    Vector3dAnimation { duration:  300; easing.type:   "OutQuad"; to: viewCamera.cameraVectorTop }
                    Vector3dAnimation { duration: 1000; easing.type: "InOutQuad" }
                }
            }
        }

        Car3D {
            id: car
            leftFrontGlassOpeningDegree:  leftFrontGlassSlider.value*0.8
            leftRearGlassOpeningDegree:   leftRearGlassSlider.value*0.8
            rightFrontGlassOpeningDegree: rightFrontGlassSlider.value*0.8
            rightRearGlassOpeningDegree:  rightRearGlassSlider.value*0.8
        }
    }

    Column {
        id: checkButtonColumn
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 2
        spacing:  2

        Button {
            id: wheelBtn
            width: root.width/3
            height: (root.height / 15)+2
            textItem.text: "Check Wheel"
            textItem.font.bold: true
            textItem.anchors.left: wheelBtn.left
            onClicked: { }
        }

        Button {
            id: frontLeftWheelBtn
            width: root.width/3
            height: (root.height / 15)
            textItem.text: "front left"
            textItem.anchors.right: frontLeftWheelBtn.right

            onClicked: { viewCamera.eye = viewCamera.cameraVectorLeftFrontWheel; car.blinkWheel(0) }
        }

        Button {
            id: frontRightWheelBtn
            width: root.width/3
            height: (root.height / 15)
            textItem.text: "front right"
            textItem.anchors.right: frontRightWheelBtn.right
            onClicked: { viewCamera.eye = viewCamera.cameraVectorRightFrontWheel; car.blinkWheel(1) }
        }

        Button {
            id: rearLeftWheelBtn
            width: root.width/3
            height: (root.height / 15)
            textItem.text: "rear left"
            textItem.anchors.right: rearLeftWheelBtn.right
            onClicked: { viewCamera.eye = viewCamera.cameraVectorLeftRearWheel; car.blinkWheel(2) }
        }

        Button {
            id: rearRightWheelBtn
            width: root.width/3
            height: (root.height / 15)
            textItem.text: "rear right"
            textItem.anchors.right: rearRightWheelBtn.right
            onClicked: { viewCamera.eye = viewCamera.cameraVectorRightRearWheel; car.blinkWheel(3) }
        }
        Item { id: spacer1; height: 3; width: 1 }


        Button {
            id: doorBtn
            width: root.width/3
            height: (root.height / 15)+2
            textItem.text: "Check Door"
            textItem.font.bold: true
            textItem.anchors.left: doorBtn.left
            onClicked: { }
        }

        Button {
            id: frontLeftDoorBtn
            width: root.width/3
            height: (root.height / 15)
            textItem.text: "front left"
            textItem.anchors.right: frontLeftDoorBtn.right
            onClicked: { viewCamera.eye = viewCamera.cameraVectorStandartLeft; car.swingDoor(0) }
        }

        Button {
            id: frontRightDoorBtn
            width: root.width/3
            height: (root.height / 15)
            textItem.text: "front right"
            textItem.anchors.right: frontRightDoorBtn.right
            onClicked: { viewCamera.eye = viewCamera.cameraVectorStandartRight; car.swingDoor(1) }
        }

        Button {
            id: rearLeftDoorBtn
            width: root.width/3
            height: (root.height / 15)
            textItem.text: "rear left"
            textItem.anchors.right: rearLeftDoorBtn.right
            onClicked: { viewCamera.eye = viewCamera.cameraVectorStandartLeft; car.swingDoor(2) }
        }

        Button {
            id: rearRightDoorBtn
            width: root.width/3
            height: (root.height / 15)
            textItem.text: "rear right"
            textItem.anchors.right: rearRightDoorBtn.right
            onClicked: { viewCamera.eye = viewCamera.cameraVectorStandartRight; car.swingDoor(3) }
        }
        Item { id: spacer2; height: 3; width: 1 }


        Button {
            id: normal
            width: root.width/3
            height: (root.height / 15)-2
            textItem.text: "Reset"
            textItem.font.bold: true
            textItem.anchors.left: normal.left
            onClicked: { viewCamera.eye = viewCamera.cameraVectorStandartLeft; car.stopAnimation() }
        }
    }

    Column {
        anchors.bottom: parent.bottom
        anchors.right: checkButtonColumn.left
        anchors.margins: 2
        spacing:  2

        SimpleSlider { id: leftFrontGlassSlider;  height: (root.height / 15)-2; width: root.width/3 }
        SimpleSlider { id: rightFrontGlassSlider; height: (root.height / 15)-2; width: root.width/3 }
        SimpleSlider { id: leftRearGlassSlider;   height: (root.height / 15)-2; width: root.width/3 }
        SimpleSlider { id: rightRearGlassSlider;  height: (root.height / 15)-2; width: root.width/3 }
    }
}
