import QtQuick 2.0
import Ubuntu.Components 1.2
import QtQuick.LocalStorage 2.0
import QtLocation 5.0
import QtPositioning 5.2
import UserMetrics 0.1
import Ubuntu.Components.Popups 1.0
import Ubuntu.Components.ListItems 0.1 as ListItem
import "components"
import "ui"
import "js/scripts.js" as Scripts

/* Image upload
 *
 * http://bazaar.launchpad.net/~mzanetti/imgur-share/trunk/view/head:/app/Main.qml
 *
 */

MainView {
    id: mainView
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "com.ubuntu.developer.turan.mahmudov.quadrum"

    automaticOrientation: true

    anchorToKeyboard: true

    width: units.gu(50)
    height: units.gu(75)

    property var coord: {'latitude':positionSource.position.coordinate.latitude, 'longitude':positionSource.position.coordinate.longitude}

    PositionSource {
        id: positionSource
        updateInterval: 60000 //60 seconds (?)
        active: true
        onPositionChanged: {
            mainView.coord.latitude = positionSource.position.coordinate.latitude;
            mainView.coord.longitude = positionSource.position.coordinate.longitude;
        }
    }

    PageStack {
        id: pageStack

        Component.onCompleted: {
            Scripts.initializeUser();

            var logged = Scripts.getKey('access_token');
            if (logged == 0) {
                pageStack.push(Qt.resolvedUrl("ui/LoginPage.qml"));
            } else {
                pageStack.push(tabs);
            }
        }
    }

    Tabs {
        id: tabs
        visible: false

        Tab {
            title: i18n.tr("Find a place")
            page: Page {
                id: findAPlacePage
                title: i18n.tr("Find a place")
                visible: true

                FindAPlace {
                    id: findaplace
                    anchors.fill: parent
                }

                Component.onCompleted: {
                }
            }
        }

        Tab {
            title: i18n.tr("What's good here")
            page: Page {
                id: whatsGoodHerePage
                title: i18n.tr("What's good here")
                visible: true
                state: "default"
                states: [
                    PageHeadState {
                        name: "default"
                        head: whatsGoodHerePage.head
                        actions: [
                            Action {
                                iconName: "search"
                                onTriggered: whatsGoodHerePage.state = "search"
                            },
                            Action {
                                iconName: "reload"
                                onTriggered: whatsgoodhere.nearby_places()
                            }
                        ]
                    },
                    PageHeadState {
                        id: headerState
                        name: "search"
                        head: whatsGoodHerePage.head
                        backAction: Action {
                            id: leaveSearchAction
                            text: "back"
                            iconName: "back"
                            onTriggered: {
                                whatsgoodhere.finished == false;
                                whatsGoodHerePage.state = "default"
                                whatsgoodhere.nearby_places();
                            }
                        }
                        contents: TextField {
                            id: searchField
                            anchors {
                                right: parent.right
                                rightMargin: units.gu(2)
                            }
                            hasClearButton: true
                            inputMethodHints: Qt.ImhNoPredictiveText
                            placeholderText: i18n.tr("Search nearby places")
                            onVisibleChanged: {
                                if (visible) {
                                    forceActiveFocus()
                                }
                            }
                            onAccepted: {
                                whatsgoodhere.search_nearby_places(searchField.text);
                            }
                        }
                    }
                ]

                WhatsGoodHere {
                    id: whatsgoodhere
                    anchors.fill: parent
                }

                Component.onCompleted: {
                    whatsgoodhere.nearby_places();
                }
            }
        }

        Tab {
            title: i18n.tr("Activity")
            page: Page {
                id: activityPage
                title: i18n.tr("Activity")
                visible: true

                Activity {
                    id: activitypage
                    anchors.fill: parent
                }

                Component.onCompleted: {
                    activitypage.get_activity()
                }
            }
        }

        Tab {
            title: i18n.tr("Me")
            page: Page {
                id: mePage
                title: i18n.tr("Me")
                visible: true

                Me {
                    id: mepage
                    anchors.fill: parent
                }

                Component.onCompleted: {
                    mepage.get_me();
                }
            }
        }
    }

    Page {
        id: checkinDetails
        title: i18n.tr("Check in")
        visible: false

        CheckinDetails {
            id:checkindetails
            anchors.fill:parent
        }

        head.backAction: Action {
            iconName: "back"
            onTriggered: {
                tabs.selectedTabIndex = 2;
                pageStack.clear();
                pageStack.push(tabs);
                if (checkindetails.refresh == '1') {
                    activitypage.get_activity();
                }
            }
        }
    }

    Page {
        id: checkinPage
        title: i18n.tr("Check in")
        visible: false

        Checkin {
            id: checkinpage
            anchors.fill:parent
        }
        head.actions: []
    }

    Page {
        id: userPage
        title: i18n.tr("User")
        visible: false

        User {
            id: userpage
            anchors.fill:parent
        }
        head.actions: []
    }

    Page {
        id: venuePage
        title: i18n.tr("Venue")
        visible: false

        VenuePage {
            id:venuepage
            anchors.fill:parent
        }

        head.actions: [
            Action {
                iconName: "note"
                onTriggered: {
                    leavenote.venueId = venuepage.id;
                    pageStack.push(leaveNotePage);
                }
            }
        ]
    }

    Page {
        id: venueDetailsPage
        title: i18n.tr("More Info")
        visible: false

        VenueDetailsPage {
            id:venuedetailspage
            anchors.fill:parent
        }
    }

    Page {
        id:checkinLikes
        title: i18n.tr("Likes")
        visible: false

        CheckinLikes {
            id: checkinlikes
            anchors.fill: parent
        }
    }

    Page {
        id: leaveNotePage
        title: i18n.tr("Leave note")
        visible: false

        LeaveNote {
            id: leavenote
            anchors.fill: parent
        }
    }

    Page {
        id: categoryPage
        title: i18n.tr("Category")
        visible: false

        CategoryPage {
            id:categorypage
            anchors.fill: parent
        }

        head.sections {
            model: ["Recommended", "Specials", "Open Now"]
            onSelectedIndexChanged: {
                categorypage.category(categorypage.section, categoryPage.head.sections.selectedIndex);
            }
        }
        head.actions: [
            Action {
                iconName: "reload"
                onTriggered: categorypage.category(categorypage.section)
            }
        ]
    }

    Metric {
        id: quadrumMetrics
        name: "quadrum-metrics"
        format: "<b>%1</b> " + i18n.tr("check-in today")
        emptyFormat: i18n.tr("No check-in made today")
        domain: "com.ubuntu.developer.turan.mahmudov.quadrum"
    }

    ListModel {
        id: ulistsModel
    }

    Component {
        id: userListsDialog

        Popover {
            id: userListsDialogue
            Item {
                id: userListsLayout
                width: parent.width
                height: ulists.contentHeight > width ? width : ulists.contentHeight
                anchors {
                    left: parent.left
                    top: parent.top
                }

                ListView {
                    id:ulists
                    width: parent.width
                    height: parent.height
                    clip: true

                    model:ulistsModel
                    delegate: ListItem.Empty {
                        width: parent.width
                        height: ltitle.height + units.gu(3)
                        Item {
                            id: delegateitem
                            anchors.fill: parent
                            width: parent.width
                            Text {
                                anchors.top: parent.top
                                anchors.topMargin: units.gu(1)
                                anchors.left: parent.left
                                anchors.leftMargin: units.gu(2)
                                anchors.rightMargin: units.gu(2)
                                width: parent.width
                                id: ltitle
                                text: name
                                color: UbuntuColors.darkGrey
                                wrapMode: Text.WordWrap
                                elide: Text.ElideRight
                                maximumLineCount: 1
                                font.pointSize: units.gu(1.4)
                            }
                        }
                        onClicked: {
                            Scripts.save_venue_to_list(id, venue_id);
                            PopupUtils.close(userListsDialogue);
                        }
                    }
                }
                Scrollbar {
                    flickableItem: ulists
                }
            }
        }
    }
}

