import QtQuick 1.1
import Qt3D 1.0
import Qt3D.Shapes 1.0

import "HyundaiGenesis_sliced_0.2"


// NOTE
// try to avoid doing translate (and rotate only around 0,0,0) on this item! .. it will most probably break other animations!


Item3D {
    id: root
    pretransform: Translation3D{ translate: Qt.vector3d(0.76, -1.44, -0.02) } // move center of car (between driver and shotgun) to center of world (0,0,0)



    // ------------------ Functions
    Item { id: animCont
        property variant lastScaleAnim: null
    }

    function stopAnimation() {
        if(animCont.lastScaleAnim != null) {
            animCont.lastScaleAnim.loops = 1
        }
        animCont.lastScaleAnim = null;
    }

    function blinkWheel(wheelId) {
        stopAnimation()

        if(wheelId == 0)
            animCont.lastScaleAnim = leftFrontWheelPulseAnimation
        else if(wheelId == 1)
            animCont.lastScaleAnim = rightFrontWheelPulseAnimation
        else if(wheelId == 2)
            animCont.lastScaleAnim = leftRearWheelPulseAnimation
        else if(wheelId == 3)
            animCont.lastScaleAnim = rightRearWheelPulseAnimation

        if(animCont.lastScaleAnim != null) {
            animCont.lastScaleAnim.loops = Animation.Infinite
            animCont.lastScaleAnim.start()
        }
    }

    function swingDoor(doorId) {
        stopAnimation()

        if(doorId == 0)
            animCont.lastScaleAnim = leftFrontDoorRotationAnimation
        else if(doorId == 1)
            animCont.lastScaleAnim = rightFrontDoorRotationAnimation
        else if(doorId == 2)
            animCont.lastScaleAnim = leftRearDoorRotationAnimation
        else if(doorId == 3)
            animCont.lastScaleAnim = rightRearDoorRotationAnimation

        if(animCont.lastScaleAnim != null) {
            animCont.lastScaleAnim.loops = Animation.Infinite
            animCont.lastScaleAnim.start()
        }
    }



    // ------------------ Meshes ------------------
    Meshes { id: meshes }

    Item3D { mesh: meshes.carCoreMesh; }

    Item3D { mesh: meshes.door_left_front;                                      transform: leftFrontDoorRotation  }
    Item3D { mesh: meshes.door_left_rear;                                       transform: leftRearDoorRotation   }
    Item3D { mesh: meshes.door_right_front;                                     transform: rightFrontDoorRotation }
    Item3D { mesh: meshes.door_right_rear;                                      transform: rightRearDoorRotation  }

    Item3D { mesh: meshes.glass_back;                   effect: glass; }
    Item3D { mesh: meshes.glass_front;                  effect: glass; }
    Item3D { mesh: meshes.glass_left_front;             effect: glass;          transform: leftFrontDoorRotation  }
    Item3D { mesh: meshes.glass_left_rear_big;          effect: glass;          transform: leftRearDoorRotation   }
    Item3D { mesh: meshes.glass_left_rear_small;        effect: glass;          transform: leftRearDoorRotation   }
    Item3D { mesh: meshes.glass_right_front;            effect: glass;          transform: rightFrontDoorRotation }
    Item3D { mesh: meshes.glass_right_rear_big;         effect: glass;          transform: rightRearDoorRotation  }
    Item3D { mesh: meshes.glass_right_rear_small;       effect: glass;          transform: rightRearDoorRotation  }

    Item3D { mesh: meshes.headlight_left_back; }
    Item3D { mesh: meshes.headlight_left_front; }
    Item3D { mesh: meshes.headlight_right_back; }
    Item3D { mesh: meshes.headlight_right_front; }
    Item3D { mesh: meshes.headlight_glass_left_back;    effect: glass; }
    Item3D { mesh: meshes.headlight_glass_left_front;   effect: glass; }
    Item3D { mesh: meshes.headlight_glass_right_back;   effect: glass; }
    Item3D { mesh: meshes.headlight_glass_right_front;  effect: glass; }

    Item3D { mesh: meshes.wheel_left_back;                                      transform: leftRearWheelPulse}
    Item3D { mesh: meshes.wheel_left_front;                                     transform: leftFrontWheelPulse; }
    Item3D { mesh: meshes.wheel_right_back;                                     transform: rightRearWheelPulse}
    Item3D { mesh: meshes.wheel_right_front;                                    transform: rightFrontWheelPulse}


    // ------------------ Effects ------------------
    Effect {
        id: glass
        blending: true;
        color: Qt.rgba(0.1, 0.1, 0.4, 0.3)
    }


    // ------------------ Transform + Animations ------------------
    Rotation3D {
        id: leftFrontDoorRotation
        angle: 0
        axis: Qt.vector3d(0, 1, 0)
        origin: meshes.leftFrontDoorMountingVector3D
    }
    SequentialAnimation { id: leftFrontDoorRotationAnimation; //running: true; loops: Animation.Infinite
        NumberAnimation { target: leftFrontDoorRotation; property: "angle"; from: 0; to : -30.0; duration: 1000; easing.type: Easing.OutBounce}
        NumberAnimation { target: leftFrontDoorRotation; property: "angle"; from: -30; to : 0.0; duration: 500; easing.type: Easing.OutCubic}    }

    Rotation3D {
        id: leftRearDoorRotation
        angle: 0
        axis: Qt.vector3d(0, 1, 0)
        origin: meshes.leftBackDoorMountingVector3D
    }
    SequentialAnimation { id: leftRearDoorRotationAnimation; //running: true; loops: Animation.Infinite
        NumberAnimation { target: leftRearDoorRotation; property: "angle"; from: 0; to : -30.0; duration: 1000; easing.type: Easing.OutBounce}
        NumberAnimation { target: leftRearDoorRotation; property: "angle"; from: -30; to : 0.0; duration: 500; easing.type: Easing.OutCubic}     }

    Rotation3D {
        id: rightFrontDoorRotation
        angle: 0
        axis: Qt.vector3d(0, 1, 0)
        origin: meshes.rightFrontDoorMountingVector3D
    }
    SequentialAnimation { id: rightFrontDoorRotationAnimation; //running: true; loops: Animation.Infinite
        NumberAnimation { target: rightFrontDoorRotation; property: "angle"; from: 0; to : 30.0; duration: 1000; easing.type: Easing.OutBounce}
        NumberAnimation { target: rightFrontDoorRotation; property: "angle"; from: 30; to : 0.0; duration: 500; easing.type: Easing.OutCubic}    }

    Rotation3D {
        id: rightRearDoorRotation
        angle: 0
        axis: Qt.vector3d(0, 1, 0)
        origin: meshes.rightRearDoorMountingVector3D
    }
    SequentialAnimation { id: rightRearDoorRotationAnimation; //running: true; loops: Animation.Infinite
        NumberAnimation { target: rightRearDoorRotation; property: "angle"; from: 0; to : 30.0; duration: 1000; easing.type: Easing.OutBounce}
        NumberAnimation { target: rightRearDoorRotation; property: "angle"; from: 30; to : 0.0; duration: 500; easing.type: Easing.OutCubic}    }




    Scale3D {
        id: leftFrontWheelPulse
        scale: 1.0
        origin: Qt.vector3d(0.654, 0.536, 2.587)
    }
    SequentialAnimation { id: leftFrontWheelPulseAnimation; //running: true; loops: Animation.Infinite
        NumberAnimation { target: leftFrontWheelPulse; property: "scale"; from: 1.0;  to: 1.05; duration: 200; /*easing.type: Easing.OutBounce*/}
        NumberAnimation { target: leftFrontWheelPulse; property: "scale"; from: 1.05; to: 0.9;  duration: 200; /*easing.type: Easing.OutCubic*/}
        NumberAnimation { target: leftFrontWheelPulse; property: "scale"; from: 0.9;  to: 1.0;  duration: 200; /*easing.type: Easing.OutCubic*/}    }

    Scale3D {
        id: rightFrontWheelPulse
        scale: 1.0
        origin: Qt.vector3d(-2.120, 0.536, 2.587)
    }
    SequentialAnimation { id: rightFrontWheelPulseAnimation; /*running: true; loops: Animation.Infinite*/
        NumberAnimation { target: rightFrontWheelPulse; property: "scale"; from: 1.0;  to: 1.05; duration: 200; /*easing.type: Easing.OutBounce*/}
        NumberAnimation { target: rightFrontWheelPulse; property: "scale"; from: 1.05; to: 0.9;  duration: 200; /*easing.type: Easing.OutCubic*/}
        NumberAnimation { target: rightFrontWheelPulse; property: "scale"; from: 0.9;  to: 1.0;  duration: 200; /*easing.type: Easing.OutCubic*/}    }

    Scale3D {
        id: leftRearWheelPulse
        scale: 1.0
        origin: Qt.vector3d(0.654, 0.536, -2.110 /* -? */)
    }
    SequentialAnimation { id: leftRearWheelPulseAnimation; /*running: true; loops: Animation.Infinite*/
        NumberAnimation { target: leftRearWheelPulse; property: "scale"; from: 1.0;  to: 1.05; duration: 200; /*easing.type: Easing.OutBounce*/}
        NumberAnimation { target: leftRearWheelPulse; property: "scale"; from: 1.05; to: 0.9;  duration: 200; /*easing.type: Easing.OutCubic*/}
        NumberAnimation { target: leftRearWheelPulse; property: "scale"; from: 0.9;  to: 1.0;  duration: 200; /*easing.type: Easing.OutCubic*/}    }

    Scale3D {
        id: rightRearWheelPulse
        scale: 1.0
        origin: Qt.vector3d(-2.120, 0.536, -2.110 /* -? */)
    }
    SequentialAnimation { id: rightRearWheelPulseAnimation; /*running: true; loops: Animation.Infinite*/
        NumberAnimation { target: rightRearWheelPulse; property: "scale"; from: 1.0;  to: 1.05; duration: 200; /*easing.type: Easing.OutBounce*/}
        NumberAnimation { target: rightRearWheelPulse; property: "scale"; from: 1.05; to: 0.9;  duration: 200; /*easing.type: Easing.OutCubic*/}
        NumberAnimation { target: rightRearWheelPulse; property: "scale"; from: 0.9;  to: 1.0;  duration: 200; /*easing.type: Easing.OutCubic*/}    }
}
