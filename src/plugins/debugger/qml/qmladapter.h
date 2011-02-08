/**************************************************************************
**
** This file is part of Qt Creator
**
** Copyright (c) 2011 Nokia Corporation and/or its subsidiary(-ies).
**
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** No Commercial Usage
**
** This file contains pre-release code and may not be distributed.
** You may use this file in accordance with the terms and conditions
** contained in the Technology Preview License Agreement accompanying
** this package.
**
** GNU Lesser General Public License Usage
**
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Nokia gives you certain additional
** rights.  These rights are described in the Nokia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** If you have questions regarding the use of this file, please contact
** Nokia at qt-info@nokia.com.
**
**************************************************************************/

#ifndef DEBGUGGER_QMLADAPTER_H
#define DEBGUGGER_QMLADAPTER_H

#include "debugger_global.h"
#include "qmldebuggerclient.h"

#include <QtCore/QObject>
#include <QtCore/QScopedPointer>
#include <QtNetwork/QAbstractSocket>

namespace QmlJsDebugClient {
class QDeclarativeEngineDebug;
class QDeclarativeDebugConnection;
}

namespace Debugger {

class DebuggerEngine;

namespace Internal {
class QmlDebuggerClient;
class QmlAdapterPrivate;
} // namespace Internal

class DEBUGGER_EXPORT QmlAdapter : public QObject
{
    Q_OBJECT
public:
    explicit QmlAdapter(DebuggerEngine *engine, QObject *parent = 0);
    virtual ~QmlAdapter();

    void beginConnection();
    void pauseConnection();
    void closeConnection();

    bool isConnected() const;
    bool isUnconnected() const;

    QmlJsDebugClient::QDeclarativeEngineDebug *client() const;
    QmlJsDebugClient::QDeclarativeDebugConnection *connection() const;

    // TODO move to private API b/w engine and adapter
    void setMaxConnectionAttempts(int maxAttempts);
    void setConnectionAttemptInterval(int interval);

    bool disableJsDebugging(bool block);

public slots:
    void logServiceStatusChange(const QString &service, QDeclarativeDebugClient::Status newStatus);    
    void logServiceActivity(const QString &service, const QString &logMessage);

signals:
    void connected();
    void disconnected();
    void connectionStartupFailed();
    void connectionError(QAbstractSocket::SocketError socketError);
    void serviceConnectionError(const QString serviceName);

private slots:
    void sendMessage(const QByteArray &msg);
    void connectionErrorOccurred(QAbstractSocket::SocketError socketError);
    void clientStatusChanged(QDeclarativeDebugClient::Status status);
    void connectionStateChanged();
    void pollInferior();

private:
    void connectToViewer();
    void createDebuggerClient();
    void showConnectionStatusMessage(const QString &message);
    void showConnectionErrorMessage(const QString &message);
    void flushSendBuffer();

private:
    QScopedPointer<Internal::QmlAdapterPrivate> d;
};

} // namespace Debugger

#endif // DEBGUGGER_QMLADAPTER_H
