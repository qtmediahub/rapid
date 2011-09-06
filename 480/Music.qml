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
import Playlist 1.0
import MediaModel 1.0
//import QtMultimediaKit 1.1
import QtMediaHub.components.media 1.0

Window {
    id: root
    anchors.leftMargin: rapid.additionalLeftMarginMore

    // TODO: move to rapid
    QMHPlayer {
        id: qmhPlayer
    }

    MediaModel {
        id: musicModel
        mediaType: "music"
        structure: "artist|album|title"
    }

    ListView {
        id: mediaListView
        model: musicModel

        width: parent.width*0.66
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: 20
        anchors.leftMargin: 10
        anchors.bottomMargin: 70

        focus: true
        clip: true
        highlightRangeMode: ListView.NoHighlightRange
        highlightMoveDuration: 250
        keyNavigationWraps: false
        currentIndex: qmhPlayer.mediaPlaylist.currentIndex+1

        highlight: Rectangle {
            opacity: 0.4
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#88FF70" }
                GradientStop { position: 0.5; color: "#50BB50" }
                GradientStop { position: 0.51; color: "#20B810" }
                GradientStop { position: 1.0; color: "lightgreen" }
            }
        }


        ScrollBar {
            id:  listViewScollBar
            flickable: parent
        }

        delegate: Item {
            id: delegateItem
            clip: true

            property variant itemdata : model
            property alias iconItem : delegateIcon

            width: delegateItem.ListView.view.width - listViewScollBar.width
            height: sourceText.height + 8
            transformOrigin: Item.Left

            function activate() {
                if (model.isLeaf)
                    qmhPlayer.play(musicModel, index)
                else
                    musicModel.enter(index)
            }

            Image {
                id: delegateIcon
                anchors.verticalCenter: parent.verticalCenter
                height: parent.height
                clip:  true
                source: {
                    var icon;
                    if (model.dotdot)
                        return "";
                    else if (model.previewUrl != "")
                        return model.previewUrl;
                    else
                        return ""
                }
                fillMode: Image.PreserveAspectFit
                smooth: true
            }

            Item {
                id: spacer
                anchors.left: delegateIcon.right
                width: delegateIcon.source == "" ? 36 : 0 // Magic number ... no other solution possible ... change all that longterm
                height: 1
            }

            Text {
                id: sourceText
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: spacer.right
                anchors.leftMargin: 10
                text: model.dotdot ? " -- UP --" : (delegateItem.ListView.view.model.part == "artist" ? model.artist : (delegateItem.ListView.view.model.part == "album" ? model.album : model.title))
                font.pixelSize: 24
                color: "white"
            }

            ListView.onAdd:
                SequentialAnimation {
                NumberAnimation {
                    target: delegateItem
                    properties: "scale, opacity"
                    from: 0
                    to: 1
                    duration: 200+index*40
                }
            }

            MouseArea {
                anchors.fill: parent;
                onClicked: delegateItem.activate()
            }

            Keys.onEnterPressed: delegateItem.activate()
        }

        Keys.onLeftPressed: {
            var pageItemCount = height/currentItem.height;
            if (mediaListView.currentIndex - pageItemCount < 0)
                mediaListView.currentIndex = 0;
            else
                mediaListView.currentIndex -= pageItemCount;
        }
        Keys.onRightPressed: {
            var pageItemCount = height/currentItem.height;
            if (mediaListView.currentIndex + pageItemCount > mediaListView.count-1)
                mediaListView.currentIndex = mediaListView.count-1;
            else
                mediaListView.currentIndex += pageItemCount;
        }

        Keys.onBackPressed: musicModel.back()
    }

    MusicInfo {
        mediaInfo: qmhPlayer.mediaInfo
        position: qmhPlayer.position
        duration: qmhPlayer.duration

        anchors.left: mediaListView.right
        anchors.leftMargin: 5
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.bottom: root.bottom
        anchors.top: root.top
        clip:  true
    }


    Rectangle {
        id: audiocontrol
        anchors.bottom: parent.bottom
        //        anchors.bottomMargin: 25
        anchors.horizontalCenter: mediaListView.horizontalCenter
        width: 250
        height: 60
        color: "#80404040"
        radius: 12

        Image {
            id: acrewind
            source: "./images/OSDRewindFO.png"
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: acpause.left
            anchors.rightMargin: 30

            MouseArea {
                id: rewindMouseArea
                anchors.fill: parent
                anchors.margins: -15

                property int timerCount: 0
                onPressed: { rewindTimer.start(); }
                onReleased: { rewindTimer.stop(); if (rewindMouseArea.timerCount <= (700/rewindTimer.interval) ) qmhPlayer.playPrevious(); rewindMouseArea.timerCount=0 }
                Timer { id: rewindTimer; interval: 150; repeat: true; onTriggered: { qmhPlayer.seekBackward(); rewindMouseArea.timerCount++; } }
            }
        }

        Image {
            id: acpause
            source: (qmhPlayer.playing && !qmhPlayer.paused) ? "./images/OSDPauseFO.png" : "./images/OSDPlayFO.png"
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            MouseArea {
                anchors.fill: parent
                anchors.margins: -15
                onClicked: {
                    if (qmhPlayer.paused) qmhPlayer.resume(); else qmhPlayer.pause();
                }
            }
        }

        Image {
            id: acforward
            source: "./images/OSDForwardFO.png"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: acpause.right
            anchors.leftMargin: 30

            MouseArea {
                id: forwardMouseArea
                anchors.fill: parent
                anchors.margins: -10

                property int timerCount: 0
                onPressed: { forwardTimer.start(); }
                onReleased: { forwardTimer.stop(); if (forwardMouseArea.timerCount <= (700/forwardTimer.interval) ) qmhPlayer.playNext(); forwardMouseArea.timerCount=0 }
                Timer { id: forwardTimer; interval: 150; repeat: true;
                    onTriggered: {
                        qmhPlayer.seekForward();
                        forwardMouseArea.timerCount++;
                    }
                }
            }
        }
    }
}


