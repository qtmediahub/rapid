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
import Qt.labs.folderlistmodel 1.0


Window {
    id: root

    property string basedir: "."
    property string videofile
    property bool vplaying: false

    function itemActivated(itemData) {
        video.source = itemData.filePath
        video.play()
        posterView.opacity = 0
        video.opacity = 1
    }

    PosterView {
        id: posterView

        anchors.fill: parent
        posterModel: videoEngine.pluginProperties.model

        onActivated: {
            if (currentItem.itemdata.type != "AddNewSource")
                root.itemActivated(currentItem.itemdata)
        }
    }

    Video {
        id: video
        opacity: 0.0
        focus: true
        anchors.fill: parent
        volume: 0.5

        MouseArea {
             anchors.fill: parent
             onClicked: {
                 video.source = videofile;
                 video.play();
                 vplaying = true
             }
        }

        Rectangle {
            id: videocontrol
            opacity: 0.001
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: 300
            height: 70
            color: "#404040"
            radius: 12

            MouseArea {
                hoverEnabled: true
                anchors.fill: parent
                onEntered: {
                    parent.opacity = 0.5;
                }
                onExited: {
                    videocontrol.opacity = 0.001;
                }
            }

            Behavior on opacity {
                NumberAnimation { duration: 1000; easing.type: Easing.InOutQuad }
             }

            Image {
                id: vcrewind
                source: "./images/OSDRewindFO.png"
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 20

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        video.position -= 5000
                    }
                }
            }

            Image {
                id: vcstop
                source: "./images/OSDStopFO.png"
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: vcrewind.right
                anchors.leftMargin: 20

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        video.stop();
                        vplaying = false
                        posterView.opacity = 1.0;
                        video.opacity = 0.0;
                    }
                }
            }

            Image {
                id: vcpause
                source: vplaying ? "./images/OSDPauseFO.png" : "./images/OSDPlayFO.png"
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: vcstop.right
                anchors.leftMargin: 20

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        vplaying ? video.pause() : video.play();
                        vplaying = !vplaying;
                    }
                }
            }

            Image {
                id: vcforward
                source: "./images/OSDForwardFO.png"
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: vcpause.right
                anchors.leftMargin: 20

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        video.position += 5000
                    }
                }
            }

        }

        Keys.onSpacePressed: {
            vplaying ? video.pause() : video.play();
            vplaying = !vplaying;
        }
        Keys.onLeftPressed: video.position -= 5000
        Keys.onRightPressed: video.position += 5000
    }

    Component.onCompleted: {
        //videoEngine.pluginProperties.model.setThemeResourcePath(basedir);
        videoEngine.visualElement = root
        !!videoEngine && videoEngine.pluginProperties.model.setThemeResourcePath(backend.skinPath + "/rapid/components/images/");
    }
}
