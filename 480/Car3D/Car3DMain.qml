import QtQuick 1.1
import Qt3D 1.0
import Qt3D.Shapes 1.0
import "../"

Window {
    id: root
//    anchors.leftMargin: rapid.additionalLeftMarginLess

    Viewport {
        id: view
        width: parent.width
        height: parent.height
        blending: true

        Light {
            id: l1
            position: Qt.vector3d(1, -1, 0)
            ambientColor: "#ffffff"
        }

        camera: Camera {

            property variant cameraVectorTop:             Qt.vector3d(0,20,5)
            property variant cameraVectorStandartLeft:    Qt.vector3d(10,10,10)
            property variant cameraVectorStandartRight:   Qt.vector3d(-10,10,10)
            property variant cameraVectorLeftRearWheel:   Qt.vector3d( 5.36862850189209,  -1.9257551431655884, -6.858921051025391)
            property variant cameraVectorLeftFrontWheel:  Qt.vector3d( 4.87527322769165,  -2.2272424697875977,  7.130680084228516)
            property variant cameraVectorRightFrontWheel: Qt.vector3d(-4.495344638824463, -1.9561352729797363,  7.452577590942383)
            property variant cameraVectorRightRearWheel:  Qt.vector3d(-5.560815334320068, -2.0435914993286133, -6.669074058532715)

            property variant cameraVectorRightFrontHeadlight: Qt.vector3d(-2.625450372695923, 0.09611012041568756, 8.244413375854492)
            property variant cameraVectorLeftFrontHeadlight:  Qt.vector3d( 2.7446298599243164, 0.20685024559497833, 8.203463554382324)

            id: viewCamera
            eye: cameraVectorStandartLeft

            Behavior on eye {
                SequentialAnimation {
                    Vector3dAnimation { duration: 300; easing.type: "OutQuad"; to: viewCamera.cameraVectorTop }
                    Vector3dAnimation { duration: 1000; easing.type: "InOutQuart" }
                }
            }
        }

        Car3D {
            id: car
        }
    }

    Rectangle {
        id: controls
        width:  200
        height: 200
        anchors.top: parent.top
        anchors.right: parent.right
        color:  "transparent"

        Column {
            y: 10
            spacing:  10

            Button {
                id: wheelBtn
                text: "Check Wheel..."
                onClicked: { // TODO: do animation on all
                }
            }

            Button {
                id: frontLeftWheelBtn
                text: "...FrontLeft"
                onClicked: { viewCamera.eye = viewCamera.cameraVectorLeftFrontWheel; car.blinkWheel(0) }
            }

            Button {
                id: frontRightWheelBtn
                text: "...FrontRight"
                onClicked: { viewCamera.eye = viewCamera.cameraVectorRightFrontWheel; car.blinkWheel(1) }
            }

            Button {
                id: rearLeftWheelBtn
                text: "...RearLeft"
                onClicked: { viewCamera.eye = viewCamera.cameraVectorLeftRearWheel; car.blinkWheel(2) }
            }

            Button {
                id: rearRightWheelBtn
                text: "...RearRight"
                onClicked: { viewCamera.eye = viewCamera.cameraVectorRightRearWheel; car.blinkWheel(3) }
            }


            Button {
                id: doorBtn
                text: "Check Door..."
                onClicked: { // TODO: do animation on all
                }
            }

            Button {
                id: frontLeftDoorBtn
                text: "...FrontLeft"
                onClicked: { viewCamera.eye = viewCamera.cameraVectorStandartLeft; car.swingDoor(0) }
            }

            Button {
                id: frontRightDoorBtn
                text: "...FrontRight"
                onClicked: { viewCamera.eye = viewCamera.cameraVectorStandartRight; car.swingDoor(1) }
            }

            Button {
                id: rearLeftDoorBtn
                text: "...RearLeft"
                onClicked: { viewCamera.eye = viewCamera.cameraVectorStandartLeft; car.swingDoor(2) }
            }

            Button {
                id: rearRightDoorBtn
                text: "...RearRight"
                onClicked: { viewCamera.eye = viewCamera.cameraVectorStandartRight; car.swingDoor(3) }
            }


            Button {
                id: normal
                text: "Reset Camera"
                onClicked: { viewCamera.eye = viewCamera.cameraVectorStandartLeft; car.stopAnimation() }
            }
        }
    }
}
