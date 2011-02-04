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
import QtMultimediaKit 1.1
import ActionMapper 1.0


Window {
    id: root

    property variant currentIdx

    function ms2string(ms)
    {
        var ret = "";

        if (ms <= 0)
            return "00:00";

        var h = (ms/(1000*60*60)).toFixed(0);
        var m = ((ms%(1000*60*60))/(1000*60)).toFixed(0);
        var s = (((ms%(1000*60*60))%(1000*60))/1000).toFixed(0);

        if (h >= 1) {
            ret += h < 10 ? "0" + h : h + "";
            ret += ":";
        }

        ret += m < 10 ? "0" + m : m + "";
        ret += ":";
        ret += s < 10 ? "0" + s : s + "";

        return ret;
    }

    function artistAndTitle(artist, title) {
        if(!artist)
            artist = "Unknown Artist"
        if(!title)
            title = "Unknown Album"
        return artist+" - "+title
    }

    function itemActivated(itemData) {
        //console.log("Now playing: "+itemData.filePath)
        currentIdx = musicPlayList.add(itemData.mediaInfo, Playlist.Replace, Playlist.Flat)
        audio.source = itemData.filePath
        audio.play()
    }

    Playlist {
        id: musicPlayList
        playMode: Playlist.Normal
    }

    PosterView {
        id: posterView
        anchors.fill: parent
        posterModel: musicEngine.pluginProperties.model
        style: "coverFlood"

        onActivated: root.itemActivated(currentItem.itemdata)
    }

    Rectangle {
        id: audiocontrol
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10
        height: 120
        color: "#202020"
        radius: 12

        Text {
            id: title
            text: audio.metaData.title ? audio.metaData.title : qsTr("Unknown Title")
            color: "white"
            font.pointSize: 20
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.margins: 10
        }

        Text {
            id: artistitle
            text: artistAndTitle(audio.metaData.albumArtist, audio.metaData.albumTitle)
            color: "lightgrey"
            font.pointSize: 14
            anchors.left: parent.left
            anchors.top: title.bottom
            anchors.margins: 10
        }

        Text {
            text: ms2string(audio.position) + " / " + ms2string(audio.duration)
            color: "white"
            font.pointSize: 14
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 10
        }

        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.bottomMargin: 15
            anchors.leftMargin: 10
            height: 10
            width: parent.width-160
            color: "#E0E0E0"
            radius: 4

            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: 2
                height: 6
                width: audio.position/audio.duration*(parent.width-4)
                color: "#6090E0"
                radius: 3
            }

            MouseArea {
                anchors.fill: parent
                onReleased: {
                    audio.position = mouse.x/parent.width*audio.duration
                }
            }
        }
    }

    Audio {
        id: audio
        volume: 1.0

        onStopped: {
            currentIdx = musicPlayList.playNextIndex(currentIdx)
            audio.source = musicPlayList.data(currentIdx, Playlist.FilePathRole)
            audio.play()
        }
    }

    Keys.onPressed: {
        if (actionmap.eventMatch(event, ActionMapper.Right)) {
            posterView.decrementCurrentIndex()
        } else if (actionmap.eventMatch(event, ActionMapper.Left)) {
            posterView.incrementCurrentIndex()
        } else if (actionmap.eventMatch(event, ActionMapper.Enter)) {
            posterView.currentItem.activate()
        }
    }

    Component.onCompleted: {
        musicEngine.visualElement = root
        !!musicEngine && musicEngine.pluginProperties.model.setThemeResourcePath(backend.skinPath + "/rapid/components/images/");
    }
}
