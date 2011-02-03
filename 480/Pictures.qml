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
import ActionMapper 1.0

Window {
    id: root

    function itemActivated(itemData) {
        var selectedIndex = imagePlayList.add(itemData.mediaInfo, Playlist.Replace, Playlist.Flat)
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
        posterModel: pictureEngine.pluginProperties.model

        onActivated: {
            if (currentItem.itemdata.type != "AddNewSource")
                root.itemActivated(currentItem.itemdata)
        }
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
                source: previewUrl
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                //posterView.currentIndex = listView.currentIndex
                posterView.opacity = 1
                listView.opacity = 0
            }
        }
    }

    Keys.onPressed: {
        if(posterView.opacity) {
            if (actionmap.eventMatch(event, ActionMapper.Right)) {
                posterView.incrementCurrentIndex()
            } else if (actionmap.eventMatch(event, ActionMapper.Left)) {
                posterView.decrementCurrentIndex()
            } else if (actionmap.eventMatch(event, ActionMapper.Enter)) {
                posterView.currentItem.activate()
            }

        } else {
            if (actionmap.eventMatch(event, ActionMapper.Right)) {
                listView.incrementCurrentIndex()
            } else if (actionmap.eventMatch(event, ActionMapper.Left)) {
                listView.decrementCurrentIndex()
            } else if (actionmap.eventMatch(event, ActionMapper.Enter)) {
                posterView.opacity = 1
                listView.opacity = 0
            }
        }
    }

    Component.onCompleted: {
        pictureEngine.visualElement = root
        !!pictureEngine && pictureEngine.pluginProperties.model.setThemeResourcePath(backend.skinPath + "/rapid/components/images/");
    }
}
