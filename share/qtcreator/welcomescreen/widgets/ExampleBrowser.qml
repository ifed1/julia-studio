/**************************************************************************
**
** This file is part of Qt Creator
**
** Copyright (c) 2011 Nokia Corporation and/or its subsidiary(-ies).
**
** Contact: Nokia Corporation (info@qt.nokia.com)
**
**
** GNU Lesser General Public License Usage
**
** This file may be used under the terms of the GNU Lesser General Public
** License version 2.1 as published by the Free Software Foundation and
** appearing in the file LICENSE.LGPL included in the packaging of this file.
** Please review the following information to ensure the GNU Lesser General
** Public License version 2.1 requirements will be met:
** http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Nokia gives you certain additional
** rights. These rights are described in the Nokia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** Other Usage
**
** Alternatively, this file may be used in accordance with the terms and
** conditions contained in a signed written agreement between you and Nokia.
**
** If you have questions regarding the use of this file, please contact
** Nokia at info@qt.nokia.com.
**
**************************************************************************/

import QtQuick 1.0
import components 1.0 as Components

Item {
    id: exampleBrowserRoot

    Rectangle {
        color:"#f4f4f4"
        id : lineEditRoot
        width: parent.width
        height: lineEdit.height + 6
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottomMargin: - 8
        anchors.leftMargin: - 8
        anchors.rightMargin: -8

        Components.TextField {
            placeholderText: !checkBox.checked ? qsTr("Search in Tutorials") : qsTr("Search in Tutorials, Examples and Demos")
            focus: true
            id: lineEdit
            anchors.left: parent.left
            anchors.leftMargin:4
            anchors.verticalCenter: parent.verticalCenter
            width: lineEditRoot.width - checkBox.width - 24 - tagFilterButton.width
            onTextChanged: examplesModel.filterRegExp = RegExp('.*'+text, "im")
        }

        Components.CheckBox {
            id: checkBox
            text: qsTr("Show Examples and Demos")
            checked: false
            anchors.leftMargin: 6
            anchors.left: lineEdit.right
            anchors.verticalCenter: lineEdit.verticalCenter
            height: lineEdit.height
            onCheckedChanged: examplesModel.showTutorialsOnly = !checked;
        }

        Components.Button {
            id: tagFilterButton
            property string tag
            Behavior on opacity { NumberAnimation{} }
            onTagChanged: { examplesModel.filterTag = tag; examplesModel.updateFilter() }
            anchors.left: checkBox.right
            anchors.verticalCenter: lineEdit.verticalCenter
            opacity: !examplesModel.showTutorialsOnly ? 1 : 0
            text: tag === "" ? qsTr("Filter by Tag") : qsTr("Tag Filter: %1").arg(tag)
            onClicked: {
                tagBrowserLoader.source = "TagBrowser.qml"
                tagBrowserLoader.item.visible = true
            }
        }
    }
    Components.ScrollArea  {
        id: scrollArea
        anchors.bottomMargin: lineEditRoot.height - 8
        anchors.margins:-8
        anchors.fill: parent
        frame: false
        Column {
            Repeater {
                id: repeater
                model: examplesModel
                delegate: ExampleDelegate { width: scrollArea.width }
            }
        }
        Component.onCompleted: verticalScrollBar.anchors.bottomMargin = -(scrollArea.anchors.bottomMargin + 8)
    }

    Rectangle {
        anchors.bottom: scrollArea.bottom
        height:4
        anchors.left: scrollArea.left
        anchors.right: scrollArea.right
        anchors.rightMargin: scrollArea.verticalScrollBar.visible ?
                               scrollArea.verticalScrollBar.width : 0
        width:parent.width
        gradient: Gradient{
            GradientStop{position:1 ; color:"#10000000"}
            GradientStop{position:0 ; color:"#00000000"}
        }
        Rectangle{
            height:1
            color:"#ccc"
            anchors.bottom: parent.bottom
            width:parent.width
        }
    }


    Loader {
        id: tagBrowserLoader
        anchors.fill: parent
    }
}
