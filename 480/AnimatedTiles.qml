import QtQuick 1.0
import AnimatedTiles 1.0

Window {
    id: root

    AnimatedTiles{ anchors.fill: parent }

    Rectangle { color: "blue"; opacity: 0.0; anchors.fill: parent }

    Component.onCompleted: {
        console.debug("animatedTilesEngine:" + animatedTilesEngine)
        animatedTilesEngine.visualElement = root
    }
}
