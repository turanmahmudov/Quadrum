import QtQuick 2.0
import Ubuntu.Components 1.1
import QtQuick.LocalStorage 2.0
import Ubuntu.Components.ListItems 1.0 as ListItem
import Ubuntu.Components.Popups 1.0
import QtLocation 5.0 as Location
import "../js/scripts.js" as Scripts

/*

  */

Item {
    anchors {
        fill: parent
    }

    property var id

    property string ratingColor

    property var venueArray

    function venue(venue_id) {
        var token = Scripts.getKey('access_token');
        Scripts.venue_details(venue_id, token);
    }

    Flickable {
        id: flick
        clip: true
        width: parent.width
        height: parent.height
        contentWidth: parent.width
        contentHeight: venueitem.height

        Column {
            id: venueitem
            spacing: units.gu(1)
            visible: false
            width: parent.width
            clip: true

            Rectangle {
                visible: venue_image.source == '' ? false : true
                id: venueimage
                width: parent.width
                height: venue_image.source == '' ? 0 : parent.width*2/5
                color: "transparent"

                Image {
                    id: venue_image
                    width: parent.width
                    height: parent.height
                    fillMode: Image.PreserveAspectCrop
                    verticalAlignment: Image.AlignVCenter
                    clip: true
                }
            }

            Item {
                width: parent.width
                height: venue_image.source == '' ? units.gu(0.5) : 0
            }

            Column {
                id: venuedet
                x: units.gu(1)
                y: venue_image.source == '' ? 0 : parent.width*2/5
                spacing: units.gu(1)
                width: parent.width

                Label {
                    id: venuename
                    fontSize: "large"
                    textFormat: Text.RichText
                    wrapMode: Text.WordWrap
                    width: parent.width - units.gu(2)
                }

                Row {
                    width: parent.width
                    spacing: units.gu(1)

                    Rectangle {
                        visible: venueratingtext.text == '' ? false : true
                        id: venuerating
                        width: venueratingtext.text == '' ? 0 : venueratingtext.width + units.gu(1)
                        height: venueratingtext.height + units.gu(1)
                        color: ratingColor
                        Label {
                            id: venueratingtext
                            anchors.centerIn: parent
                            color: "#ffffff"
                            fontSize: "x-small"
                        }
                    }
                    Label {
                        anchors.verticalCenter: venuerating.verticalCenter
                        fontSize: "small"
                        id: venuecategory
                    }
                }

                Column {
                    id: buttons
                    width: parent.width

                    Item {
                        height: savebutton.height
                        width: savebutton.width + checkinbutton.width + units.gu(1)
                        anchors.horizontalCenter: parent.horizontalCenter

                        Button {
                            id: savebutton
                            anchors.left: parent.left
                            anchors.leftMargin: -units.gu(1)
                            anchors.top: parent.top
                            width: units.gu(14)
                            text: i18n.tr("Save")
                            color: "#2d5be3"
                            clip: false
                            onClicked: {
                                Scripts.self_user_lists(id);
                                PopupUtils.open(userListsDialog, savebutton);
                            }
                        }

                        Button {
                            id: checkinbutton
                            anchors.left: savebutton.right
                            anchors.top: parent.top
                            anchors.leftMargin: units.gu(1)
                            width: units.gu(14)
                            color: "#FD9627"
                            text: i18n.tr("Check in")
                            onClicked: {
                                checkinpage.venueArray = venueArray;
                                checkinpage.id = id;
                                checkinpage.checkin(id, venueArray);
                                pageStack.push(checkinPage);
                            }
                        }
                    }
                }

                Row {
                    width: parent.width

                    Column {
                        id: venuedetails
                        width: parent.width - mapCol.width - units.gu(2)
                        spacing: units.gu(1)

                        Column {
                            width: parent.width
                            spacing: units.gu(2)
                            Row {
                                width: venueaddress.text == '' ? 0 : parent.width
                                spacing: units.gu(1)
                                Icon {
                                    anchors.verticalCenter: venueaddress.verticalCenter
                                    id: venueaddressicon
                                    name: "location"
                                    width: units.gu(2)
                                    height: venueaddress.text == '' ? 0 : units.gu(2)
                                }
                                Label {
                                    width: parent.width
                                    id: venueaddress
                                    textFormat: Text.RichText
                                    wrapMode: Text.WordWrap
                                    fontSize: "small"
                                }
                            }

                            Row {
                                width: venuephone.text == '' ? 0 : parent.width
                                spacing: units.gu(1)
                                Icon {
                                    anchors.verticalCenter: venuephone.verticalCenter
                                    id: venuephoneicon
                                    name: "call-start"
                                    width: units.gu(2)
                                    height: venuephone.text == '' ? 0 : units.gu(2)
                                }
                                Label {
                                    width: parent.width
                                    id: venuephone
                                    textFormat: Text.RichText
                                    wrapMode: Text.WordWrap
                                    fontSize: "small"
                                }
                            }

                            Row {
                                width: parent.width
                                spacing: units.gu(1)
                                Icon {
                                    anchors.verticalCenter: venuemore.verticalCenter
                                    id: venuemoreicon
                                    name: "contextual-menu"
                                    width: units.gu(2)
                                    height: units.gu(2)
                                }
                                Label {
                                    width: parent.width
                                    id: venuemore
                                    text: i18n.tr("More details")
                                    textFormat: Text.RichText
                                    wrapMode: Text.WordWrap
                                    fontSize: "small"
                                    MouseArea {
                                        width: parent.width
                                        height: parent.height
                                        onClicked: {
                                            venuedetailspage.venueArray = venueArray;
                                            venuedetailspage.venue_details(id, venueArray);
                                            pageStack.push(venueDetailsPage);
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Column {
                        id: mapCol
                        width: units.gu(14)
                        spacing: units.gu(1)

                        Location.Map {
                            width: parent.width
                            height: (parent.width > venuedetails.height) ? parent.width : venuedetails.height
                            id: map
                            plugin : Location.Plugin {
                                name: "osm"
                            }
                            zoomLevel: 18
                            center {
                                latitude: 53
                                longitude: 12
                            }
                        }
                    }
                }

                Row {
                    width: friendVisit.text == '' ? 0 : parent.width
                    spacing: units.gu(1)

                    Icon {
                        anchors.verticalCenter: friendVisit.verticalCenter
                        id: friendVisiticon
                        name: "like"
                        width: units.gu(2)
                        height: friendVisit.text == '' ? 0 : units.gu(2)
                    }
                    Label {
                        width: parent.width
                        id: friendVisit
                        textFormat: Text.RichText
                        wrapMode: Text.WordWrap
                        fontSize: "small"
                    }
                }

                Column {
                    width: parent.width

                    // Specials
                    Column {
                        width: parent.width - units.gu(2)
                        spacing: units.gu(1)

                        Rectangle {
                            width: parent.width
                            height: specFromVenueValue.text == '' ? 0 : specFromVenueValue.height + units.gu(1)
                            color: "#cccccc"
                            id: specFromVenue
                            Label {
                                id: specFromVenueValue
                                anchors.centerIn: parent
                                color: "#000000"
                            }
                        }

                        ListModel {
                            id: specModel
                        }

                        Repeater {
                            model: specModel

                            Column {
                                width: parent.width - units.gu(2)
                                spacing: units.gu(0.5)

                                Row {
                                    width: parent.width
                                    spacing: units.gu(1)
                                    Rectangle {
                                        width:units.gu(4)
                                        height:units.gu(4)
                                        color: "transparent"
                                        Image {
                                            source: "../imgs/special.png"
                                            width: parent.width
                                            height: width
                                        }
                                    }
                                    Column {
                                        width: parent.width
                                        spacing: units.gu(1)
                                        Label {
                                            text: title
                                            width: parent.width-units.gu(5)
                                            textFormat: Text.RichText
                                            wrapMode: Text.WordWrap
                                        }
                                        Label {
                                            text: message
                                            fontSize: "small"
                                            width: parent.width-units.gu(5)
                                            textFormat: Text.RichText
                                            wrapMode: Text.WordWrap
                                        }
                                        Rectangle {
                                            width: parent.width-units.gu(5)
                                            height: spec_image == '' ? 0 : parent.width-units.gu(5)
                                            Image {
                                                source: spec_image
                                                width: parent.width
                                                height: parent.height
                                            }
                                        }
                                        Label {
                                            text: likes
                                            fontSize: "x-small"
                                            textFormat: Text.RichText
                                            wrapMode: Text.WordWrap
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Self tips
                    Column {
                        width: parent.width - units.gu(2)
                        spacing: units.gu(1)


                        Rectangle {
                            width: parent.width
                            height: selfTipValue.text == '' ? 0 : selfTipValue.height + units.gu(1)
                            color: "#cccccc"
                            id: selfTip
                            Label {
                                id: selfTipValue
                                anchors.centerIn: parent
                                color: "#000000"
                            }
                        }

                        ListModel {
                            id: selfTipsModel
                        }

                        Repeater {
                            model: selfTipsModel

                            Column {
                                width: parent.width
                                spacing: units.gu(0.5)

                                Row {
                                    width: parent.width
                                    spacing: units.gu(1)
                                    Rectangle {
                                        width:units.gu(4)
                                        height:units.gu(4)
                                        color: "transparent"
                                        Image {
                                            source: userimage
                                            width: parent.width
                                            height: width
                                        }
                                    }
                                    Column {
                                        width: parent.width
                                        spacing: units.gu(1)
                                        Label {
                                            text: username
                                            width: parent.width-units.gu(5)
                                            textFormat: Text.RichText
                                            wrapMode: Text.WordWrap

                                            MouseArea {
                                                anchors.fill: parent
                                                onClicked: {
                                                    userPage.title = username;
                                                    userpage.get_user(userid);
                                                    pageStack.push(userPage);
                                                }
                                            }
                                        }
                                        Label {
                                            text: message
                                            fontSize: "small"
                                            width: parent.width-units.gu(5)
                                            textFormat: Text.RichText
                                            wrapMode: Text.WordWrap
                                        }
                                        Rectangle {
                                            width: parent.width-units.gu(5)
                                            height: tip_img == '' ? 0 : parent.width-units.gu(5)
                                            Image {
                                                source: tip_img
                                                width: parent.width
                                                height: parent.height
                                            }
                                        }
                                        Label {
                                            text: likes
                                            fontSize: "x-small"
                                            textFormat: Text.RichText
                                            wrapMode: Text.WordWrap
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Friends tips
                    Column {
                        width: parent.width - units.gu(2)
                        spacing: units.gu(1)

                        Rectangle {
                            width: parent.width
                            height: friendTipValue.text == '' ? 0 : friendTipValue.height + units.gu(1)
                            color: "#cccccc"
                            id: friendTip
                            Label {
                                id: friendTipValue
                                anchors.centerIn: parent
                                color: "#000000"
                            }
                        }

                        ListModel {
                            id: friendsTipsModel
                        }

                        Repeater {
                            model: friendsTipsModel

                            Column {
                                width: parent.width
                                spacing: units.gu(0.5)

                                Row {
                                    width: parent.width
                                    spacing: units.gu(1)
                                    Rectangle {
                                        width:units.gu(4)
                                        height:units.gu(4)
                                        color: "transparent"
                                        Image {
                                            source: userimage
                                            width: parent.width
                                            height: width
                                        }
                                    }
                                    Column {
                                        width: parent.width
                                        spacing: units.gu(1)
                                        Label {
                                            text: username
                                            width: parent.width-units.gu(5)
                                            textFormat: Text.RichText
                                            wrapMode: Text.WordWrap

                                            MouseArea {
                                                anchors.fill: parent
                                                onClicked: {
                                                    userPage.title = username;
                                                    userpage.get_user(userid);
                                                    pageStack.push(userPage);
                                                }
                                            }
                                        }
                                        Label {
                                            text: message
                                            fontSize: "small"
                                            width: parent.width-units.gu(5)
                                            textFormat: Text.RichText
                                            wrapMode: Text.WordWrap
                                        }
                                        Rectangle {
                                            width: parent.width-units.gu(5)
                                            height: tip_img == '' ? 0 : parent.width-units.gu(5)
                                            Image {
                                                source: tip_img
                                                width: parent.width
                                                height: parent.height
                                            }
                                        }
                                        Label {
                                            text: likes
                                            fontSize: "x-small"
                                            textFormat: Text.RichText
                                            wrapMode: Text.WordWrap
                                        }
                                    }
                                }

                                ListItem.ThinDivider {}
                            }
                        }
                    }

                    // All tips
                    Column {
                        width: parent.width - units.gu(2)
                        spacing: units.gu(1)

                        Rectangle {
                            width: parent.width
                            height: otherTipValue.text == '' ? 0 : otherTipValue.height + units.gu(1)
                            color: "#cccccc"
                            id: otherTip
                            Label {
                                id: otherTipValue
                                anchors.centerIn: parent
                                color: "#000000"
                            }
                        }

                        ListModel {
                            id: othersTipsModel
                        }

                        Repeater {
                            model: othersTipsModel
                            width: parent.width

                            Column {
                                width: parent.width
                                spacing: units.gu(0.5)

                                Row {
                                    width: parent.width
                                    spacing: units.gu(1)
                                    Rectangle {
                                        width:units.gu(4)
                                        height:units.gu(4)
                                        color: "transparent"
                                        Image {
                                            source: userimage
                                            width: parent.width
                                            height: width
                                        }
                                    }
                                    Column {
                                        width: parent.width
                                        spacing: units.gu(1)
                                        Label {
                                            text: username
                                            width: parent.width-units.gu(5)
                                            textFormat: Text.RichText
                                            wrapMode: Text.WordWrap

                                            MouseArea {
                                                anchors.fill: parent
                                                onClicked: {
                                                    userPage.title = username;
                                                    userpage.get_user(userid);
                                                    pageStack.push(userPage);
                                                }
                                            }
                                        }
                                        Label {
                                            text: message
                                            fontSize: "small"
                                            width: parent.width-units.gu(5)
                                            textFormat: Text.RichText
                                            wrapMode: Text.WordWrap
                                        }
                                        Rectangle {
                                            width: parent.width-units.gu(5)
                                            height: tip_img == '' ? 0 : parent.width-units.gu(5)
                                            Image {
                                                source: tip_img
                                                width: parent.width
                                                height: parent.height
                                            }
                                        }
                                        Label {
                                            text: likes
                                            fontSize: "x-small"
                                            textFormat: Text.RichText
                                            wrapMode: Text.WordWrap
                                        }
                                    }
                                }

                                ListItem.ThinDivider {}
                            }
                        }
                    }
                }
            }
        }
    }

    Item {
        anchors.centerIn: parent
        opacity: venueitem.visible ? 0 : 1

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
}
