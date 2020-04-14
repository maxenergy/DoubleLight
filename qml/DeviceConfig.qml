import QtQuick.Controls 2.5
import QtQuick 2.0
import QtGraphicalEffects 1.12
import QtQuick.Dialogs 1.3
import Qt.labs.settings 1.0
import "simpleControl"
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
    property int fontSize: 14

    //第一根左对齐线
    property int parSetFirstAlignLine: curLanguage === lChinese?124:255
    Settings {
        id:setting
        fileName: "config.ini"
        property alias recordPath: inputRecordPath.text
        property alias screenShotPath: inputScreenShotPath.text
        property alias temDrift:inputTempDrift.text
        property alias tempMin: inputTempMin.text
        //property alias tempMax: inputTempMax.text
        property alias warnTem:inputTem.text
        property alias switchTime:swithTime.checked
        property alias switchWarn:swichWarn.checked
        property alias switchScreenShot:swichScreenShot.checked
        property alias switchBeer:swichBeer.checked
        property alias switchRecord:swichRecord.checked


        property string tcpip:"10.67.1.146"
        property bool isOpenAdjustRect: true
        property int showRectX: 65;
        property int showRectY : 41;
        property int showRectW : 349;
        property int showRectH : 327;
        property int showParentW : 494;
        property int showParentH : 369;
    }

    Rectangle{
        width: parent.width
        height: parent.height - mDeviceStateBar.height
        MouseArea{
            anchors.fill: parent
        }
        Rectangle {
            id: rect
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width -40
            height: parent.height -40
            color: "#F8FAFD"

            Text {
                id: labelTime
                font.pixelSize: fontSize
                text: qsTr("时间显示")
                anchors.bottom: line1.top
                anchors.left: line1.left
                anchors.bottomMargin: 20

            }

            Rectangle{
                id:line1
                width: parent.width - 20*2
                height: 1
                color: "#e2e2e2"
                anchors.top: parent.top
                anchors.topMargin: 62
                anchors.horizontalCenter: parent.horizontalCenter

            }

            Text {
                id: labelSwitchTime
                text: qsTr("时间开关")
                font.pixelSize: fontSize
                anchors.top: line1.bottom
                anchors.left: line1.left
                anchors.leftMargin: 48
                anchors.topMargin: 20
            }

            SimpleSwich{
                id:swithTime
                width: 30
                height: 15
                anchors.left: labelSwitchTime.right
                anchors.leftMargin: 20
                anchors.verticalCenter: labelSwitchTime.verticalCenter
                onCheckedChanged: s_timeSwith(checked)
            }

            Text {
                id: txtparset
                font.pixelSize: fontSize
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
                            if(num >= 2)
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

                            if(num <= -2)
                                return

                            inputTempDrift.text = ""+(Number(num)-Number(1))
                        }
                        onReleased: imgValuedown.source="qrc:/images/arrow_low.png"
                    }
                }
            }

            Text {
                id: txtTemp
                text: qsTr(" ℃")
                font.pixelSize: fontSize
                anchors.verticalCenter: rectTempDrift.verticalCenter
                anchors.left: rectTempDrift.right
                anchors.topMargin: 6
            }

            ////////////
            Text {
                id: txtTempMin
                text: qsTr("温度控制阀")
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
                            if(num >= 6)
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

                            if(num <= 0)
                                return

                            inputTempMin.text = ""+(Number(num)-Number(1))
                        }
                        onReleased: imgValueMindown.source="qrc:/images/arrow_low.png"
                    }
                }

            }

            Text {
                id: txtTemp1
                text: qsTr(" ℃")
                font.pixelSize: fontSize
                anchors.verticalCenter: rectTempMin.verticalCenter
                anchors.left: rectTempMin.right
                anchors.topMargin: 6
            }
            ////////////
//            Text {
//                id: txtTempMax
//                text: qsTr("最大温度检测")
//                font.pixelSize: fontSize
//                anchors.top: txtTempMin.bottom
//                anchors.right: txtTempMin.right
//                anchors.topMargin: 30
//            }

//            Rectangle{
//                id:rectTempMax
//                color: "#D6D8DB"
//                width: 88
//                height: 32
//                radius: 4
//                anchors.left: txtTempMax.right
//                anchors.leftMargin: 20
//                anchors.verticalCenter: txtTempMax.verticalCenter

//                LineEdit {
//                    id: inputTempMax
//                    width: rectTempMax.width  - 22
//                    height: rectTempMax.height -2
//                    anchors.left: parent.left
//                    anchors.leftMargin: 1
//                    anchors.verticalCenter: rectTempMax.verticalCenter
//                    border.width: 0
//                    inputLimite:Qt.ImhDigitsOnly
//                    font.pixelSize: fontSize
//                    placeholderText: ""
//                    isNeedDoubleClickEdit: false
//                    textLeftPadding:0
//                    txtColor: Qt.rgba(0,0,0,0.65)
//                    text: "50"
//                    color: "#F8FAFD"
//                    onTextChanged: {
//                        s_temMax(inputTempMax.text);

