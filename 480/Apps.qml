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
import ActionMapper 1.0
import AnimatedTiles 1.0

Window {
    id: root
    anchors.leftMargin: rapid.additionalLeftMarginMore
    clip: true

    // width // x
    property int coloums: 3
    property int spacingW: 30
    property int itemWidthWithSpace: (root.width)/root.coloums

    // height // y
    property int rows: 2
    property int spacingH: 30
    property int itemHeightWithSpace: root.height/root.rows


    AppsDelegate { id: a1;      column: 0; row: 0;
        childWidth: root.width; childHeight: root.height
        sourceComponent: AnimatedTiles{}
    }

    AppsDelegate { id: a2;      column: 1; row: 0;
        childWidth: root.width; childHeight: root.height
        source: backend.resourcePath + "/widgets/samegame/samegame.qml"
    }

    AppsDelegate { id: a3;      column: 2; row: 0;
        source: backend.resourcePath + "/widgets/qmlremotecontrol/qmlremotecontrol.qml"

    }

    AppsDelegate { id: b1;      column: 0; row: 1;
        source: backend.resourcePath + "/widgets/qtflyingbus/main_800_480.qml"
    }


    AppsDelegate { id: b2;      column: 1; row: 1;
        source: backend.resourcePath + "/widgets/Reversi/DesktopGame.qml"
    }

    AppsDelegate { id: b3;      column: 2; row: 1;
        source: backend.resourcePath + "/widgets/flickr/flickr.qml"
    }


    Engine { name: qsTr("Applications"); role: "apps"; visualElement: root }
}

