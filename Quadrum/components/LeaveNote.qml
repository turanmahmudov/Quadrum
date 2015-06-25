import QtQuick 2.0
import Ubuntu.Components 1.1
import QtQuick.LocalStorage 2.0
import Ubuntu.Components.ListItems 1.0 as ListItem
import "../js/scripts.js" as Scripts

Item {
    anchors {
        margins: units.gu(1)
        fill: parent
    }

    property var venueId

    Column {
        width: parent.width

        TextArea {
            id: note
            width: parent.width
            height: units.gu(12)
            contentWidth: parent.width
            contentHeight: units.gu(30)
            placeholderText: i18n.tr("Your note")
        }

        Item {
            width: parent.width
            height: units.gu(1)
        }

        Row {
            width: parent.width
            Button {
                width: parent.width/2 - units.gu(1)
                text: i18n.tr("Cancel")
                onClicked: {
                    pageStack.pop();
                }
            }

            Item {
                width: units.gu(2)
                height: units.gu(1)
            }

            Button {
                width: parent.width/2 - units.gu(1)
                color: "#2d5be3"
                text: i18n.tr("Leave note")
                onClicked: {
                    var token = Scripts.getKey('access_token');
                    var text = note.getText(0, 140);
                    Scripts.leavenote(venueId, text);
                }
            }
        }
    }
}