//                    }
//                }
//                Image {
//                    id: imgValueMaxUp
//                    width: 20
//                    height: 15
//                    source: "qrc:/images/arrow_up.png"
//                    anchors.right: parent.right
//                    anchors.rightMargin: 1
//                    anchors.top: parent.top
//                    anchors.topMargin: 1
//                    MouseArea{
//                        anchors.fill: parent
//                        onPressed: {
//                            imgValueMaxUp.source="qrc:/images/arrow_up_p.png"
//                            var num = parseInt(inputTempMax.text)
//                            if(num >= 100)
//                                return

//                            inputTempMax.text = ""+(Number(num)+Number(1))

//                        }
//                        onReleased: imgValueMaxUp.source="qrc:/images/arrow_up.png"
//                    }
//                }
//                Image {
//                    id: imgValueMaxdown
//                    width: 20
//                    height: 15
//                    source: "qrc:/images/arrow_low.png"
//                    anchors.right: imgValueMaxUp.right
//                    anchors.top: imgValueMaxUp.bottom
//                    anchors.topMargin: 1
//                    MouseArea{
//                        anchors.fill: parent

//                        onPressed: {

//                            imgValueMaxdown.source="qrc:/images/arrow_low_p.png"
//                            var num = parseInt(inputTempMax.text)

//                            if(num <= 0)
//                                return

//                            inputTempMax.text = ""+(Number(num)-Number(1))
//                        }
//                        onReleased: imgValueMaxdown.source="qrc:/images/arrow_low.png"
//                    }
//                }

//            }

//            Text {
//                id: txtTemp2
//                text: qsTr(" ℃")
//                font.pixelSize: fontSize
//                anchors.verticalCenter: rectTempMax.verticalCenter
//                anchors.left: rectTempMax.right

