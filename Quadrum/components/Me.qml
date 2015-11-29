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

    function get_me() {
        Scripts.get_me(Scripts.getKey('access_token'));
    }

    Rectangle {
        id: userimage
        anchors.top: parent.top
        anchors.left: parent.left
        width: units.gu(16)
        height: width
        color: "transparent"
        Image {
            width: parent.width
            height: parent.height
            id: user_image
        }
    }
    Label {
        anchors.top: parent.top
        anchors.left: userimage.right
        anchors.leftMargin: units.gu(1)
        id: user_name
        width: parent.width - userimage.width - units.gu(2)
        textFormat: Text.RichText
        wrapMode: Text.WordWrap
    }
    Label {
        anchors.top: user_name.bottom
        anchors.left: userimage.right
        anchors.leftMargin: units.gu(1)
        id: user_homecity
        width: parent.width - userimage.width - units.gu(2)
        textFormat: Text.RichText
        wrapMode: Text.WordWrap
    }
    /*
    Button {
        id: mysettingsbutton
        anchors.left: userimage.right
        anchors.leftMargin: units.gu(1)
        anchors.top: user_homecity.bottom
        anchors.topMargin: units.gu(1)
        width: parent.width - userimage.width - units.gu(2)
        text: i18n.tr("My Settings")
        iconName: "settings"
        clip: false
        onClicked: {
            console.log("MY SETTINGS CLICKED.");
        }
    }
    */
    Label {
        anchors.top: userimage.bottom
        anchors.topMargin: units.gu(1)
        anchors.left: parent.left
        id: user_bio
        width: parent.width - units.gu(1)
        fontSize: "small"
        textFormat: Text.RichText
        wrapMode: Text.WordWrap
    }
    /*
    Column {
        anchors.top: user_bio.bottom
        anchors.topMargin: units.gu(1)
        width: parent.width
        spacing: units.gu(1.5)

        Row {
            width: parent.width
            spacing: units.gu(1.5)

            Rectangle {
                color: "#ff0000"
                width: units.gu(15)
                height: width
            }

            Rectangle {
                color: "#ff0000"
                width: units.gu(15)
                height: width
            }

            Rectangle {
                color: "#ff0000"
                width: units.gu(15)
                height: width
            }
        }

        Row {
            width: parent.width
            spacing: units.gu(1.5)

            Rectangle {
                color: "#ff0000"
                width: units.gu(15)
                height: width
            }

            Rectangle {
                color: "#ff0000"
                width: units.gu(15)
                height: width
            }

            Rectangle {
                color: "#ff0000"
                width: units.gu(15)
                height: width
            }
        }
    }
    */

    Item {
        anchors.centerIn: parent
        opacity: mepage.finished == false ? 1 : 0

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
