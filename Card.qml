import QtQuick
import QtQuick.Controls
import QtQuick.Effects

Rectangle {
    property alias angle: rotation.angle
    property alias image: image.source
    property alias content: label.text
    antialiasing:true
    id:rect
    width: 200
    height: 100
    radius: 10
    clip:true

    transform:
        // 用于旋转
        Rotation {
        id: rotation
        origin.x: rect.width / 2
        origin.y: rect.height / 2
        axis { x: 0; y: 1; z: 0 } // 沿y轴旋转
        Behavior on angle { SpringAnimation { spring: 2; damping: 0.2 } }
    }
    opacity: 0.7
    // 弹簧动画
    Behavior on x { SpringAnimation { spring: 2; damping: 0.2 } }
    Behavior on y { SpringAnimation { spring: 2; damping: 0.2 } }

    Column {
        anchors.top: rect.top
        anchors.left: rect.left
        anchors.right: rect.right
        anchors.bottom: rect.bottom
        anchors.margins: 10
        spacing: 10
        Item {
            id:avatarItem
            width: parent.height /2
            anchors.horizontalCenter: parent.horizontalCenter
            height: width
            Image {
                id:image
                anchors.fill: parent
                asynchronous: true
                cache: true
                fillMode: Image.PreserveAspectCrop
                source: "qrc:/qt-logo.png"
                visible: false
                antialiasing: true
            }
            // 图片圆角效果
            MultiEffect {
                source: image
                anchors.fill: image
                maskEnabled: true
                maskSource: mask
                antialiasing: true
            }
            Item {
                id: mask
                width: image.width
                height: image.height
                layer.enabled: true
                visible: false
                antialiasing: true
                Rectangle {
                    width: image.width
                    height: image.height
                    radius: 10
                    color: "black"
                }
            }
        }


        Label {
            id:label
            anchors.horizontalCenter: parent.horizontalCenter
            text:"UWillno"
            wrapMode: Label.WrapAnywhere
        }
    }
}
