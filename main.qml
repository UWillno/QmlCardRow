import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
ApplicationWindow {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")
    header: ToolBar {
        ToolButton {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "<"
            font.pointSize: 22
            visible: stack.depth !== 1
            onClicked: stack.pop()
        }
    }
    // 通用方法
    Logic {
        id:logic
    }
    StackView {
        id:stack
        anchors.fill: parent
        initialItem: CustomPage{ }
        // push和pop时的动画
        pushEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to:1
                duration: 200
            }
        }
        pushExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to:0
                duration: 200
            }
        }
        popEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to:1
                duration: 200
            }
        }
        popExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to:0
                duration: 200
            }
        }

    }

}
