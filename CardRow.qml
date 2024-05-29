import QtQuick

Rectangle {
    id:row
    property alias model: repeater.model
    // 卡片角度
    property real ang: -30
    // 卡片的视觉宽度
    property real visualWidth: getVisualWidth(ang)
    // 拖动时的最大角度
    property real maxAngle: -10
    // 拖动时的最小角度
    property real minAngle: -85
    // 角度变化时的步长
    property real angleStepSize: 5
    // 卡片的大小
    property real cardWidth: 200
    property real cardHeight: 150
    // 首张卡片的位置
    property real firstX: 20
    property real firstY: 40
    // 首长卡片与次张卡片的间距
    property real firstSpacing: visualWidth *2/3
    // 横轴卡片间距
    // property real spacingX: 25
    property real spacingX: Math.max(25,(parent.width - visualWidth*count)/count)
    // 纵轴卡片间距
    property real spacingY: 10
    // 上浮高度
    property real drift: -cardHeight/5
    // 模型长度
    property int count: repeater.model.length
    // 首长卡片的索引
    property int firstItemIndex : 0
    // 可以下拉信号
    signal canPull(var cardItem)
    // 取消下拉信号
    signal cancelPull()
    // 可以推送信号
    signal canPush()
    // 推送信号
    signal pushing(var url)

    // 启用图层和提高采样 抗锯齿
    layer.enabled: true
    layer.samples: 8


    Repeater {
        anchors.fill: parent
        id:repeater

        delegate: Card {
            id:card
            // 模型数据
            required property var modelData
            // repeater中的索引
            required property int index
            // 虚拟索引 用于计算实际位置
            property int virtualIndex: index

            width: cardWidth
            height: cardHeight
            image: modelData.img

            // 根据虚拟索引判断具体在哪一层
            z: parent.count - virtualIndex
            x: firstX + spacingX*virtualIndex + firstSpacing * (virtualIndex >=1 ? 1 :0)
            // 鼠标在里面时上浮
            y: mouseArea.containsMouse ?  firstY  + spacingY*virtualIndex + drift :  firstY  + spacingY*virtualIndex
            // 鼠标在里面且为首项时回正
            angle:mouseArea.containsMouse && index === firstItemIndex  ? 0: ang

            content :modelData.text
            // 边框
            border.width: 4
            border.color: "gray"
            // 颜色梯度 预设随机数
            gradient: logic.getRandomGradient()

            MouseArea{
                id:mouseArea
                anchors.fill: parent
                // 防止窃取
                preventStealing: true
                // 启用悬停
                hoverEnabled: true
                // 记录按住时y起始坐标
                property real yStart: 0
                // 是否追踪
                property bool tracing: false
                // 按住不动信号触发的事件
                pressAndHoldInterval: 500

                onClicked: {
                    // 与第一个组件交换位置
                    const tempIndex = repeater.itemAt(firstItemIndex).virtualIndex
                    repeater.itemAt(firstItemIndex).virtualIndex = card.virtualIndex
                    card.virtualIndex = tempIndex
                    firstItemIndex = card.index
                }
                onPressAndHold:  (mouse)=>{
                                     tracing = true
                                     yStart = mouse.y
                                 }

                onPositionChanged: (mouse)=>{
                                       if ( !tracing ) return
                                       // 有下移就发射canPull，否则发射cancelPull
                                       if(mouse.y-yStart > 0){
                                           canPull(card)
                                           // 达到能push的下移距离 发射canPush
                                           if(Math.abs(mouse.y-yStart) > cardHeight/2){
                                               canPush()
                                           }
                                       }
                                       else
                                       cancelPull()
                                   }
                onReleased: (mouse)=>{
                                // 松开时达到push要求 就发射pushing
                                if(Math.abs(mouse.y-yStart) > cardHeight/2){
                                    pushing(modelData.url)
                                }
                                // 还原
                                cancelPull()
                                tracing = false
                            }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        preventStealing: true
        property real xStart: 0
        property bool tracing: false
        onPressed: (mouse)=>{
                       tracing = true
                       xStart = mouse.x
                   }
        onPositionChanged: (mouse)=>{
                               if ( !tracing ) return
                               const displacement = mouse.x-xStart
                               if(displacement < 0 && Math.abs(displacement) > visualWidth/10){
                                   cutAngle()

                               }else if(displacement > 0 && Math.abs(displacement) > visualWidth/10){
                                   addAngle()
                               }
                           }

        onReleased: (mouse)=>{
                        tracing = false
                    }
    }
    // 角度增加
    function addAngle(){
        if(ang!==maxAngle)
            ang += angleStepSize
    }
    // 角度减少
    function cutAngle(){
        if(ang!==minAngle)
            ang -= angleStepSize
    }
    // 计算视觉宽度
    function getVisualWidth(angle) {
        var radian = angle * Math.PI / 180;
        return Math.abs(cardWidth * Math.cos(radian))
    }

}
