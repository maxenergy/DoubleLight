/*!
 *@file QmlCircularProgress.qml
 *@brief Qml圆形进度条
 *@version 1.0
 *@section LICENSE Copyright (C) 2003-2103 CamelSoft Corporation
 *@author zhengtianzuo
*/
import QtQuick 2.4

Canvas {
    property color arcColor: "#148014"
    property color arcBackgroundColor: "#AAAAAA"
    property int arcWidth: 2
    property real progress: 0
    property real radius: 35
    property bool anticlockwise: false
   /// property alias interval: timer.interval

    id: canvas
    width: 2*radius + arcWidth
    height: 2*radius + arcWidth

    onProgressChanged: requestPaint();


    onPaint: {
        var ctx = getContext("2d")
        ctx.clearRect(0,0,width,height)
        ctx.beginPath()
        ctx.strokeStyle = arcBackgroundColor
        ctx.lineWidth = arcWidth
        ctx.arc(width/2,height/2,radius,0,Math.PI*2,anticlockwise)
        ctx.stroke()

        var r = progress*360*Math.PI/180
        ctx.beginPath()
        ctx.strokeStyle = arcColor
        ctx.lineWidth = arcWidth

        ctx.arc(width/2,height/2,radius,0-90*Math.PI/180,r-90*Math.PI/180,anticlockwise)
        ctx.stroke()
    }
}
