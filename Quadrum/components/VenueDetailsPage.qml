import QtQuick 2.0
import Ubuntu.Components 1.1
import QtQuick.LocalStorage 2.0
import Ubuntu.Components.ListItems 1.0 as ListItem
import "../js/scripts.js" as Scripts

Item {
    anchors {
        fill: parent
    }

    property var id

    property var venueArray

    function venue_details(venue_id, venueArray) {
        var token = Scripts.getKey('access_token');
        Scripts.venue_more_details(venue_id, token, venueArray);
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

            Column {
                width: parent.width
                x: units.gu(1)
                spacing: units.gu(1)

                Item {
                    width: parent.width
                    height: units.gu(0.5)
                }

                Label {
                    id: venuename
                    width: parent.width - units.gu(2)
                    fontSize: "large"
                    textFormat: Text.RichText
                    wrapMode: Text.WordWrap
                }
                Label {
                    id: venueaddress
                    fontSize: "small"
                    textFormat: Text.RichText
                    wrapMode: Text.WordWrap
                }
                Label {
                    id: venuecity
                    fontSize: "small"
                    textFormat: Text.RichText
                    wrapMode: Text.WordWrap
                    visible: text == '' ? false : true
                }
            }

            Column {
                width: parent.width
                spacing: units.gu(1)

                ListItem.Header {
                    id: venuedaysheader
                    text: i18n.tr("Hours")
                }
                ListItem.Standard {
                    id: venuedays
                    visible: venuetime.text == "" ? false : true
                    text: ""
                    control: Label {
                        id: venuetime
                        text: ""
                    }
                }

                ListItem.Header {
                    id: venueserveheader
                    text: i18n.tr("Food & Drink")
                }
                ListItem.Standard {
                    id: venueserve
                    visible: venueservevalue.text == "" ? false : true
                    text: ""
                    control: Label {
                        id: venueservevalue
                        text: ""
                        width: this.text.length > 25 ? units.gu(25) : this.text.paintedWidth
                        textFormat: Text.RichText
                        wrapMode: Text.WordWrap
                    }
                }
                ListItem.Standard {
                    id: venuedrinks
                    visible: venuedrinksvalue.text == "" ? false : true
                    text: ""
                    control: Label {
                        id: venuedrinksvalue
                        text: ""
                        width: this.text.length > 25 ? units.gu(25) : this.text.paintedWidth
                        textFormat: Text.RichText
                        wrapMode: Text.WordWrap
                    }
                }
                ListItem.Standard {
                    id: venuediningOptions
                    visible: venuediningOptionsvalue.text == "" ? false : true
                    text: ""
                    control: Label {
                        id: venuediningOptionsvalue
                        text: ""
                        width: this.text.length > 25 ? units.gu(25) : this.text.paintedWidth
                        textFormat: Text.RichText
                        wrapMode: Text.WordWrap
                    }
                }

                ListItem.Header {
                    id: venuefeaturesheader
                    text: i18n.tr("Features")
                }
                ListItem.Standard {
                    id: venuereservations
                    visible: venuereservationsvalue.text == "" ? false : true
                    text: ""
                    control: Label {
                        id: venuereservationsvalue
                        text: ""
                        width: this.text.length > 25 ? units.gu(25) : this.text.paintedWidth
                        textFormat: Text.RichText
                        wrapMode: Text.WordWrap
                    }
                }
                ListItem.Standard {
                    id: venuepayments
                    visible: venuepaymentsvalue.text == "" ? false : true
                    text: ""
                    control: Label {
                        id: venuepaymentsvalue
                        text: ""
                        width: this.text.length > 25 ? units.gu(25) : this.text.paintedWidth
                        textFormat: Text.RichText
                        wrapMode: Text.WordWrap
                    }
                }
                ListItem.Standard {
                    id: venueoutdoorSeating
                    visible: venueoutdoorSeatingvalue.text == "" ? false : true
                    text: ""
                    control: Label {
                        id: venueoutdoorSeatingvalue
                        text: ""
                        width: this.text.length > 25 ? units.gu(25) : this.text.paintedWidth
                        textFormat: Text.RichText
                        wrapMode: Text.WordWrap
                    }
                }
                ListItem.Standard {
                    id: venuemusic
                    visible: venuemusicvalue.text == "" ? false : true
                    text: ""
                    control: Label {
                        id: venuemusicvalue
                        text: ""
                        width: this.text.length > 25 ? units.gu(25) : this.text.paintedWidth
                        textFormat: Text.RichText
                        wrapMode: Text.WordWrap
                    }
                }
                ListItem.Standard {
                    id: venuewifi
                    visible: venuewifivalue.text == "" ? false : true
                    text: ""
                    control: Label {
                        id: venuewifivalue
                        text: ""
                        width: this.text.length > 25 ? units.gu(25) : this.text.paintedWidth
                        textFormat: Text.RichText
                        wrapMode: Text.WordWrap
                    }
                }
                ListItem.Standard {
                    id: venuerestroom
                    visible: venuerestroomvalue.text == "" ? false : true
                    text: ""
                    control: Label {
                        id: venuerestroomvalue
                        text: ""
                        width: this.text.length > 25 ? units.gu(25) : this.text.paintedWidth
                        textFormat: Text.RichText
                        wrapMode: Text.WordWrap
                    }
                }

                ListItem.Header {
                    id: venuesocialheader
                    text: i18n.tr("Social")
                }
                ListItem.Standard {
                    id: venuetwittername
                    visible: venuetwittervalue.text == "" ? false : true
                    text: ""
                    control: Label {
                        id: venuetwittervalue
                        text: ""
                        width: this.text.length > 25 ? units.gu(25) : this.text.paintedWidth
                        textFormat: Text.RichText
                        wrapMode: Text.WordWrap
                    }
                    progression: true
                    onClicked: Qt.openUrlExternally("http://twitter.com/"+venuetwittervalue.text)
                }
                ListItem.Standard {
                    id: venueweb
                    visible: venuewebvalue.text == "" ? false : true
                    text: ""
                    control: Label {
                        id: venuewebvalue
                        text: ""
                        width: this.text.length > 25 ? units.gu(25) : this.text.paintedWidth
                        textFormat: Text.RichText
                        wrapMode: Text.WordWrap
                    }
                    progression: true
                    onClicked: Qt.openUrlExternally("http://" + venuewebvalue.text)
                }
                ListItem.Standard {
                    id: venuetotalvisitors
                    visible: venuetotalvisitorsvalue.text == "" ? false : true
                    text: ""
                    control: Label {
                        id: venuetotalvisitorsvalue
                        text: ""
                        width: this.text.length > 25 ? units.gu(25) : this.text.paintedWidth
                        textFormat: Text.RichText
                        wrapMode: Text.WordWrap
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
