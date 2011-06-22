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

Window {
    id: root
    anchors.leftMargin: rapid.additionalLeftMarginMore

    function itemActivated(itemData) {
        var selectedIndex = imagePlayList.add(itemData.modelIndex, Playlist.Replace, Playlist.Flat)
        listView.currentIndex = imagePlayList.row(selectedIndex)
        posterView.opacity = 0
        listView.opacity = 1
    }

    Playlist {
        id: imagePlayList
        playMode: Playlist.Normal
    }

    PosterView {
        id: posterView
        anchors.fill: parent
        posterModel: pictureEngine.model

        onActivated: root.itemActivated(currentItem.itemdata)
    }

    ListView {
        id: listView
        opacity: 0
        anchors.fill: parent
        orientation: ListView.Horizontal
        snapMode: ListView.SnapToItem
        highlightRangeMode: ListView.StrictlyEnforceRange
        highlightMoveSpeed: 1500
        model: imagePlayList
        delegate: Item {
            width: listView.width
            height: listView.height
            Image {
                id: image
                fillMode: Image.PreserveAspectFit
                sourceSize.width: imageThumbnail.width > imageThumbnail.height ? parent.width : 0
                sourceSize.height: imageThumbnail.width <= imageThumbnail.height ? parent.height : 0
                anchors.fill: parent
                source: filePath
                asynchronous: true
            }
            Image {
                id: imageThumbnail
                anchors.fill: image
                fillMode: Image.PreserveAspectFit
                visible: image.status != Image.Ready
                source: previewUrl ? previewUrl : themeResourcePath + "/media/Fanart_Fallback_Music_Small.jpg"
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                posterView.currentIndex = listView.currentIndex
                posterView.opacity = 1
                listView.opacity = 0
            }
        }
    }

    Keys.onPressed: {
        if (event.key == Qt.Key_Right || event.key == Qt.Key_Down) {
            posterView.decrementCurrentIndex()
            listView.decrementCurrentIndex()
            event.accepted = true
        } else if (event.key == Qt.Key_Left || event.key == Qt.Key_Up) {
            posterView.incrementCurrentIndex()
            listView.incrementCurrentIndex()
            event.accepted = true
        } else if (event.key == Qt.Key_Enter) {
            if(posterView.opacity)
                posterView.currentItem.activate()
            else {
                posterView.opacity = 1
                listView.opacity = 0
            }
            event.accepted = true
        }
    }

    Component.onCompleted: {
        pictureEngine.model.addSearchPath("/home/tsenyk/media/Pictures", "")
    }
}