//            }
            /////////////////

            Text {
                id: txtSwichWarn
                text: qsTr("报警开关")
                font.pixelSize: fontSize

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
                onCheckedChanged: s_warnSwith(checked)
            }
            Text {
                id: txtWarnTemSet
                text: qsTr("告警温度设置")
                font.pixelSize: fontSize
                anchors.left: swichWarn.right
                anchors.verticalCenter: swichWarn.verticalCenter
                anchors.leftMargin: 100
            }
            LineEdit {
                id: inputTem
                width: 88
                height: 28
                anchors.left: txtWarnTemSet.right
                anchors.leftMargin: 20
                anchors.verticalCenter: txtWarnTemSet.verticalCenter
                border.width: 1
                border.color: "#DEDFE3"
                font.pixelSize: fontSize
                placeholderText: ""
                isNeedDoubleClickEdit: false
                textLeftPadding:0
                txtColor: Qt.rgba(0,0,0,0.65)
                text: "38"
                color: "#F8FAFD"
                onTextChanged: s_temSet(inputTem.text)
            }
            Text {
                id: txtTem1
                text: qsTr("℃")
                font.pixelSize: fontSize

                anchors.left: inputTem.right
                anchors.leftMargin: 6
                anchors.verticalCenter: inputTem.verticalCenter
            }

            Text {
                id: txtSwichScreenShot
                text: qsTr("抓拍开关")
                font.pixelSize: fontSize

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
                anchors.left: swichScreenShot.right
                anchors.leftMargin: 100
                anchors.verticalCenter: swichScreenShot.verticalCenter
            }
            Rectangle{

                id:rectScreenShotPath
                color: "#F8FAFD"
                border.color: "#DEDFE3"
                border.width: 1
                width: 200
                height: 28
                anchors.left: txtScreenShotPath.right
                anchors.verticalCenter: txtScreenShotPath.verticalCenter
                anchors.leftMargin: 20
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

                            fileDialog.open()
                        }
                    }
                }

            }

            Text {
                id: txtSwichBeer
                text: qsTr("蜂鸣开关")
                font.pixelSize: fontSize

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
                onCheckedChanged: s_beerSwith(checked)
            }


            Text {
                id: txtRecordSet
                text: qsTr("录像设置")
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
                anchors.topMargin: 485
                anchors.horizontalCenter: parent.horizontalCenter
            }


            Text {
                id: txtSwichRecord
                text: qsTr("录像开关")
                font.pixelSize: fontSize
                anchors.top: line3.bottom
                anchors.left: line3.left
                anchors.topMargin: 20
                anchors.leftMargin: 48
            }
            SimpleSwich{
                id:swichRecord
                width: 30
                height: 15
                anchors.left: txtSwichRecord.right
                anchors.leftMargin: 20
                anchors.verticalCenter: txtSwichRecord.verticalCenter
                onCheckedChanged: s_recordSwith(checked)
            }

            Text {
                id: txtRecortPath
                text: qsTr("录像存储路径")
                font.pixelSize: fontSize
                anchors.left: swichRecord.right
                anchors.leftMargin: 100
                anchors.verticalCenter: swichRecord.verticalCenter
            }
            Rectangle{

                id:rectRecordPath
                color: "#F8FAFD"
                border.color: "#DEDFE3"
                border.width: 1
                width: 200
                height: 28
                anchors.left: txtRecortPath.right
                anchors.verticalCenter: txtRecortPath.verticalCenter
                anchors.leftMargin: 20
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

                            fileDialog.open()
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
            }

        }
        onRejected: {


        }
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
    function getWarnTem(){
        return setting.warnTem
    }
    function getSwitchWarn()
    {
        return setting.switchWarn;
    }

    function getSwitchTime(){
        return setting.switchTime
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


    function setTcpip(value){
         setting.tcpip = value
    }
    function setIsOpenAdjustRect(value){
         setting.isOpenAdjustRect = value
    }
    function setShowRectX(value){
         setting.showRectX = value
    }
    function setShowRectY(value){
         setting.showRectY = value
    }
    function setShowRectW(value){
         setting.showRectW = value
    }
    function setShowRectH(value){
         setting.showRectH = value
    }
    function setShowParentW(value){
         setting.showParentW = value
    }
    function setShowParentH(value){
        setting.showParentH = value
    }

    function getTcpip(){
        return setting.tcpip
    }
    function getIsOpenAdjustRect(){
        return setting.isOpenAdjustRect
    }
    function getShowRectX(){
        return setting.showRectX
    }
    function getShowRectY(){
        return setting.showRectY
    }
    function getShowRectW(){
        return setting.showRectW
    }
    function getShowRectH(){
        return setting.showRectH
    }
    function getShowParentW(){
        return setting.showParentW
    }
    function getShowParentH(){
        return setting.showParentH
    }



    Connections{
        target: main
        onS_setLanguage:setLanguage(typeL);
    }

    function setLanguage(type){

        switch(type){
        case lEnglish:
            txtRecordSet.text = "Video Settings"
            txtRecortPath.text = "Video Storage Path"
            txtScreenShotPath.text = "Snapshots Storage Path"
            txtWarnTemSet.text = "Alarm Temperatur"
            labelSwitchTime.text = "Time Button"
            labelTime.text = "Time Display"
            txtparset.text = "Parameter Settings"
            txtSwichBeer.text = "Siren Button"
            txtSwichRecord.text = "Video Button"
            txtSwichScreenShot.text = "Snapshots Button"
            txtSwichWarn.text = "Alarm Button"
            break;
        case lKorean:
            txtRecordSet.text = "비디오 설정"
            txtRecortPath.text = "비디오 저장 위치"
            txtScreenShotPath.text = "사진저장 경로"
            txtWarnTemSet.text = "알람온도설정"
            labelSwitchTime.text = "시간표시 On/Off"
            labelTime.text = "시간표시"
            txtparset.text = "파라미터 설정"
            txtSwichBeer.text = "경보음 On/Off"
            txtSwichRecord.text = "비디오 On/Off"
            txtSwichScreenShot.text = "사진캡쳐"
            txtSwichWarn.text = "알람 On/Off"
            break;
        case lItaly:

            txtRecordSet.text = "Settaggio Video"
            txtRecortPath.text = "Directory Video"
            txtScreenShotPath.text = "Directory Fotografie"
            txtWarnTemSet.text = "Allarme Temperatura"
            labelSwitchTime.text = "Tasto Ora"
            labelTime.text = "Ora"
            txtparset.text = "Settaggio Parametri"
            txtSwichBeer.text = "Tasto Sirena"
            txtSwichRecord.text = "Tasto Video"
            txtSwichScreenShot.text = "Tasto Fotografia"
            txtSwichWarn.text = "Tasto Allarme"
            break;
        case lChinese:
            txtRecordSet.text = "录像设置"
            txtRecortPath.text = "录像存储路径"
            txtScreenShotPath.text = "抓拍存储路径"
            txtWarnTemSet.text = "告警温度设置"
            labelSwitchTime.text = "时间开关"
            labelTime.text = "时间显示"
            txtparset.text = "参数设置"
            txtSwichBeer.text = "蜂鸣开关"
            txtSwichRecord.text = "录像开关"
            txtSwichScreenShot.text = "抓拍开关"
            txtSwichWarn.text = "报警开关"
            break;
        }
    }
}