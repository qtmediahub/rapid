import QtQuick 1.0
import ActionMapper 1.0

Item {
    id: delegateItem
    property variant itemdata : model
    width: delegateItem.PathView.view.delegateWidth
    height: delegateItem.PathView.view.delegateHeight
    clip: true
    scale: delegateItem.PathView.scale ? delegateItem.PathView.scale : 1.0
    opacity : delegateItem.PathView.opacity ? delegateItem.PathView.opacity : 1.0
    z: delegateItem.PathView.z ? delegateItem.PathView.z : 1

    transform: Rotation {
        axis { x: 0; y: 1; z: 0 }
        origin { x: width/2 }
        angle: delegateItem.PathView.rotation ? delegateItem.PathView.rotation : 0
    }

    PathView.onIsCurrentItemChanged: { // QTBUG-16347
        if (delegateItem.PathView.isCurrentItem)
            delegateItem.PathView.view.currentItem = delegateItem
    }

    property int frameMargin: 6

    Image {
        id: backgroundImage
        source: model.previewUrl ? model.previewUrl : themeResourcePath + "/media/Fanart_Fallback_Music_Small.jpg"

        anchors.centerIn: parent
        width: (sourceSize.width > sourceSize.height ? delegateItem.width : (sourceSize.width / sourceSize.height) * delegateItem.width) - frameMargin*2
        height: (sourceSize.width <= sourceSize.height ? delegateItem.height : (sourceSize.height / sourceSize.width) * delegateItem.height) - frameMargin*2
    }

    function activate()
    {
        var visualDataModel = delegateItem.PathView.view.model
        if (model.hasModelChildren) {
            visualDataModel.rootIndex = visualDataModel.modelIndex(index)
            delegateItem.PathView.view.currentIndex = 0 // Not sure what this line does
            delegateItem.PathView.view.rootIndexChanged() // Fire signals of aliases manually, QTBUG-14089
            visualDataModel.model.layoutChanged() // Workaround for QTBUG-16366
        } else {
            delegateItem.PathView.view.currentIndex = index;
            delegateItem.PathView.view.activated()
        }
    }

    MouseArea {
        anchors.fill: backgroundImage;

        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked:
            if (mouse.button == Qt.LeftButton) {
                delegateItem.PathView.view.clicked()
                delegateItem.activate()
            } else {
                PathView.view.rightClicked(delegateItem.x + mouseX, delegateItem.y + mouseY)
            }
    }

    Keys.onEnterPressed: { delegateItem.activate(); event.accepted = true }
}

