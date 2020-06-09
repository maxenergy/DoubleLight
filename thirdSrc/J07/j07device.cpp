#include "j07device.h"
#include "xvideotemp.h"

J07Device::J07Device(QString ip,int type,QObject *parent) : QObject(parent)
{
    m_ip = ip;
    m_type = type;
}

void J07Device::startRec()
{
    createTcpThread();
}
void J07Device::createTcpThread()
{
    if(worker == nullptr){
        worker = new TcpWorker(m_type);
        m_readThread = new QThread;

        // connect(worker,&TcpWorker::signal_sendH264,this,&J07Device::slot_recH264,Qt::DirectConnection);
        connect(worker,&TcpWorker::signal_sendImg,this,&J07Device::slot_recImg,Qt::DirectConnection);
        connect(worker,&TcpWorker::signal_connected,this,&J07Device::slot_tcpConnected);
        connect(this,&J07Device::signal_connentSer,worker,&TcpWorker::creatNewTcpConnect);
        connect(m_readThread,&QThread::finished,worker,&TcpWorker::deleteLater);
        connect(m_readThread,&QThread::finished,m_readThread,&QThread::deleteLater);
        worker->moveToThread(m_readThread);
        m_readThread->start();

        emit signal_connentSer(m_ip,556);
    }
}

//流连接成功
void J07Device::slot_tcpConnected(){


    qDebug()<<" createTcpThread "<<"*******rect*************";

    if(workerRect != nullptr)
    {
        workerRect->forceStopParse();
        m_readRectThread->quit();
        workerRect = nullptr;
        m_readRectThread = nullptr;
    }

    workerRect = new TcpWorker(10);
    m_readRectThread = new QThread;

    connect(workerRect,&TcpWorker::signal_sendRectInfo,this,&J07Device::slot_recRectInfo,Qt::DirectConnection);
    //connect(workerRect,&TcpWorker::signal_connected,this,&J07Device::slot_tcpConnected);
    connect(this,&J07Device::signal_connentSer1,workerRect,&TcpWorker::creatNewTcpConnect);
    connect(m_readRectThread,&QThread::finished,workerRect,&TcpWorker::deleteLater);
    connect(m_readRectThread,&QThread::finished,m_readRectThread,&QThread::deleteLater);
    workerRect->moveToThread(m_readRectThread);
    m_readRectThread->start();

    emit signal_connentSer1(m_ip,557);

}

void J07Device::slot_recRectInfo(int tempdisplay,QVariantList listmap){

    //qDebug()<<"slot_recRectInfo "<<tempdisplay;

    listrectinfo.clear();
    for (int i=0;i<listmap.size();i++) {
        QVariantMap map = listmap.at(i).toMap();
        listrectinfo.append(map);
    }

    emit signal_sendRect(tempdisplay,listrectinfo);
}

void J07Device::slot_recImg(QImage *img,int len,quint64 time,int resw,int resh){

    //qDebug()<<"slot_recImg";
    if(img != nullptr){
        ImageInfo info;
        info.pImg =img;
        info.listRect.clear();
        XVideoTemp::mutex.lock();
        if(XVideoTemp::listBufferImginfo.size() < XVideoTemp::maxBuffLen){

            info.tempdisplay = tempdisplay;

            if(isupdateListRect){
                for (int i=0;i<listrectinfo.size();i++) {
                    QVariantMap map = listrectinfo.at(i).toMap();
                    // qDebug()<<"slot_recImg  "<<i<<":"<<map.value("x").toInt();
                    info.listRect.append(map);
                }
                isupdateListRect = false;
            }

            XVideoTemp::listBufferImginfo.append(info);
        }else{
            if(info.pImg != nullptr)
                delete info.pImg;
        }

        XVideoTemp::mutex.unlock();
    }
}


//tcpworker 线程  rgba数据
void J07Device::slot_recH264(char* h264Arr,int arrlen,quint64 time,int resw,int resh)
{

    qDebug()<<QString(__FUNCTION__) <<"***/***    "<<arrlen<< " "<<resw<<"  "<<resh;

    if(rgbBuff == nullptr)
        rgbBuff = new char[resw*resh*4];

    memcpy(rgbBuff,h264Arr,resw*resh*4);
    QImage *pImage = nullptr;
    try {

        pImage = new QImage((unsigned char*)rgbBuff,resw, resh, QImage::Format_RGB32);

        // 其它代码
    } catch ( const std::bad_alloc& e ) {

        qDebug()<<"图片分配内存失败     ";
        pImage = nullptr;
    }
    ImageInfo info;
    info.listRect.clear();
    XVideoTemp::mutex.lock();
    if(XVideoTemp::listBufferImginfo.size() < XVideoTemp::maxBuffLen)
        XVideoTemp::listBufferImginfo.append(info);
    else{
        if(info.pImg != nullptr)
            delete info.pImg;
    }

    XVideoTemp::mutex.unlock();
}

void J07Device::forceFinish()
{


    if(worker != nullptr)
    {
        worker->forceStopParse();
        m_readThread->quit();

        worker = nullptr;
        m_readThread = nullptr;
    }


    if(workerRect != nullptr)
    {
        workerRect->forceStopParse();
        m_readRectThread->quit();
        workerRect = nullptr;
        m_readRectThread = nullptr;
    }

    deleteLater();
}

J07Device::~J07Device()
{
    qDebug()<<" 析构   J07Device";

    //析构tcpworker
}
