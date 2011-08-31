/****************************************************************************

This file is part of the Car3D project on http://www.gitorious.org.

Copyright (c) 2009 Nokia Corporation and/or its subsidiary(-ies).*
All rights reserved.

Contact:  Nokia Corporation (qt-info@nokia.com)**

You may use this file under the terms of the BSD license as follows:

"Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
* Neither the name of Nokia Corporation and its Subsidiary(-ies) nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permiss
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A P

****************************************************************************/

import QtQuick 1.0

Rectangle {
    id: root

    radius: 8;
    opacity: 0.5;
    smooth: true

    property real value: 1 - ((slider.x - 2.0) / (root.width - slider.width - 4)) // why 4?
    property bool hovered: false

    gradient: Gradient {
        GradientStop { position: 0.0; color: "gray" }
        GradientStop { position: 1.0; color: "white" }
    }

    Rectangle {
        id: slider
        x: root.width-width-2;
        y: 1;
        height: root.height-2
        width: height
        radius: root.radius-2;

        smooth: true

        gradient: Gradient {
            GradientStop { position: 0.0; color: "#424242" }
            GradientStop { position: 1.0; color: "black" }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            drag.target: parent; drag.axis: "XAxis"; drag.minimumX: 2; drag.maximumX: root.width-slider.width-2;
            onEntered: hovered = true
            onExited: hovered = false
            onPressed: { console.log(root.value) }
        }
    }
}
