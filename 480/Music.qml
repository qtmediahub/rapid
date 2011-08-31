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
import QtMultimediaKit 1.1

Window {
    id: root
    anchors.leftMargin: rapid.additionalLeftMarginLess

    function playNext() {
        mediaListView.incrementCurrentIndex()
        playCurrentIndex()
    }

    function playPrevious() {
        mediaListView.decrementCurrentIndex()
        playCurrentIndex()
    }

    function playCurrentIndex() {
        audio.stop();
        audio.source =  mediaListView.currentItem.itemdata.filepath
        audio.play();
    }

    function stop() {
        audio.stop();
        mediaListView.currentIndex = -1 // Is this right?
    }

    Audio {
        id: audio
        volume: 1.0

        onStarted: { rapid.takeOverAudio(root) }
        onResumed: { rapid.takeOverAudio(root) }

        onStopped: {
            if(audio.status == Audio.EndOfMedia) {
                playNext();
            }
        }
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
        anchors.margins: 50

        focus: true
        clip: true
        highlightRangeMode: ListView.NoHighlightRange
        highlightMoveDuration: 250
        keyNavigationWraps: false

        highlight: Rectangle {
            opacity: 0.4
            gradient: Gradient {
                GradientStop { position: 0.0; color: "white" }
                GradientStop { position: 0.5; color: "lightsteelblue" }
                GradientStop { position: 0.51; color: "steelblue" }
                GradientStop { position: 1.0; color: "lightsteelblue" }
            }
        }


        ScrollBar {
            flickable: parent
        }

        delegate: Item {
            id: delegateItem

            property variant itemdata : model
            property alias iconItem : delegateIcon

            width: delegateItem.ListView.view.width
            height: sourceText.height + 8
            transformOrigin: Item.Left

            function activate() {
                if (model.isLeaf) {
                    mediaListView.currentIndex = index
                    root.playCurrentIndex();
                }
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
                    else if (delegateItem.ListView.view.model.part == "artist")
                        icon = "DefaultFolder.png";
                    else if (delegateItem.ListView.view.model.part == "album")
                        icon = "DefaultFolder.png";
                    else
                        icon = "DefaultAudio.png";
                    return themeResourcePath + "/" + icon;
                }
                fillMode: Image.PreserveAspectFit
                smooth: true
            }

            Text {
                id: sourceText
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: delegateIcon.right
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

                /*hoverEnabled: true
                acceptedButtons: Qt.LeftButton
                onEntered: {
                    delegateItem.ListView.view.currentIndex = index
                    if (delegateItem.ListView.view.currentItem)
                        delegateItem.ListView.view.currentItem.focus = true
                }*/

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

    Image {
        id: coverArt
        anchors.left: mediaListView.right
        anchors.leftMargin: 65
        anchors.right: parent.right
        anchors.rightMargin: 30
        anchors.bottom: mediaListView.bottom
        anchors.top: mediaListView.top
        clip:  true
        source: mediaListView.currentItem ? mediaListView.currentItem.iconItem.source : ""
        fillMode: Image.PreserveAspectFit
    }

    Keys.onContext1Pressed: delphin.showOptionDialog(actionList)
}


