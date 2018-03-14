import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.0

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

import org.nxos.softwarecenter 1.0

import "parts" as Parts;

ApplicationWindow {
    id: main

    visible: true
    width: 900
    height: 700

    property var refreshCacheTask
    property var appsCache

    color: theme.backgroundColor

    header: NavigationPanel {
        id: navigationPanel

        onGoStore: main.handleGoStore()
        onGoTasks: main.showTasksView()
        onStoreQueryTyped: main.search(query)

        tasksCount: "4"

        Connections {
            target: TasksController
            onAffectedApplicationsIdsChanged: navigationPanel.updateTaskNumberHint()
        }

        Connections {
            target: UpgraderController
            onUpgradableApplicationsChanged: navigationPanel.updateTaskNumberHint()
        }

        function updateTaskNumberHint() {
            var total = TasksController.model.rowCount() + UpgraderController.model.rowCount()
            var value = ""
            if (total > 10)
                value = total % 10 + "*"
            else
                value = total

            navigationPanel.tasksCount = value;
        }
    }

    footer: StatusArea {
        id: statusArea
        height: visible ? 42 : 0
        visible: false
    }


    ScrollView {
        id: scrollView
        anchors.fill: parent
        clip: true

        StackView {
            id: stackView

            height: scrollView.height
            width: scrollView.width

            initialItem: PlaceHolderView

            function findItemByObjectName(name) {
                var item = stackView.find(function (item, index) {
                    return item.objectName === name
                })
                return item
            }

            function goTo(name, component) {
                var itemInstance = findItemByObjectName(name);
                if (itemInstance)
                    stackView.pop(itemInstance)
                else
                    stackView.push(component, {objectName: name})
            }
        }
    }


    Parts.MessageFrame {
        id: messageBox

        anchors.horizontalCenter: header.horizontalCenter
        anchors.top: header.bottom

        visible: false

        onCloseRequest: NotificationsController.hideNotification()

        Connections {
            target: NotificationsController
            onShowNotificationRequest: {
                messageBox.icon = ["emblem-info", "", "emblem-error"][notficationType]
                messageBox.text = message
                messageBox.visible = true
            }
            onNotificationExpired: messageBox.visible = false;
        }
    }

    TextConstants {
        id: textConstants
    }

    function search(query) {
        SearchController.search(query)
    }

    function showTasksView() {
        main.title = "Tasks"
        stackView.goTo("tasksView", "qrc:/TasksView.qml");
    }

    Connections {
        target: UpdaterController
        onIsWorkingChanged: handleUpdaterIsWorkingChanged(isWorking)
    }

    function handleUpdaterIsWorkingChanged(isWorking) {
        print("isWorking: " + UpdaterController.isWorking)
        print("isReady: " + UpdaterController.isReady)
        if (navigationPanel.currentView == "store") {
            if (isWorking) {
                main.title = "Loading contents"
                showBusyMessage("Loading store contents...")
            } else {
                if (UpdaterController.isReady)
                    showSearchView();
                else
                    showUpdateErrorMessage();
            }
        }
    }

    function handleGoStore() {
        if (UpdaterController.isReady)
            showSearchView()
        else
            UpdaterController.update()
    }

    function showSearchView() {
        main.title = "Explore";
        stackView.goTo("searchView", "qrc:/SearchView.qml");
    }

    function showApplicationView(applicationName) {
        main.title = applicationName ? applicationName : "Details";
        stackView.goTo("applicationView", "qrc:/ApplicationView.qml");
    }

    function showBusyMessage(message) {
        stackView.goTo("placeHolderView", "qrc:/PlaceHolderView.qml");
        var item = stackView.findItemByObjectName("placeHolderView");
        item.message = message
        item.iconName = "";
        item.showBusyIndicator = true;
    }

    function showUpdateErrorMessage() {
        stackView.goTo("placeHolderView", "qrc:/PlaceHolderView.qml");
        var item = stackView.findItemByObjectName("placeHolderView");

        item.message = textConstants.fetchError
        item.iconName = "network-wireless-disconnected";
        item.showBusyIndicator = false;
    }

    Component.onCompleted: handleGoStore()
}
