import QtQuick.Controls 2.5
import QtQuick 2.0
import QtGraphicalEffects 1.12
import QtQuick.Dialogs 1.3
import Qt.labs.settings 1.0
import "simpleControl"
import UpdateProgressC 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "dialog"
import QtQuick.Controls.Styles 1.4
Rectangle {
    id: root
    
    signal s_timeSwith(bool mchecked);
    signal s_warnSwith(bool mchecked);
    signal s_screenShotSwith(bool mchecked);
    signal s_beerSwith(bool mchecked);
    signal s_recordSwith(bool mchecked);
    signal s_temSet(var mvalue);
    signal s_screenShotPathSet(var mvalue);
    signal s_recordPathSet(var mvalue);
    //    signal s_temDrift(var mvalue);
    
    signal s_getInitPar();
    
    signal s_temOffset(var mvalue);
    signal s_temMax(var mvalue);
    signal s_temMin(var mvalue);
    signal s_temImage(var mvalue);
    
    
    property bool isCreate: false
    
    signal s_sendcommoncmd(var mvalue);
    signal s_deviceUpdate()
    
    
    property int fontSize: curLanguage ===lKhmer?28:14
    property int lineeditfontSize: 14
    property color fontColor: "#333333"
    
    
    
    property string curDevTypeStr:"E03"
    //第一根左对齐线
    property int parSetFirstAlignLine: curLanguage === lChinese?134:curLanguage === lEnglish?230:curLanguage === lKorean?204:curLanguage ===lRussian?210:300
    property int parSetSecondAlignLine: curLanguage === lChinese?368:curLanguage === lEnglish?488:curLanguage === lKorean?388:curLanguage ===lRussian?538:700
    
    property int tempdriftcapMax: 2
    property int tempdriftcapMin: -2
    property int tempcontrolcapMax: 6
    property int tempcontrolcapMin: 0
    
    property int imagparammirror: -1
    property int imagparamflip: -1
    property int imagparambrightness: -1
    property int imagparamcolorsaturation:-1
    property int imagparamcontrast: -1
    property int imagparamhue: -1
    property int imagparamsharpness: -1
    property int imagparamwdr: -1
    property bool wdrisChange: false
    
    Settings {
        id:setting
        
        fileName: "config.ini"
        
        property alias recordPath: inputRecordPath.text
        property alias screenShotPath: inputScreenShotPath.text
        property alias temDrift:inputTempDrift.text
        property alias tempMin: inputTempMin.text
        //property alias tempMax: inputTempMax.text
        property alias warnTem:inputTem.text
        //property alias switchTime:swithTime.checked
        property alias switchWarn:swichWarn.checked
        property alias switchScreenShot:swichScreenShot.checked
        property alias switchBeer:swichBeer.checked
        property bool switchRecord:true
        
        //   if(swithTime.checked)
        //        osdenableV = 1
        //    else
        //        osdenableV = 0
        //    var alarmtempEnableV;
        //    if(swichWarn.checked)
        //        alarmtempEnableV = 1;
        //    else
        //        alarmtempEnableV = 0;
        //        var map ={
        //            osdenable:osdenableV,
        //            alarmtempEnable:alarmtempEnableV,
        //            alarmtemp:inputTem.text,
        //            tempdrift:inputTempDrift.text,
        //            tempcontrol:inputTempMin.text,
        //            cmd:"setiradinfo"
        //        }
        
        
        property alias updateFilePath:inputUpdatePath.text
        
        //irc 图像选择
        // property alias ircImgColorType: cmbImgSelect.currentIndex
        
        property string tcpip:"192.168.1.188"
        property bool isOpenAdjustRect: true
        property int e03showRectX: 65;
        property int e03showRectY : 41;
        property int e03showRectW : 349;
        property int e03showRectH : 327;
        property int e03showParentW : 494;
        property int e03showParentH : 369;
        
        property int f03showRectX: 65;
        property int f03showRectY : 41;
        property int f03showRectW : 349;
        property int f03showRectH : 327;
        property int f03showParentW : 494;
        property int f03showParentH : 369;
        
        property int d06showRectX: 65;
        property int d06showRectY : 41;
        property int d06showRectW : 349;
        property int d06showRectH : 327;
        property int d06showParentW : 494;
        property int d06showParentH : 369;
        
        property int d04showRectX: 65;
        property int d04showRectY : 41;
        property int d04showRectW : 349;
        property int d04showRectH : 327;
        property int d04showParentW : 494;
        property int d04showParentH : 369;
    }
    
    
    Component.onCompleted: {
        
        setting.screenShotPath =  screenv.funIsExitCurCapturePath(setting.screenShotPath)
        setting.recordPath = screenv.funIsExitCurRecordPath(setting.recordPath)
    }
    
    Rectangle{
        width: parent.width
        height: parent.height - mDeviceStateBar.height
        
        color: "#DFE1E6"
        MouseArea{
            anchors.fill: parent
        }
        
        Component.onCompleted: isCreate = true;
        
        Rectangle{
            id:rectcontent
            width: parent.width-40
            height: parent.height -40
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            color: "#F8FAFD"
            
            ScrollView{
                id:scroll
                width: rectcontent.width
                height: rectcontent.height
                
                horizontalScrollBarPolicy:Qt.ScrollBarAlwaysOff
                //frameVisible:true
                style: ScrollViewStyle{
                    
                    incrementControl:null
                    decrementControl :null
                    
                    scrollBarBackground :Rectangle{
                        
                        color: "#F8FAFD"
                        height: scroll.height
                        width: 10
                    }
                    
                    handle:Rectangle{
                        color: "#989898"
                        implicitWidth: 10
                        implicitHeight: 10
                        width: 10
                        height: 20
                        radius: 5
                        visible: styleData.hovered
                    }
                }
                Rectangle {
                    id: rect
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: rectcontent.width
                    height: 920
                    color: "#F8FAFD"
                    
                    Text {
                        id: labelTime
                        font.pixelSize: fontSize
                        color: fontColor
                        text: qsTr("时间设置")
                        anchors.bottom: lineTime.top
                        anchors.left: lineTime.left
                        anchors.bottomMargin: 20

                    }

                    Rectangle{
                        id:lineTime
                        width: parent.width - 20*2
                        height: 1
                        color: "#e2e2e2"
                        anchors.top: parent.top
                        anchors.topMargin: 62
                        anchors.horizontalCenter: parent.horizontalCenter

                    }

                    Text {
                        id: labelSwitchTime
                        text: qsTr("时间同步")
                        font.pixelSize: fontSize
                        color: fontColor
                        anchors.right: rectTimeSynchronization.left
                        anchors.rightMargin: 20
                        anchors.verticalCenter: rectTimeSynchronization.verticalCenter
                    }

                    Rectangle{
                        id:rectTimeSynchronization
                        anchors.left: lineTime.left
                        anchors.leftMargin: parSetFirstAlignLine
                        anchors.top: lineTime.bottom
                        anchors.topMargin: 20
                        width: 44
                        height: 22
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "#5D9CFF"}
                            GradientStop { position: 1.0; color: "#2D76E7"}
                        }
                        Image{
                            id:imgTimeSynchronization
                            width: 14
                            height: 14
                            source: "qrc:/images/deviceFlush.png"
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                var map = {
                                    cmd:"setcurrenttime"
                                }
                                s_sendcommoncmd(map);
                            }
                            onPressed: imgTimeSynchronization.source = "qrc:/images/deviceFlush_h.png"
                            onReleased: imgTimeSynchronization.source = "qrc:/images/deviceFlush.png"
                        }
                    }
                    
                    Text {
                        id: txtparset
                        font.pixelSize: fontSize
                        color: fontColor
                        text: qsTr("参数设置")
                        
                        anchors.bottom: line2.top
                        anchors.left: line2.left
                        anchors.bottomMargin: 20
                    }
                    Rectangle{
                        id:line2
                        width:parent.width - 20*2
                        height: 1
                        color: "#e2e2e2"
                        anchors.top: parent.top
                        anchors.topMargin: 187
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    
                    Text {
                        id: txtTempDrift
                        text: qsTr("温漂设置")
                        color: fontColor
                        font.pixelSize: fontSize
                        anchors.right: rectTempDrift.left
                        anchors.rightMargin: 20
                        anchors.verticalCenter: rectTempDrift.verticalCenter
                    }
                    
                    Rectangle{
                        id:rectTempDrift
                        color: "#D6D8DB"
                        width: 88
                        height: 32
                        radius: 4
                        anchors.left: line2.left
                        anchors.leftMargin: parSetFirstAlignLine
                        anchors.top: line2.bottom
                        anchors.topMargin: 20
                        LineEdit {
                            id: inputTempDrift
                            width: rectTempDrift.width  - 22
                            height: rectTempDrift.height -2
                            anchors.left: parent.left
                            anchors.leftMargin: 1
                            anchors.verticalCenter: rectTempDrift.verticalCenter
                            border.width: 0
                            inputLimite:Qt.ImhDigitsOnly
                            font.pixelSize: fontSize
                            placeholderText: ""
                            isNeedDoubleClickEdit: false
                            textLeftPadding:0
                            txtColor: Qt.rgba(0,0,0,0.65)
                            text: "0"
                            color: "#F8FAFD"
                            isReadOnly:true
                            onTextChanged: {
                                s_temOffset(inputTempDrift.text);
                                
                            }
                        }
                        Image {
                            id: imgValueUp
                            width: 20
                            height: 15
                            source: "qrc:/images/arrow_up.png"
                            anchors.right: parent.right
                            anchors.rightMargin: 1
                            anchors.top: parent.top
                            anchors.topMargin: 1
                            MouseArea{
                                anchors.fill: parent
                                onPressed: {
                                    imgValueUp.source="qrc:/images/arrow_up_p.png"
                                    var num = parseInt(inputTempDrift.text)
                                    if(num >= tempdriftcapMax)
                                        return
                                    
                                    inputTempDrift.text = ""+(Number(num)+Number(1))
                                    
                                }
                                onReleased: imgValueUp.source="qrc:/images/arrow_up.png"
                            }
                        }
                        Image {
                            id: imgValuedown
                            width: 20
                            height: 15
                            source: "qrc:/images/arrow_low.png"
                            anchors.right: imgValueUp.right
                            anchors.top: imgValueUp.bottom
                            anchors.topMargin: 1
                            MouseArea{
                                anchors.fill: parent
                                
                                onPressed: {
                                    
                                    imgValuedown.source="qrc:/images/arrow_low_p.png"
                                    var num = parseInt(inputTempDrift.text)
                                    
                                    if(num <= tempdriftcapMin)
                                        return
                                    
                                    inputTempDrift.text = ""+(Number(num)-Number(1))
                                }
                                onReleased: imgValuedown.source="qrc:/images/arrow_low.png"
                            }
                        }
                    }
                    
                    //            Text {
                    //                id: txtTemp
                    //                text: qsTr(" ℃")
                    //                color: fontColor
                    //                font.pixelSize: fontSize
                    //                anchors.verticalCenter: rectTempDrift.verticalCenter
                    //                anchors.left: rectTempDrift.right
                    //                anchors.topMargin: 6
                    //            }
                    
                    ////////////
                    Text {
                        id: txtTempMin
                        text: qsTr("温度控制阀")
                        color: fontColor
                        font.pixelSize: fontSize
                        anchors.right: rectTempMin.left
                        anchors.rightMargin: 20
                        anchors.verticalCenter: rectTempMin.verticalCenter
                        
                    }
                    
                    Rectangle{
                        id:rectTempMin
                        color: "#D6D8DB"
                        width: 88
                        height: 32
                        radius: 4
                        anchors.left: line2.left
                        anchors.top:line2.bottom
                        anchors.topMargin: 73
                        anchors.leftMargin: parSetFirstAlignLine
                        LineEdit {
                            id: inputTempMin
                            width: rectTempMin.width  - 22
                            height: rectTempMin.height -2
                            anchors.left: parent.left
                            anchors.leftMargin: 1
                            anchors.verticalCenter: rectTempMin.verticalCenter
                            border.width: 0
                            inputLimite:Qt.ImhDigitsOnly
                            font.pixelSize: fontSize
                            placeholderText: ""
                            isNeedDoubleClickEdit: false
                            textLeftPadding:0
                            txtColor: Qt.rgba(0,0,0,0.65)
                            text: "4"
                            isReadOnly:true
                            color: "#F8FAFD"
                            onTextChanged: {
                                
                                var tempv ;
                                if(inputTempMin.text === "1")
                                    s_temMin("21");
                                else if(inputTempMin.text === "2")
                                    s_temMin("24");
                                else if(inputTempMin.text === "3")
                                    s_temMin("26");
                                else if(inputTempMin.text === "4")
                                    s_temMin("28");
                                else if(inputTempMin.text === "5")
                                    s_temMin("30");
                                else if(inputTempMin.text === "6")
                                    s_temMin("32");
                                
                                
                            }
                        }
                        
                        Image {
                            id: imgValueMinUp
                            width: 20
                            height: 15
                            source: "qrc:/images/arrow_up.png"
                            anchors.right: parent.right
                            anchors.rightMargin: 1
                            anchors.top: parent.top
                            anchors.topMargin: 1
                            MouseArea{
                                anchors.fill: parent
                                onPressed: {
                                    imgValueMinUp.source="qrc:/images/arrow_up_p.png"
                                    var num = parseInt(inputTempMin.text)
                                    if(num >= tempcontrolcapMax)
                                        return
                                    
                                    inputTempMin.text = ""+(Number(num)+Number(1))
                                }
                                onReleased: imgValueMinUp.source="qrc:/images/arrow_up.png"
                            }
                        }
                        Image {
                            id: imgValueMindown
                            width: 20
                            height: 15
                            source: "qrc:/images/arrow_low.png"
                            anchors.right: imgValueMinUp.right
                            anchors.top: imgValueMinUp.bottom
                            anchors.topMargin: 1
                            MouseArea{
                                anchors.fill: parent
                                
                                onPressed: {
                                    
                                    imgValueMindown.source="qrc:/images/arrow_low_p.png"
                                    var num = parseInt(inputTempMin.text)
                                    
                                    if(num <= tempcontrolcapMin)
                                        return
                                    
                                    inputTempMin.text = ""+(Number(num)-Number(1))
                                }
                                onReleased: imgValueMindown.source="qrc:/images/arrow_low.png"
                            }
                        }
                        
                    }
                    
                    //            Text {
                    //                id: txtTemp1
                    
                    //                text: qsTr(" ℃")
                    //                color: fontColor
                    //                font.pixelSize: fontSize
                    //                anchors.verticalCenter: rectTempMin.verticalCenter
                    //                anchors.left: rectTempMin.right
                    //                anchors.topMargin: 6
                    
                    //            }
                    
                    
                    Text {
                        id: txtSwichWarn
                        text: qsTr("报警开关")
                        font.pixelSize: fontSize
                        color: fontColor
                        anchors.right: swichWarn.left
                        anchors.rightMargin: 20
                        anchors.verticalCenter: swichWarn.verticalCenter
                        
                    }
                    
                    SimpleSwich{
                        id:swichWarn
                        width: 30
                        height: 15
                        anchors.left: line2.left
                        anchors.leftMargin: parSetFirstAlignLine
                        anchors.top: line2.bottom
                        anchors.topMargin: 125
                        onCheckedChanged:{
                            
                            // s_warnSwith(checked)
                        }
                    }
                    Text {
                        id: txtWarnTemSet
                        text: qsTr("告警温度设置")
                        color: fontColor
                        font.pixelSize: fontSize
                        anchors.right: inputTem.left
                        anchors.rightMargin: 20
                        anchors.verticalCenter: swichWarn.verticalCenter
                        
                    }
                    LineEdit {
                        id: inputTem
                        width: 88
                        height: 28
                        anchors.left: line2.left
                        anchors.leftMargin: parSetSecondAlignLine
                        anchors.verticalCenter:swichWarn.verticalCenter
                        border.width: 1
                        border.color: "#DEDFE3"
                        font.pixelSize: fontSize
                        placeholderText: ""
                        isNeedDoubleClickEdit: false
                        textLeftPadding:0
                        txtColor: Qt.rgba(0,0,0,0.65)
                        
                        text: "38"
                        color: "#F8FAFD"
                        validator: RegExpValidator { regExp:  /(\d{1,3})([.,]\d{1,1})?$/ }
                        //inputmask:"^-?(180|1?[0-7]?\\d(\\.\\d{1,1})?)$"//"00.0"
                        onTextChanged: {
                            
                            s_temSet(inputTem.text)
                        }
                    }
                    
                    Text {
                        id: txtTem1
                        text: cmbTempTypeSelect.currentIndex === 0 ?qsTr("℃"):qsTr("℉")
                        font.pixelSize: fontSize
                        color: fontColor
                        anchors.left: inputTem.right
                        anchors.leftMargin: 6
                        anchors.verticalCenter: inputTem.verticalCenter
                    }
                    
                    Text {
                        id: txtSwichScreenShot
                        text: qsTr("抓拍开关")
                        font.pixelSize: fontSize
                        color: fontColor
                        anchors.right: swichScreenShot.left
                        anchors.rightMargin: 20
                        anchors.verticalCenter: swichScreenShot.verticalCenter
                    }
                    SimpleSwich{
                        id:swichScreenShot
                        width: 30
                        height: 15
                        anchors.left: line2.left
                        anchors.leftMargin: parSetFirstAlignLine
                        anchors.top: line2.bottom
                        anchors.topMargin: 172
                        onCheckedChanged: s_screenShotSwith(checked)
                    }
                    
                    Text {
                        id: txtScreenShotPath
                        text: qsTr("抓拍存储路径")
                        font.pixelSize: fontSize
                        color: fontColor
                        anchors.right: rectScreenShotPath.left
                        anchors.rightMargin: 20
                        anchors.verticalCenter: swichScreenShot.verticalCenter
                    }
                    Rectangle{
                        id:rectScreenShotPath
                        color: "#F8FAFD"
                        border.color: "#DEDFE3"
                        border.width: 1
                        width: 200
                        height: 28
                        anchors.left: line2.left
                        anchors.leftMargin: parSetSecondAlignLine
                        anchors.verticalCenter: swichScreenShot.verticalCenter
                        LineEdit {
                            id: inputScreenShotPath
                            width: rectScreenShotPath.width - imgScreenShotPath.width - 22
                            height: rectScreenShotPath.height -2
                            anchors.left: parent.left
                            anchors.leftMargin: 2
                            
                            anchors.verticalCenter: rectScreenShotPath.verticalCenter
                            border.width: 0
                            text:screenv.funGetCurPath()
                            font.pixelSize: fontSize
                            placeholderText: ""
                            isNeedDoubleClickEdit: false
                            textLeftPadding:0
                            txtColor: Qt.rgba(0,0,0,0.65)
                            color: "#F8FAFD"
                            //onTextChanged: s_screenShotPathSet(inputScreenShotPath.text)
                        }
                        Image {
                            id: imgScreenShotPath
                            width: 16
                            height: 13
                            source: "qrc:/images/file.png"
                            anchors.right: parent.right
                            anchors.rightMargin: 10
                            anchors.verticalCenter: parent.verticalCenter
                            MouseArea{
                                anchors.fill: parent
                                onPressed: {
                                    imgScreenShotPath.source = "qrc:/images/fileopen.png"
                                }
                                
                                onReleased: {
                                    imgScreenShotPath.source = "qrc:/images/file.png"
                                }
                                
                                onClicked: {
                                    fileDialog.folder = "file:///"+inputScreenShotPath.text
                                    fileDialog.pathname = "screenShotPath";
                                    fileDialog.setSelectFolder(true)
                                    fileDialog.open()
                                }
                            }
                        }
                    }
                    
                    Text {
                        id: txtSwichBeer
                        text: qsTr("蜂鸣开关")
                        font.pixelSize: fontSize
                        color: fontColor
                        anchors.right: swichBeer.left
                        anchors.rightMargin: 20
                        anchors.verticalCenter: swichBeer.verticalCenter
                    }
                    SimpleSwich{
                        id:swichBeer
                        width: 30
                        height: 15
                        anchors.left: line2.left
                        anchors.leftMargin: parSetFirstAlignLine
                        anchors.top: line2.bottom
                        anchors.topMargin:218
                        onCheckedChanged:{
                            
                            //s_beerSwith(checked)
                        }
                    }
                    
                    //                    Text {
                    //                        id: txtencodetype
                    //                        text: qsTr("编码方式")
                    //                        font.pixelSize: fontSize
                    //                        color: fontColor
                    //                        anchors.right: checkh264.left
                    //                        anchors.rightMargin: 20
                    //                        anchors.verticalCenter: checkh264.verticalCenter
                    //                    }
                    //                    ExclusiveGroup { id: buttonGroup }
                    //                    SimpleCheckedButton{
                    //                        id:checkh264
                    //                        exclusiveGroup:buttonGroup
                    //                        txtFont.pixelSize: fontSize
                    //                        txtColor: fontColor
                    //                        imgW: 12
                    //                        imgH: 12
                    //                        imgSrc: "qrc:/images/unselect.png"
                    //                        imgCheckSrc: "qrc:/images/select.png"
                    //                        anchors.left: line2.left
                    //                        anchors.leftMargin: parSetFirstAlignLine
                    //                        anchors.top: line2.bottom
                    //                        anchors.topMargin:263
                    //                        color: "#F8FAFD"
                    //                        text: "H264"
                    //                    }
                    //                    SimpleCheckedButton{
                    //                        id:checkh265
                    //                        exclusiveGroup:buttonGroup
                    //                        txtFont.pixelSize: fontSize
                    //                        txtColor: fontColor
                    //                        imgW: 12
                    //                        imgH: 12
                    //                        imgSrc: "qrc:/images/unselect.png"
                    //                        imgCheckSrc: "qrc:/images/select.png"
                    //                        anchors.left: checkh264.right
                    //                        anchors.leftMargin: 20
                    //                        anchors.verticalCenter: checkh264.verticalCenter
                    //                        color: "#F8FAFD"
                    //                        text: "H265"
                    //                    }
                    
                    
                    SimpleSwich{
                        id:swichKuandongtai
                        width: 30
                        height: 15
                        anchors.left: line2.left
                        anchors.leftMargin: parSetFirstAlignLine
                        anchors.top: line2.bottom
                        anchors.topMargin:263
                        
                    }
                    
                    Text {
                        id: txtKuandongtai
                        text: qsTr("WDR")
                        font.pixelSize: fontSize
                        color: fontColor
                        anchors.right: swichKuandongtai.left
                        anchors.rightMargin: 20
                        anchors.verticalCenter: swichKuandongtai.verticalCenter
                        
                    }
                    
                    
                    
                    Text {
                        id: labelResolution
                        text: qsTr("°C/°F")
                        font.pixelSize: fontSize
                        color: fontColor
                        anchors.right: cmbTempTypeSelect.left
                        anchors.rightMargin: 20
                        anchors.verticalCenter: cmbTempTypeSelect.verticalCenter
                    }
                    
                    ListModel{
                        id:reTempTypeSelectModel
                        ListElement{showStr:"℃"}
                        ListElement{showStr:"℉"}
                    }
                    
                    MyComBox{
                        id:cmbTempTypeSelect
                        width:88
                        height: 28
                        anchors.left: line2.left
                        anchors.leftMargin: parSetSecondAlignLine
                        anchors.verticalCenter: swichKuandongtai.verticalCenter
                        contentBg: "#ffffff"
                        itemColorBgNor:"#FFFFFF"
                        itemColorBgHoverd: "#E7EAF1"
                        indicatorImgSrc:"qrc:/images/imgTypeSelect.png"
                        indicatorW: 9
                        indicatorH: 5
                        itemLeftMargin:0
                        itemTopMargin:0
                        itemFontColor: "#5A5E66"
                        contentFontColor: "#a6000000"
                        contentFontSize: lineeditfontSize
                        bordColor:"#DEDFE3"
                        mRadius:2
                        model: reTempTypeSelectModel
                        
                        onCurrentIndexChanged: {
                            
                            if(cmbTempTypeSelect.currentIndex === 1){
                                // (F（华氏知度）-32)÷1.8
                                
                                console.debug("*********    "+inputTem.text)
                                var tempStr = inputTem.text
                                console.debug("*********    "+tempStr)
                                var tempS = parseFloat(tempStr);
                                console.debug("*********    "+tempS)
                                var tempH = tempS*1.8+32
                                console.debug("*********    "+tempH)
                                inputTem.text = tempH.toFixed(2)
                            }else {
                                var tempStr1 = inputTem.text
                                var tempH1 = parseFloat(tempStr1);
                                var tempS1 = (tempH1 - 32)/1.8
                                inputTem.text = tempS1.toFixed(2)
                            }
                        }
                    }
                    
                    

                    SimpleSwich{
                        id:swichMask
                        width: 30
                        height: 15
                        anchors.left: line2.left
                        anchors.leftMargin: parSetFirstAlignLine
                        anchors.top: line2.bottom
                        anchors.topMargin:303

                    }

                    Text {
                        id: txtMask
                        text: qsTr("口罩告警")
                        font.pixelSize: fontSize
                        color: fontColor
                        anchors.right: swichMask.left
                        anchors.rightMargin: 20
                        anchors.verticalCenter: swichMask.verticalCenter
                    }

                    
                    Text {
                        id: txtRecordSet
                        text: qsTr("录像设置")
                        color: fontColor
                        font.pixelSize: fontSize
                        anchors.bottom: line3.top
                        anchors.left: line3.left
                        anchors.bottomMargin: 20
                    }
                    
                    Rectangle{
                        id:line3
                        width: parent.width - 20*2
                        height: 1
                        color: "#e2e2e2"
                        anchors.top: parent.top
                        anchors.topMargin: 580
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    
//                    Text {
//                        id: txtSwichRecord
//                        text: qsTr("录像开关")
//                        color: fontColor
//                        font.pixelSize: fontSize
//                        anchors.verticalCenter: swichRecord.verticalCenter
//                        anchors.right: swichRecord.left
//                        anchors.rightMargin: 20
//                    }
//                    SimpleSwich{
//                        id:swichRecord
//                        width: 30
//                        height: 15
//                        anchors.left: line3.left
//                        anchors.leftMargin: parSetFirstAlignLine
//                        anchors.top: line3.bottom
//                        anchors.topMargin: 27
//                        onCheckedChanged: s_recordSwith(checked)
//                    }
                    
                    Text {
                        id: txtRecortPath
                        text: qsTr("录像存储路径")
                        color: fontColor
                        font.pixelSize: fontSize
                        anchors.right: rectRecordPath.left
                        anchors.rightMargin: 20
                        anchors.verticalCenter: rectRecordPath.verticalCenter
                    }
                    Rectangle{
                        id:rectRecordPath
                        color: "#F8FAFD"
                        border.color: "#DEDFE3"
                        border.width: 1
                        width: 200
                        height: 28
                        anchors.left: line3.left
                        anchors.leftMargin: parSetFirstAlignLine
                                                anchors.top: line3.bottom
                                                anchors.topMargin: 27
                        LineEdit {
                            id: inputRecordPath
                            width: rectRecordPath.width - imgRecordPath.width - 22
                            height: rectRecordPath.height -2
                            anchors.left: parent.left
                            anchors.leftMargin: 2
                            
                            anchors.verticalCenter: rectRecordPath.verticalCenter
                            border.width: 0
                            text: screenv.funGetCurPath()
                            font.pixelSize: fontSize
                            placeholderText: ""
                            isNeedDoubleClickEdit: false
                            textLeftPadding:0
                            txtColor: Qt.rgba(0,0,0,0.65)
                            color: "#F8FAFD"
                            //onTextChanged: s_recordPathSet(inputRecordPath.text)
                            
                        }
                        Image {
                            id: imgRecordPath
                            width: 16
                            height: 13
                            source: "qrc:/images/file.png"
                            anchors.right: parent.right
                            anchors.rightMargin: 10
                            anchors.verticalCenter: parent.verticalCenter
                            MouseArea{
                                anchors.fill: parent
                                onPressed: {
                                    imgRecordPath.source = "qrc:/images/fileopen.png"
                                }
                                onReleased: {
                                    imgRecordPath.source = "qrc:/images/file.png"
                                }
                                onClicked: {
                                    fileDialog.folder = "file:///"+inputRecordPath.text
                                    fileDialog.pathname = "recordPath";
                                    fileDialog.setSelectFolder(true)
                                    fileDialog.open()
                                }
                            }
                        }
                    }
                    
                    
                    
                    Text {
                        id: txtImageSet
                        font.pixelSize: fontSize
                        text: qsTr("图像设置")
                        color: fontColor
                        visible: true//curDevTypeStr==="J07"
                        anchors.bottom: line4.top
                        anchors.left: line4.left
                        anchors.bottomMargin: 20
                    }
                    
                    Rectangle{
                        id:line4
                        width:parent.width - 20*2
                        height: 1
                        visible: true//curDevTypeStr==="J07"
                        color: "#e2e2e2"
                        anchors.top: parent.top
                        anchors.topMargin: 820
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    
                    Text {
                        id: txtImageSelect
                        font.pixelSize: fontSize
                        text: qsTr("图像选择")
                        color: fontColor
                        visible: true//curDevTypeStr==="J07"
                        anchors.right: cmbImgSelect.left
                        anchors.rightMargin: 20
                        anchors.verticalCenter: cmbImgSelect.verticalCenter
                    }
                    
                    MyComBox{
                        id:cmbImgSelect
                        width:88
                        height: 28
                        visible: true//curDevTypeStr==="J07"
                        anchors.left: line4.left
                        anchors.leftMargin: parSetFirstAlignLine
                        anchors.top: line4.bottom
                        anchors.topMargin: 20
                        contentBg: "#ffffff"
                        itemColorBgNor:"#FFFFFF"
                        itemColorBgHoverd: "#E7EAF1"
                        indicatorImgSrc:"qrc:/images/imgTypeSelect.png"
                        indicatorW: 9
                        indicatorH: 5
                        itemLeftMargin:0
                        itemTopMargin:0
                        itemFontColor: "#5A5E66"
                        contentFontColor: "#a6000000"
                        contentFontSize: fontSize
                        bordColor:"#DEDFE3"
                        mRadius:2
                        model: ListModel{
                            ListElement{showStr:"0"}//黑白
                            ListElement{showStr:"1"}//光谱
                            ListElement{showStr:"2"}//泰尔红紫
                            ListElement{showStr:"3"}//琥珀色
                        }
                        
                        onCurrentIndexChanged: {
                            //                    curLanguage = currentIndex
                            //                    main.s_setLanguage(currentIndex);
                            //s_temImage(currentIndex);
                        }
                    }
                    
                    Text {
                        id: txtUpdateFile
                        font.pixelSize: fontSize
                        text: qsTr("设备升级")
                        color: fontColor
                        //  visible: curDevTypeStr==="f03"
                        anchors.bottom: line5.top
                        anchors.left: line5.left
                        anchors.bottomMargin: 20
                    }
                    Rectangle{
                        id:line5
                        width:parent.width - 20*2
                        height: 1
                        //visible: curDevTypeStr==="f03"
                        color: "#e2e2e2"
                        anchors.top: parent.top
                        anchors.topMargin: 690
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    
                    Rectangle{
                        id:rectUpdatePath
                        color: "#F8FAFD"
                        border.color: "#DEDFE3"
                        border.width: 1
                        width: 200
                        height: 28
                        anchors.left: line5.left
                        anchors.leftMargin: 48
                        anchors.top: line5.bottom
                        anchors.topMargin: 20
                        LineEdit {
                            id: inputUpdatePath
                            width: rectUpdatePath.width - imgRecordPath.width - 22
                            height: rectUpdatePath.height -2
                            anchors.left: parent.left
                            anchors.leftMargin: 2
                            anchors.verticalCenter: rectUpdatePath.verticalCenter
                            border.width: 0
                            text: ""//screenv.funGetCurPath()
                            font.pixelSize: fontSize
                            placeholderText: ""
                            isNeedDoubleClickEdit: false
                            textLeftPadding:0
                            txtColor: Qt.rgba(0,0,0,0.65)
                            color: "#F8FAFD"
                            //onTextChanged: s_recordPathSet(inputRecordPath.text)
                        }
                        
                        Image {
                            id: imgUpdatePath
                            width: 16
                            height: 13
                            source: "qrc:/images/file.png"
                            anchors.right: parent.right
                            anchors.rightMargin: 10
                            anchors.verticalCenter: parent.verticalCenter
                            MouseArea{
                                anchors.fill: parent
                                onPressed: {
                                    imgUpdatePath.source = "qrc:/images/fileopen.png"
                                }
                                onReleased: {
                                    imgUpdatePath.source = "qrc:/images/file.png"
                                }
                                onClicked: {
                                    fileDialog.folder = "file:///"+inputUpdatePath.text
                                    fileDialog.pathname = "updatePath";
                                    fileDialog.setSelectFolder(false)
                                    fileDialog.open()
                                }
                            }
                        }
                    }
                    
                    Rectangle{
                        id:btnUpdate
                        width: txtUpdate.width +24
                        height: 28
                        color: "#3B84F6"
                        radius: 2
                        anchors.left: rectUpdatePath.right
                        anchors.leftMargin: 20
                        anchors.verticalCenter: rectUpdatePath.verticalCenter
                        Text {
                            id: txtUpdate
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            elide: Text.ElideMiddle
                            font.pixelSize: 14
                            color: "#ffffff"
                            text: qsTr("升级")
                        }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                if(screenv.funIsExitFile(inputUpdatePath.text)){
                                    askDialog.askStr = screenv.funGetFileName(inputUpdatePath.text)
                                    askDialog.curType = askDialog.fileupdate
                                    askDialog.imgSrc = "qrc:/images/icon_question.png"
                                    askDialog.width = 340
                                    askDialog.height = 176
                                    askDialog.open();
                                }
                            }
                            onPressed: btnUpdate.color = "#81C3FF"
                            onReleased: btnUpdate.color = "#3B84F6"
                        }
                    }
                    
                    
                    
                    Rectangle{
                        id:btnSave
                        width: txtSave.width +24
                        height: 28
                        color: "#3B84F6"
                        radius: 2
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 10
                        Text {
                            id: txtSave
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            elide: Text.ElideMiddle
                            font.pixelSize: 14
                            color: "#ffffff"
                            text: qsTr("设置")
                        }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                iradInfoSet();
                            }
                            onPressed: btnSave.color = "#81C3FF"
                            onReleased: btnSave.color = "#3B84F6"
                        }
                    }
                }
                
            }
        }
        
        
        
    }
    
    
    
    Rectangle{
        id:mDeviceStateBar
        width: parent.width
        height:50
        anchors.bottom: parent.bottom
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#5D9CFF"}
            GradientStop { position: 1.0; color: "#2D76E7"}
        }
    }
    
    Connections{
        target: askDialog
        onS_CurTypeMsg:{
            if(askDialog.fileupdate === type){
                s_deviceUpdate();
            }
        }
    }
    
    UpdateProgressC{
        id:updateprogress
        onSignal_updateState:{
            progressdialog.close();
            if(isSucc){
                
            }else{
                
            }
        }
        onSignal_updateProgress:progressdialog.setProgressValue(progressvalue)
    }
    
    function updateDevice(did,url,path){
        progressdialog.open();
        updateprogress.startupLoad(did,url,inputUpdatePath.text)
    }
    
    ProgressDialog{
        id:progressdialog
        width: 500
        height: 193
    }
    
    FileDialog {
        id: fileDialog
        property string pathname:""
        title: "Please choose a file path"
        selectFolder:true
        selectMultiple: false
        //folder: shortcuts.home
        onAccepted: {
            if(pathname === "recordPath"){
                var str = fileDialog.fileUrl.toString();
                inputRecordPath.text = str.replace('file:///','');
                // devicemanagerment.recordingPath = txtVedioSavePath.text
            }else if(pathname === "screenShotPath"){
                inputScreenShotPath.text = fileDialog.fileUrl.toString().replace('file:///','');
                //devicemanagerment.screenShotPath = txtscreenshotSavePath.text
            }else if(pathname === "updatePath"){
                inputUpdatePath.text = fileDialog.fileUrl.toString().replace('file:///','');
                //devicemanagerment.screenShotPath = txtscreenshotSavePath.text
            }
        }
        onRejected: {
        }
    }
    
    //            dataObj.insert("osdenable",value.value("osdenable").toInt());
    //            alarmparamObj.insert("alarmtempEnable", value.value("alarmtempEnable").toInt());
    //            alarmparamObj.insert("alarmtemp", value.value("alarmtemp").toDouble());
    //            ctrlparamObj.insert("tempdrift", value.value("tempdrift").toInt());
    //            ctrlparamObj.insert("tempcontrol", value.value("tempcontrol").toInt());
    //            dataObj.insert("alarmparam", QJsonValue(alarmparamObj));
    //            dataObj.insert("ctrlparam", QJsonValue(ctrlparamObj));
    
    
    
    function setWdr(value){
        imagparamwdr = value
        swichKuandongtai.checked = value
    }
    
    function getiradInfo(){
        var map ={cmd:"getiradinfo"}
        s_sendcommoncmd(map);
        
        map.cmd = "getalarmparam"
        s_sendcommoncmd(map);
        
        
        map.cmd = "getimagparam"
        s_sendcommoncmd(map);
        
        map.cmd = "getinftempcolor"
        s_sendcommoncmd(map);
        
    }
    
    function setTempcolor(value)
    {
        
        console.debug("********** setTempcolor  "+value)
        if(value === 1)
            cmbImgSelect.currentIndex = 0
        else if(value === 102)
            cmbImgSelect.currentIndex = 1
        else if(value === 104)
            cmbImgSelect.currentIndex = 2
        else if(value === 105)
            cmbImgSelect.currentIndex = 3
    }
    
    //参数修改设置 全在此函数
    function iradInfoSet(){
        
        var osdenableV = 0;

        var alarmtempEnableV;
        
        if(swichWarn.checked)
            alarmtempEnableV = 1;
        else
            alarmtempEnableV = 0;
        
        var maskenable = swichMask.checked?1:0
        var map ={
            osdenable:osdenableV,
            alarmtempEnable:alarmtempEnableV,
            alarmtemp:inputTem.text,
            tempdrift:inputTempDrift.text,
            tempcontrol:inputTempMin.text,
            maskenable:maskenable,
            tempdisplay:cmbTempTypeSelect.currentIndex,
            cmd:"setiradinfo"}
        
        s_sendcommoncmd(map);

        var kuandongt = swichKuandongtai.checked?1:0
        if(imagparamwdr !== kuandongt)
            wdrisChange = true
        else
            wdrisChange = false
        
        
        var map2 ={
            
            cmd:"setimagparam",
            wdr:swichKuandongtai.checked?1:0,
            mirror:imagparammirror,
            flip:imagparamflip,
            brightness:imagparambrightness,
            colorsaturation:imagparamcolorsaturation,
            contrast:imagparamcontrast,
            hue:imagparamhue,
            sharpness:imagparamsharpness
        }
        
        s_sendcommoncmd(map2);
        
        var tmpColor1 = 0;
        
        if(cmbImgSelect.currentIndex === 0)
            tmpColor1 = 1
        else if(cmbImgSelect.currentIndex === 1)
            tmpColor1 = 102
        else if(cmbImgSelect.currentIndex === 2)
            tmpColor1 = 104
        else if(cmbImgSelect.currentIndex === 3)
            tmpColor1 = 105
        
        var map3 = {
            cmd:"setinftempcolor",
            tmpColor:tmpColor1
        }
        s_sendcommoncmd(map3);
        
        
        s_beerSwith(swichBeer.checked)
        s_warnSwith(swichWarn.checked)
        s_timeSwith(swithTime.checked)
    }
    
    
    
    function setSwitchTempdisplay(mvalue)
    {
        cmbTempTypeSelect.currentIndex = mvalue
    }
    
    
    function getUpdateFilePath(){
        return setting.updateFilePath;
    }
    function getRecordPath(){
        return setting.recordPath;
    }
    function getScrennShotPath(){
        return setting.screenShotPath;
    }
    function getTemDrift(){
        return setting.temDrift
    }
    function setTemDrift(mvalue){
        inputTempDrift.text = mvalue;
    }
    
    
    function getWarnTem(){
        return setting.warnTem
    }
    function setWarnTem(mvalue){
        inputTem.text = mvalue
    }
    
    function setSwitchBeer(mvalue){
        swichBeer.checked = mvalue
    }
    
    function getSwitchWarn()
    {
        return setting.switchWarn;
    }
    
    function setSwithMask(mvalue){
        swichMask.checked = mvalue
    }

    function setSwitchWarn(mvalue)
    {
        swichWarn.checked = mvalue
    }
    
    function getSwitchTime(){
        return setting.switchTime
    }
    
    function setSwitchTime(mvalue){
        swithTime.checked = mvalue
    }
    
    function getSwitchRecord(){
        return setting.switchRecord
    }
    
    function getSwitchScreenShot(){
        return setting.switchScreenShot
    }
    
    function getSwitchBeer(){
        return setting.switchBeer
    }
    
    function setTempContrl(mavlue){
        inputTempMin.text = mavlue
    }
    
    function setTcpip(value){
        setting.tcpip = value
    }
    function setIsOpenAdjustRect(value){
        setting.isOpenAdjustRect = value
    }
    
    function setRedRect(pw,ph,rx,ry,rw,rh){
        
        if(curDevTypeStr === "e03"){
            setting.e03showParentW = pw
            setting.e03showParentH = ph
            setting.e03showRectX = rx
            setting.e03showRectY = ry
            setting.e03showRectW = rw
            setting.e03showRectH = rh
        }else if(curDevTypeStr === "f03"){
            setting.f03showParentW = pw
            setting.f03showParentH = ph
            setting.f03showRectX = rx
            setting.f03showRectY = ry
            setting.f03showRectW = rw
            setting.f03showRectH = rh
        }else if(curDevTypeStr === "d04"){
            setting.d04showParentW = pw
            setting.d04showParentH = ph
            setting.d04showRectX = rx
            setting.d04showRectY = ry
            setting.d04showRectW = rw
            setting.d04showRectH = rh
        }else if(curDevTypeStr === "d06"){
            setting.d06showParentW = pw
            setting.d06showParentH = ph
            setting.d06showRectX = rx
            setting.d06showRectY = ry
            setting.d06showRectW = rw
            setting.d06showRectH = rh
        }
    }
    
    
    function getTcpip(){
        return setting.tcpip
    }
    function getIsOpenAdjustRect(){
        return setting.isOpenAdjustRect
    }
    function getShowRectX(){
        
        if(curDevTypeStr === "e03"){
            return setting.e03showRectX
        }else if(curDevTypeStr === "f03"){
            return setting.f03showRectX
        }else if(curDevTypeStr === "d04"){
            return setting.d04showRectX
        }else if(curDevTypeStr === "d06"){
            return setting.d06showRectX
        }
    }
    function getShowRectY(){
        if(curDevTypeStr === "e03"){
            return setting.e03showRectY
        }else if(curDevTypeStr === "f03"){
            return setting.f03showRectY
        }else if(curDevTypeStr === "d04"){
            return setting.d04showRectY
        }else if(curDevTypeStr === "d06"){
            return setting.d06showRectY
        }
        
    }
    function getShowRectW(){
        if(curDevTypeStr === "e03"){
            return setting.e03showRectW
        }else if(curDevTypeStr === "f03"){
            return setting.f03showRectW
        }else if(curDevTypeStr === "d04"){
            return setting.d04showRectW
        }else if(curDevTypeStr === "d06"){
            return setting.d06showRectW
        }
    }
    
    function getShowRectH(){
        if(curDevTypeStr === "e03"){
            return setting.e03showRectH
        }else if(curDevTypeStr === "f03"){
            return setting.f03showRectH
        }else if(curDevTypeStr === "d04"){
            return setting.d04showRectH
        }else if(curDevTypeStr === "d06"){
            return setting.d06showRectH
        }
    }
    
    function getShowParentW(){
        if(curDevTypeStr === "e03"){
            return setting.e03showParentW
        }else if(curDevTypeStr === "f03"){
            return setting.f03showParentW
        }else if(curDevTypeStr === "d04"){
            return setting.d04showParentW
        }else if(curDevTypeStr === "d06"){
            return setting.d06showParentW
        }
    }
    
    function getShowParentH(){
        if(curDevTypeStr === "e03"){
            return setting.e03showParentH
        }else if(curDevTypeStr === "f03"){
            return setting.f03showParentH
        }else if(curDevTypeStr === "d04"){
            return setting.d04showParentH
        }else if(curDevTypeStr === "d06"){
            return setting.d06showParentH
        }
    }
    
    
    function setVideoType(typeStr){
        
        if(typeStr === "h264")
            checkh264.checked = true;
        else if(typeStr === "h265")
            checkh265.checked = true;
    }
    
    function getVideoType(){
        
        if(checkh264.checked)
            return "h264"
        if(checkh265.checked)
            return "h265"
    }
    
    
    
    Connections{
        target: main
        onS_setLanguage:setLanguage(typeL);
    }
    
    function setLanguage(type){
        
        switch(type){
        case lEnglish:
            txtRecordSet.text = "Video Settings"
            txtRecortPath.text = "Storage Path"
            txtScreenShotPath.text = "Storage Path"
            txtWarnTemSet.text = "Alarm Temperature"
            labelSwitchTime.text = "Time Sync"
            labelTime.text = "Time OSD"
            txtparset.text = "Parameter Settings"
            txtSwichBeer.text = "Buzzer"
           // txtSwichRecord.text = "Video"
            txtSwichScreenShot.text = "Snapshot"
            txtSwichWarn.text = "Alarm"
            txtTempMin.text = "Temperature control valve"
            txtTempDrift.text = "Temperature drift setting"
            txtUpdate.text = "Upgrade"
            txtUpdateFile.text = "Upgrade"
            txtSave.text = "Confirm"
            // txtencodetype.text = "Encoding Style"
            txtImageSet.text = "Thermal Image Color"
            txtImageSelect.text = "Color Setting "
            txtMask.text = "Mask Alarm"
            break;
        case lChinese:
            txtRecordSet.text = "录像设置"
            txtRecortPath.text = "录像存储路径"
            txtScreenShotPath.text = "抓拍存储路径"
            txtWarnTemSet.text = "告警温度设置"
            labelSwitchTime.text = "时间同步"
            labelTime.text = "时间显示"
            txtparset.text = "参数设置"
            txtSwichBeer.text = "蜂鸣开关"
           // txtSwichRecord.text = "录像开关"
            txtSwichScreenShot.text = "抓拍开关"
            txtSwichWarn.text = "报警开关"
            txtTempMin.text = "温度控制阀"
            txtTempDrift.text = "温漂设置"
            txtUpdate.text = "升级"
            txtUpdateFile.text = "设备升级"
            txtSave.text = "设置"
            txtImageSet.text = "图像设置"
            txtImageSelect.text = "图像选择"
            txtMask.text = "口罩告警"
            break;
        case lRussian:
            txtRecordSet.text = "Настройка записи"
            txtRecortPath.text = "Путь хранения видео"
            txtScreenShotPath.text = "Путь сохранения снимка"
            txtWarnTemSet.text = "Температура тревоги"
            labelSwitchTime.text = "Синхронизация времени"
            labelTime.text = "Время OSD"
            txtparset.text = "Настройка параметров"
            txtSwichBeer.text = "Звуковой сигнал"
            //txtSwichRecord.text = "Запись"
            txtSwichScreenShot.text = "Снимок"
            txtSwichWarn.text = "Тревога"
            txtTempMin.text = "Max Min температура"
            txtTempDrift.text = "Коррекция температуры"
            txtUpdate.text = "Обновить"
            txtUpdateFile.text = "Обновление устройства"
            txtSave.text = "Подтверждение"
            txtImageSet.text = "Цвет теплового изображения"
            txtImageSelect.text = "Настройка цвета"
            txtMask.text = "Маска тревоги"
            break;
        case ltuerqi:
            txtRecordSet.text = "Video ayarları"
            txtRecortPath.text = "Depolama yolu"
            txtScreenShotPath.text = "Depolama yolu"
            txtWarnTemSet.text = "Alarm Sıcaklığı"
            labelSwitchTime.text = "Zaman Senkronizasyonu"
            labelTime.text = "Zaman OSD'si"
            txtparset.text = "Parametre ayarı"
            txtSwichBeer.text = "Buzzer"
           // txtSwichRecord.text = "Video"
            txtSwichScreenShot.text = "Snapshot"
            txtSwichWarn.text = "Alarm (anahtar)"
            txtTempMin.text = "Max Min Sıcaklık"
            txtTempDrift.text = "Sıcaklık sapması ayarı"
            txtUpdate.text = "Yükselt"
            txtUpdateFile.text = "Cihaz Yükseltme"
            txtSave.text = "Onaylamak"
            txtImageSet.text = "Termal Görüntü Rengi"
            txtImageSelect.text = "Renk Ayarı"
            txtMask.text = "Maske Alarmı"

            break;
        case lxibanya:
            txtRecordSet.text = "Ajustes de video"
            txtRecortPath.text = "ruta de almacenamiento"
            txtScreenShotPath.text = "ruta de almacenamiento"
            txtWarnTemSet.text = "alarma de temperatura"
            labelSwitchTime.text = "Sincronización de tiempo"
            labelTime.text = "tiempo OSD"
            txtparset.text = "Ajuste de parámetros"
            txtSwichBeer.text = "Zumbador"
            //txtSwichRecord.text = "Vídeo"
            txtSwichScreenShot.text = "Instantánea"
            txtSwichWarn.text = "Alarma (interruptor)"
            txtTempMin.text = "válvula de control de temperatura"
            txtTempDrift.text = "ajuste de la deriva térmica"
            txtUpdate.text = "Upgrade"
            txtUpdateFile.text = "Potenciar"
            txtSave.text = "Confirmar"
            txtImageSet.text = "Color de imagen térmica"
            txtImageSelect.text = "Ajuste de color"
            txtMask.text = "Alarma de máscara"
            break;
        case lfayu:
            txtRecordSet.text = "Paramètres vidéo"
            txtRecortPath.text = "Chemin de stockage vidéo"
            txtScreenShotPath.text = "Chemin de stockage photo"
            txtWarnTemSet.text = "Température d'alarme"
            labelSwitchTime.text = "Synchronisation horaire"
            labelTime.text = "Heure OSD"
            txtparset.text = "Réglage des paramètres"
            txtSwichBeer.text = "Avertisseur sonore"
           // txtSwichRecord.text = "Vidéo"
            txtSwichScreenShot.text = "Instantané"
            txtSwichWarn.text = "Alarme(interrupteur)"
            txtTempMin.text = "Température max/min"
            txtTempDrift.text = "Correction de la température"
            txtUpdate.text = "Améliorer"
            txtUpdateFile.text = "Mise à niveau de l'appareil"
            txtSave.text = "Confirmer"
            txtImageSet.text = "Couleur de l'image thermique"
            txtImageSelect.text = "Réglage des couleurs"
            txtMask.text = "Masque d'alarme"
            break;
        }
    }
    
}
