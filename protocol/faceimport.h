#ifndef FACEIMPORT_H
#define FACEIMPORT_H

#include <QObject>
#include <QTcpSocket>
#include <QTimer>
class FaceImport : public QObject
{
    Q_OBJECT
public:
    explicit FaceImport(QObject *parent = nullptr);

signals:
    void signal_importCallback(QVariantMap map);
public slots:
    void slot_Connected();
    void slot_ReadMsg();
    void slot_createConnect(QString ip,int port);
    void slot_sendMsg(QVariantMap map);
    void slot_destoryConnect();
private:
    int HttpMsgCallBack(char * pData);
    QJsonObject makeJsonData(QVariantMap map);
    void SendRequestMsg(QJsonObject obj);


    QTcpSocket *g_tcpsocket = nullptr;
    QString g_ip = "";
    int g_port;
    QString parseStr = "";



};

#endif // FACEIMPORT_H
