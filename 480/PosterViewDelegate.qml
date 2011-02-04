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
        fillMode: Image.PreserveAspectFit
        source: model.previewUrl ? model.previewUrl : ""
        anchors.margins: 6

//        Text {
//            visible: (type == "Directory")
//            anchors.bottom: parent.bottom
//            anchors.horizontalCenter: parent.horizontalCenter
//            width: parent.width
//            elide: Text.ElideRight
//            horizontalAlignment: Text.AlignHCenter
//            color: "#808080"
//            text: model.fileName
//            font.pointSize: 8
//        }
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
}

