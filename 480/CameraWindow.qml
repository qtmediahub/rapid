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
import QtMultimediaKit 1.1
import ActionMapper 1.0

Window {
    id: root

    Component {
        id: dot;
        Item {
            transform: Rotation { origin.x: 0; origin.y: 0; axis { x: 0; y: 0; z: 1 } angle: PathView.rotAngle}
            Rectangle {
                y: 0
                x: display.carWidth/2 * PathView.scale* PathView.scale
                smooth: true
                height: 13; width: height; radius: height
                scale: PathView.scale
                color: "green"; opacity: 0.99
            }
            Rectangle {
                x: -display.carWidth/2 * PathView.scale* PathView.scale
                y: 0
                smooth: true
                height: 13; width: height; radius: height
                scale: PathView.scale
                color: "green"; opacity: 0.99
            }
        }
    }

    Item {
        id: display
        anchors.fill: parent

        property real angle: -1// + ((angleSlider.x -angleSlider.minX) / (angleSlider.maxX-angleSlider.minX) * 2)

        property int carWidth: display.width// TODO: fixed value...
        property int xOffSet90Degrees: display.height/2.9
        property bool showRealCam: false


        property real control1Dist: 0.8
        property real control2Dist: 0.1

        property int startXOffset: 100

        property int dYL: 110
        property int dYR: 100
        property int dY: 70
        property int dControllOffsetY: 70

        property int dXL: 250
        property int dXR: 300

        MouseArea {
            id: directionMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onPositionChanged: {
                if (pressed)
                    display.angle = -1 + (mouseX / directionMouseArea.width) * 2
            }
        }

        PathView {
            id: directionPoints
            model: 30
            delegate: dot

            path: Path {
                startX: display.width/2 + display.startXOffset*display.angle;
                startY: display.height
                PathAttribute { name: "scale"; value: 1.02 }
                PathAttribute { name: "rotAngle"; value: 0 }

                PathCubic {
                    control1X: display.width/2;
                    control1Y: display.height * display.control1Dist * (1 + (display.angle > 0 ? display.angle*0.2 : 0))

                    control2X: display.width/2 + display.width*display.control2Dist*display.angle
                    control2Y: display.dY + Math.abs(display.angle) * (display.angle < 0 ? display.dYL : display.dYR) + (1-Math.abs(display.angle))*display.dControllOffsetY

                    x: display.width/2 + (display.angle * (display.angle < 0?display.dXL:display.dXR) )
                    y: display.dY + Math.abs(display.angle) * (display.angle < 0 ? display.dYL : display.dYR)
                }
                PathAttribute { name: "rotAngle"; value: 90 * display.angle }
                PathAttribute { name: "scale"; value: 0.3 }
            }

            PropertyAnimation { target: directionPoints; property: "offset"; from: 0; to: 100; loops: Animation.Infinite; running: true; duration: 25000 }
        }
    }


    Camera { id: cam;     anchors.fill: parent; visible:  display.showRealCam; z: -99999999; }
    Image  { id: fakeCam; anchors.fill: parent; visible: !display.showRealCam; z: -99999999; source: "images/view2.png"}

    Image { id: switchButton;
        anchors.right: parent.right
        anchors.margins: 20
        anchors.bottom: parent.bottom
        source: "images/icon_locate.png"

        MouseArea { anchors.fill: parent; anchors.margins: -parent.anchors.bottomMargin
            onClicked: { display.showRealCam = !display.showRealCam } }
    }

    Keys.onPressed: {// Left, Up, Right, Down, Forward, Back,
        if (    actionmap.eventMatch(event, ActionMapper.Right) ||
                actionmap.eventMatch(event, ActionMapper.Up)    ) {
            if(angleSlider.x < angleSlider.maxX)
                angleSlider.x+=5;
        }
        else if(actionmap.eventMatch(event, ActionMapper.Left) ||
                actionmap.eventMatch(event, ActionMapper.Down)  ) {
            if(angleSlider.x > angleSlider.minX)
                angleSlider.x-=5;
        }
    }

    Engine { name: qsTr("Rear-view"); role: "camera"; visualElement: root }
}


// alternative/old pathview:
//            path: Path {
//                startX: display.width/2 + display.angle*100;
//                startY: display.height
//                PathAttribute { name: "scale"; value: 1.02 }
//                PathAttribute { name: "rotAngle"; value: 0 }

//                PathCubic {
//                    control1Y: 0.5 *display.height /** (display.angle < 0 ? (1+(display.angle*0.2)) : 1);*/
//                    control2Y: 1.2 * display.xOffSet90Degrees*(Math.pow(display.angle,2)+0.5)/1.5
//                    y:         display.xOffSet90Degrees*(Math.pow(display.angle,2)+0.5)/1.5 * (display.angle < 0 ? (1-(display.angle*0.1)) : 1)

//                    control1X: display.width/2 +   display.width*display.angle/(display.angle<0 ? 10 : 3)
//                    control2X: display.width/2 +   display.width/4*display.angle
//                    x: display.width/2 + (display.width/2*display.angle);
//                }
//                PathAttribute { name: "rotAngle"; value: 90 * display.angle }
//                PathAttribute { name: "scale"; value: 0.5 *(Math.pow(display.angle,2)+0.5)/3 }
//            }
