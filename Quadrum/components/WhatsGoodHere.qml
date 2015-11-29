import QtQuick 2.0
import Ubuntu.Components 1.3
import QtQuick.LocalStorage 2.0
import Ubuntu.Components.ListItems 1.0 as ListItem
import "../js/scripts.js" as Scripts

Item {
    anchors {
        margins: units.gu(1)
        fill: parent
    }

    property bool finished: false

    function nearby_places() {
        if (!mainView.coord.latitude || !mainView.coord.longitude) {
            finished = true;
            noitem.visible = true;
            timer.start()

            return false;
        } else {
            finished = false
            noitem.visible = false;
            timer.stop()
        }

        Scripts.nearby_places(mainView.coord.latitude, mainView.coord.longitude, Scripts.getKey('access_token'));
    }

    function search_nearby_places(q) {
        Scripts.search_nearby_places(mainView.coord.latitude, mainView.coord.longitude, Scripts.getKey('access_token'), q);
    }

    ListModel {
        id: nearbyPlacesModel
    }

    ListView {
        id:nearbyPlaces
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        clip: true

        model:nearbyPlacesModel
        delegate: ListItem.Empty {
            width: parent.width
            height: placeimage.height > placetitle.height + placeaddress.height ? placeimage.height + units.gu(2) : placetitle.height + placeaddress.height + units.gu(2)
            Item {
                id: delegateitem
                anchors.fill: parent
                width: parent.width
                anchors.topMargin: units.gu(1)
                Rectangle {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    id: placeimage
                    width:units.gu(5)
                    height: width
                    color: "transparent"
                    Image {
                        source: category_image
                        width: parent.width
                        height: parent.height
                    }
                }
                Label {
                    anchors.top: parent.top
                    anchors.left: placeimage.right
                    anchors.leftMargin: units.gu(1)
                    width: parent.width - units.gu(1) - placeimage.width
                    color: "#2d5be3"
                    id: placetitle
                    fontSize: "small"
                    text: name
                    textFormat: Text.RichText
                    wrapMode: Text.WordWrap
                }
                Item {
                    id: placeinfos
                    anchors.top: placetitle.bottom
                    anchors.left: placeimage.right
                    anchors.leftMargin: units.gu(1)
                    width: parent.width
                    Text {
                        id: placeaddress
                        text: distandadd
                        width: parent.width - units.gu(5)
                        font.pointSize: units.gu(1.2)
                        wrapMode: Text.WordWrap
                    }
                }
            }

            onClicked: {
                venuepage.venue(id);
                pageStack.push(venuePage);
            }
        }
    }

    Item {
        anchors.centerIn: parent
        opacity: whatsgoodhere.finished == false ? 1 : 0

        Behavior on opacity {
            UbuntuNumberAnimation {
                duration: UbuntuAnimation.SlowDuration
            }
        }

        ActivityIndicator {
            id: activity
            running: true
        }
    }

    Item {
        id: noitem
        visible: false
        width: noitemlabel.width
        anchors.centerIn: parent

        Label {
            id: noitemlabel
            text: i18n.tr("Can't find your location. Waiting for signal...")
        }
    }

    Timer {
        id: timer
        interval: 1000
        running: false
        repeat: true
        onTriggered: nearby_places()
    }
}
