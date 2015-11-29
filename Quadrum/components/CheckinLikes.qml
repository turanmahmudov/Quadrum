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

    function get_likes(checkin_id) {
        Scripts.checkin_likes(checkin_id, Scripts.getKey('access_token'));
    }

    ListModel {
        id: likesModel
    }

    ListView {
        id:likes
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        clip: true

        model:likesModel
        delegate: ListItem.Empty {
            height: user_name.height + units.gu(3)
            width: parent.width
            Item {
                id: delegateitem
                anchors.fill: parent
                anchors.topMargin: units.gu(1)
                width: parent.width

                Label {
                    anchors.top: parent.top
                    color: "#000"
                    id: user_name
                    text: username
                    textFormat: Text.RichText
                }
            }

            onClicked: {
                //checkindetails.checkin_details(id);
                //pageStack.push(checkinDetails);
            }
        }
        PullToRefresh {
            id: pullToRefresh
            refreshing: checkinlikes.finished == false
            onRefresh: get_likes()
        }
    }

    Item {
        anchors.centerIn: parent
        opacity: checkinlikes.finished == false ? 1 : 0

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
