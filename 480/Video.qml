import QtQuick 1.0
import QtMultimediaKit 1.1
import Qt.labs.folderlistmodel 1.0


Window {
    id: root

    property string basedir: "."
    property string videofile
    property bool vplaying: false

    Rectangle {
        id: videoChooser
        anchors.centerIn: parent
        width: 300
        height: 400
        color: "#181818"
        radius: 8

//        ListView {
//            id: listview
//            anchors.fill: parent
//            anchors.leftMargin: 10

//            model: VisualDataModel {

//                id: visualDataModel
//                model: videoEngine.pluginProperties.model
//                delegate: Rectangle {
//                    id: delegateItem
//                    width: parent.width
//                    height: 25
//                    color: "transparent"
//                    Text {
//                        color: "white"
//                        text: display
//                    }

//                    function activate() {
//                        var visualDataModel = ListView.view.model
//                        if (model.hasModelChildren) {
//                            visualDataModel.rootIndex = visualDataModel.modelIndex(index)
//                        } else {
//                            //console.log(model.display);
//                            videoChooser.opacity = 0.0;
//                            video.opacity = 1.0;
//                            videofile = basedir+model.display
//                        }
//                    }

//                    MouseArea {
//                        anchors.fill: parent;
//                        acceptedButtons: Qt.LeftButton | Qt.RightButton
//                        onEntered: {
//                            ListView.view.currentIndex = index
//                        }
//                        onClicked: {
//                            if (mouse.button == Qt.LeftButton) {
//                                delegateItem.activate()
//                            } else {
//                                ListView.view.rightClicked(delegateItem.x + mouseX, delegateItem.y + mouseY)
//                            }
//                        }
//                    }

//                }
//            }
//        }

        ListView {
            id: listview
            anchors.fill: parent
            anchors.margins: 10
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
                Text {
                    height: 20
                    width: listview.width
                    color: "white"
                    font.bold: true
                    elide: Text.ElideRight
                    text: fileName
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            //console.log(filePath); console.log(fileName); console.log(foldermodel.isFolder(index))
                            if(foldermodel.isFolder(index)) {
                                basedir = filePath
                            } else {
                                videoChooser.opacity = 0.0;
                                video.opacity = 1.0;
                                videofile = filePath;
                            }
                        }
                    }
                }
            }

            model: foldermodel
            delegate: filedelegate
        }
    }

    Video {
        id: video
        opacity: 0.0
        focus: true
        anchors.fill: parent
        volume: 0.5

        MouseArea {
             anchors.fill: parent
             onClicked: {
                 video.source = videofile;
                 video.play();
                 vplaying = true
             }
        }

        Rectangle {
            id: videocontrol
            opacity: 0.001
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: 300
            height: 70
            color: "#404040"
            radius: 12

            MouseArea {
                hoverEnabled: true
                anchors.fill: parent
                onEntered: {
                    parent.opacity = 0.5;
                }
                onExited: {
                    videocontrol.opacity = 0.001;
                }
            }

            Behavior on opacity {
                NumberAnimation { duration: 1000; easing.type: Easing.InOutQuad }
             }

            Image {
                id: vcrewind
                source: "./images/OSDRewindFO.png"
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 20

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        video.position -= 5000
                    }
                }
            }

            Image {
                id: vcstop
                source: "./images/OSDStopFO.png"
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: vcrewind.right
                anchors.leftMargin: 20

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        video.stop();
                        vplaying = false
                        videoChooser.opacity = 1.0;
                        video.opacity = 0.0;
                    }
                }
            }

            Image {
                id: vcpause
                source: vplaying ? "./images/OSDPauseFO.png" : "./images/OSDPlayFO.png"
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: vcstop.right
                anchors.leftMargin: 20

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        vplaying ? video.pause() : video.play();
                        vplaying = !vplaying;
                    }
                }
            }

            Image {
                id: vcforward
                source: "./images/OSDForwardFO.png"
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: vcpause.right
                anchors.leftMargin: 20

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        video.position += 5000
                    }
                }
            }

        }

        Keys.onSpacePressed: {
            vplaying ? video.pause() : video.play();
            vplaying = !vplaying;
        }
        Keys.onLeftPressed: video.position -= 5000
        Keys.onRightPressed: video.position += 5000
    }

    Component.onCompleted: {
        //videoEngine.pluginProperties.model.setThemeResourcePath(basedir);
        videoEngine.visualElement = root
    }
}
