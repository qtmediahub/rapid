import QtQuick 1.0
import QtMultimediaKit 1.1

Window {
    id: root

    Component {
        id: dot;
        Item {
            transform: Rotation { origin.x: 0; origin.y: 0; axis { x: 0; y: 0; z: 1 } angle: PathView.rotAngle}
            Rectangle {
                y: 0
                x: display.carWidth/2 * PathView.scale* PathView.scale
                smooth: true
                height: 13; width: height; radius: height
                scale: PathView.scale
                color: "green"; opacity: 0.99
            }
            Rectangle {
                x: -display.carWidth/2 * PathView.scale* PathView.scale
                y: 0
                smooth: true
                height: 13; width: height; radius: height
                scale: PathView.scale
                color: "green"; opacity: 0.99
            }
        }
    }

    Item {
        id: display
        anchors.fill: cam

        property real angle: -1- (speedSlider.x * (-2) / (speedContainer.width - 34))

//        MouseArea {
//            anchors.fill: parent
//            onClicked: {
//                if(display.angle == 1)
//                    display.angle = 0
//                else if(display.angle == 0)
//                    display.angle = -1
//                else if(display.angle == -1)
//                    display.angle = 1
//            } }

//        PropertyAnimation { target: display; property: "angle"; from: -1; to: 1; loops: Animation.Infinite; running: true; duration: 5000 }

        property int carWidth: display.width// TODO: fixed value...
        property int xOffSet90Degrees: display.height/2.9
        property bool showRealCam: false


        property real control1Dist: 0.8
        property real control2Dist: 0.1

        property int startXOffset: 100

        property int dYL: 110
        property int dYR: 100
        property int dY: 70
        property int dControllOffsetY: 70

        property int dXL: 250
        property int dXR: 300


        PathView {
            id: directionPoints
            model: 30
            delegate: dot

            path: Path {
                startX: display.width/2 + display.startXOffset*display.angle;
                startY: display.height
                PathAttribute { name: "scale"; value: 1.02 }
                PathAttribute { name: "rotAngle"; value: 0 }

                PathCubic {
                    control1X: display.width/2;
                    control1Y: display.height * display.control1Dist * (1 + (display.angle > 0 ? display.angle*0.2 : 0))

                    control2X: display.width/2 + display.width*display.control2Dist*display.angle
                    control2Y: display.dY + Math.abs(display.angle) * (display.angle < 0 ? display.dYL : display.dYR) + (1-Math.abs(display.angle))*display.dControllOffsetY

                    x: display.width/2 + (display.angle * (display.angle < 0?display.dXL:display.dXR) )
                    y: display.dY + Math.abs(display.angle) * (display.angle < 0 ? display.dYL : display.dYR)
                }
                PathAttribute { name: "rotAngle"; value: 90 * display.angle }
                PathAttribute { name: "scale"; value: 0.3 }
            }

//            path: Path {
//                startX: display.width/2 + display.angle*100;
//                startY: display.height
//                PathAttribute { name: "scale"; value: 1.02 }
//                PathAttribute { name: "rotAngle"; value: 0 }

//                PathCubic {
//                    control1Y: 0.5 *display.height /** (display.angle < 0 ? (1+(display.angle*0.2)) : 1);*/
//                    control2Y: 1.2 * display.xOffSet90Degrees*(Math.pow(display.angle,2)+0.5)/1.5
//                    y:         display.xOffSet90Degrees*(Math.pow(display.angle,2)+0.5)/1.5 * (display.angle < 0 ? (1-(display.angle*0.1)) : 1)

//                    control1X: display.width/2 +   display.width*display.angle/(display.angle<0 ? 10 : 3)
//                    control2X: display.width/2 +   display.width/4*display.angle
//                    x: display.width/2 + (display.width/2*display.angle);
//                }
//                PathAttribute { name: "rotAngle"; value: 90 * display.angle }
//                PathAttribute { name: "scale"; value: 0.5 *(Math.pow(display.angle,2)+0.5)/3 }
//            }


            PropertyAnimation { target: directionPoints; property: "offset"; from: 0; to: 100; loops: Animation.Infinite; running: true; duration: 25000 }
        }
    }


    Camera { id: cam;     anchors.fill: parent; visible:  display.showRealCam; z: -99999999; }
    Image  { id: fakeCam; anchors.fill: parent; visible: !display.showRealCam; z: -99999999; source: "images/view2.png"}

    Rectangle { id: switchButton;
        anchors.right: parent.right; anchors.rightMargin: -width/2
        anchors.top: parent.top; anchors.topMargin: -height/2
        width: 100
        height: width
        radius: width
        color: "green"
        opacity: 0.3
        MouseArea { anchors.fill: parent
            onClicked: { display.showRealCam = !display.showRealCam } }
    }


    Rectangle {
    id: speedContainer
        anchors.bottom: parent.bottom; anchors.bottomMargin: 0
        anchors.left: parent.left; anchors.leftMargin: 20
        anchors.right: parent.right; anchors.rightMargin: 20; height: 16
        gradient: Gradient {
            GradientStop { position: 0.0; color: "gray" }
            GradientStop { position: 1.0; color: "white" }
        }
        radius: 8; opacity: 0.7; smooth: true
        Rectangle {
            id: speedSlider
            x: 1; y: 1; width: 30; height: 14
            radius: 6; smooth: true
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#424242" }
                GradientStop { position: 1.0; color: "black" }
            }
            MouseArea {
                anchors.fill: parent
                drag.target: parent; drag.axis: "XAxis"; drag.minimumX: 2; drag.maximumX: speedContainer.width - 32
            }
        }
    }

    Engine { name: qsTr("Rear-view"); role: "camera"; visualElement: root }
}
