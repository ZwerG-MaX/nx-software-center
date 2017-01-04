import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 1.2 as QtControls
import QtQuick.Controls.Styles.Plasma 2.0 as Styles

import QtWebKit 3.0

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import QtQuick.Controls.Styles.Plasma 2.0 as Styles
import org.kde.plasma.extras 2.0 as PlasmaExtras

import org.nx 1.0

ApplicationWindow {
    visible: true
    width: 600
    height: 400
    title: qsTr("NX Software Center")

    ColumnLayout {
        anchors.fill: parent
        RowLayout {
            Layout.leftMargin: 12
            Layout.rightMargin: 12
            Layout.topMargin: 6
            Layout.bottomMargin: 6
            Layout.fillWidth: true

            spacing: 8
            PlasmaComponents.Button {
                iconName: "go-home"
                checked: content.currentItem
                         && content.currentItem.objectName == "homeView"
                onClicked: content.pop(homeView)
            }
            PlasmaComponents.Button {
                iconName: "application"
            }
            PlasmaComponents.Button {
                iconName: "favorites"
            }
            PlasmaComponents.Button {
                iconName: "edit-download"
                checked: content.currentItem
                         && content.currentItem.objectName == "workView"
                onClicked: content.push(workView)
            }

            PlasmaComponents.TextField {
                Layout.fillWidth: true
                Layout.leftMargin: 100
                Layout.rightMargin: 100
                placeholderText: "Search"
            }

            PlasmaComponents.Button {
                Layout.alignment: Qt.AlignRight
                iconName: "configure"
            }
        }

        StackView {
            id: content
            Layout.fillWidth: true
            Layout.fillHeight: true

            initialItem: homeView
        }
    }

    Component {
        id: homeView
        Flow {
            padding: 12
            spacing: 24
            objectName: "homeView"
            Repeater {
                model: Local {
                    id: localSnaps
                }
                delegate: Item {
                    height: 152
                    width: 152
                    Rectangle {
                        anchors.fill: parent
                        color: "lightblue"
                        opacity: 0.3
                    }

                    GridLayout {
                        anchors.fill: parent
                        columns: 2
                        rowSpacing: 0
                        columnSpacing: 0

                        PlasmaCore.IconItem {
                            Layout.columnSpan: 2
                            Layout.alignment: Qt.AlignRight
                            Layout.topMargin: 6
                            Layout.rightMargin: 6
                            Layout.bottomMargin: 0
                            source: {
                                if (_status == "active")
                                    return "emblem-success"
                            }

                            Layout.preferredHeight: 24
                            Layout.preferredWidth: 24
                        }

                        PlasmaCore.IconItem {
                            Layout.preferredHeight: 64
                            Layout.preferredWidth: 64

                            Layout.alignment: Qt.AlignHCenter
                            Layout.columnSpan: 2
                            source: _icon != "" ? _icon : "package-x-generic"
                        }

                        ColumnLayout {
                            Layout.leftMargin: 4
                            spacing: 0
                            PlasmaComponents.Label {
                                text: _name
                                font.bold: true
                                font.italic: true
                                font.pointSize: 8
                            }
                            PlasmaComponents.Label {
                                text: "Version: " + _version
                                font.pointSize: 8
                            }
                            PlasmaComponents.Label {
                                text: (_installed_size / 1024*1024) + " MiB"
                                font.pointSize: 8
                            }
                        }

                        PlasmaComponents.Button {
                            text: "Remove"
                            Layout.preferredHeight: 28
                            Layout.preferredWidth: 64

                            style: Styles.ButtonStyle {
                                label: Item {Label {
                                        anchors.centerIn: parent
                                    text: control.text
                                    font.pointSize: 8
                                }}


                            }
                            onClicked: localSnaps.remove(_name);
                        }
                    }
                }
            }
        }
    }
    Component {
        id: workView
        Rectangle {
            objectName: "workView"
            color: "lightblue"
            opacity: 0.3
        }
    }
}