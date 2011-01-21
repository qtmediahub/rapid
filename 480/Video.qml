import QtQuick 1.0
import QtMultimediaKit 1.1
import Qt.labs.folderlistmodel 1.0


Window {
    id: root

    property string basedir: "."
    property string videofile

    ListView {
        id: listview
        anchors.fill: parent
        anchors.leftMargin: 50
        visible: true
        FolderListModel {
            id: foldermodel
            folder: basedir
            showDirs: true
            showDotAndDotDot: true
            nameFilters: ["*.mpeg","*.avi","*.ogg"]
        }
        Component {
            id: filedelegate
            Rectangle {
                height: 20
                Text {
                    color: "blue"
                    font.bold: true
                    text: fileName
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            //console.log(filePath); console.log(fileName); console.log(foldermodel.isFolder(index))
                            if(foldermodel.isFolder(index)) {
                                basedir = filePath
                            } else {
                                videofile = filePath
                                listview.visible = false;
                                video.visible = true;
                            }
                        }
                    }
                }
            }
        }

        model: foldermodel
        delegate: filedelegate
    }

    Video {
        id: video
        visible: false
        focus: true
        anchors.fill: parent
        volume: 0.5

        MouseArea {
             anchors.fill: parent
             onClicked: {
                 video.source = videofile;
                 video.play();
             }
        }

        Keys.onSpacePressed: video.paused = !video.paused
        Keys.onLeftPressed: video.position -= 5000
        Keys.onRightPressed: video.position += 5000
    }

    Component.onCompleted: {
        videoEngine.visualElement = root
    }
}
