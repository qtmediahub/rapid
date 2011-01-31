import QtQuick 1.0
import ActionMapper 1.0

Item {
    id: delegateItem
    property variant itemdata : model
    width: PathView.view.delegateWidth
    height: PathView.view.delegateHeight
    clip: true
    scale: PathView.scale ? PathView.scale : 1.0
    opacity : PathView.opacity ? PathView.opacity : 1.0
    z: PathView.z ? PathView.z : 1

    transform: Rotation {
        axis { x: 0; y: 1; z: 0 }
        origin { x: width/2 }
        angle: PathView.rotation ? PathView.rotation : 0
    }

    PathView.onIsCurrentItemChanged: { // QTBUG-16347
        if (PathView.isCurrentItem)
            PathView.view.currentItem = delegateItem
    }

    Image {
        id: backgroundImage
        anchors.fill: parent
        source: model.previewUrl ? model.previewUrl : ""
        anchors.margins: 6
    }

    function activate()
    {
        var visualDataModel = PathView.view.model
        if (model.hasModelChildren) {
            visualDataModel.rootIndex = visualDataModel.modelIndex(index)
            PathView.view.rootIndexChanged() // Fire signals of aliases manually, QTBUG-14089
            visualDataModel.model.layoutChanged() // Workaround for QTBUG-16366
        } else {
            PathView.view.currentIndex = index;
            PathView.view.activated()
        }
    }

    MouseArea {
        anchors.fill: parent;
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked:
            if (mouse.button == Qt.LeftButton) {
                PathView.view.clicked()
                delegateItem.activate()
            } else {
                PathView.view.rightClicked(delegateItem.x + mouseX, delegateItem.y + mouseY)
            }
    }

    Keys.onPressed:
        if (actionmap.eventMatch(event, ActionMapper.Forward))
            delegateItem.activate()
        else if (actionmap.eventMatch(event, ActionMapper.Context))
            PathView.view.rightClicked(delegateItem.x + delegateItem.width/2, delegateItem.y + delegateItem.height/2)
}

