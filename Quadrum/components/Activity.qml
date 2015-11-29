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

    function get_activity() {
        Scripts.activities(Scripts.getKey('access_token'));
    }

    ListModel {
        id: activitiesModel
    }

    ListView {
        id:activities
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        clip: true

        model:activitiesModel
        delegate: ListItem.Empty {
            height: checkinimg == '' ? username_name_address_likes_comments.height + units.gu(2) :
                                       username_name_address_likes_comments.height + checkinphoto.height + units.gu(3)
            width: parent.width

            Item {
                id: delegateitem
                anchors.fill: parent
                anchors.topMargin: units.gu(1)
                width: parent.width

                Rectangle {
                    id: userimage
                    anchors.top: parent.top
                    anchors.left: parent.left
                    width: units.gu(5)
                    height: width
                    Image {
                        source: user_image
                        width: parent.width
                        height: parent.height
                    }
                }
                Column {
                    id: username_name_address_likes_comments
                    x: units.gu(6)
                    spacing: units.gu(0.2)
                    width: parent.width - userimage.width - like_time.width - units.gu(2)
                    Label {
                        color: "#000"
                        id: user_name
                        fontSize: "small"
                        text: username
                        textFormat: Text.RichText
                    }
                    Label {
                        color: "#2d5be3"
                        id: placetitle
                        fontSize: "large"
                        text: placename
                        width: parent.width - units.gu(1)
                        textFormat: Text.RichText
                        wrapMode: Text.WordWrap
                    }
                    Row {
                        width: parent.width
                        spacing: units.gu(0.5)
                        Label {
                            id: placeaddress
                            text: placeadd
                            fontSize: "x-small"
                            textFormat: Text.RichText
                            wrapMode: Text.WordWrap
                        }
                        Icon {
                            anchors.verticalCenter: actlikes.verticalCenter
                            name: "like"
                            color: "#ff0000"
                            width: likes == '0' ? 0 : units.gu(1.3)
                            height: likes == '0' ? 0 : units.gu(1.3)
                        }
                        Label {
                            id: actlikes
                            visible: likes == '0' ? false : true
                            text: likes
                            fontSize: "x-small"
                            textFormat: Text.RichText
                            wrapMode: Text.WordWrap
                        }
                        Icon {
                            anchors.verticalCenter: actcomments.verticalCenter
                            name: "message"
                            color: "#FF8632"
                            width: comments == '0' ? 0 : units.gu(1.3)
                            height: comments == '0' ? 0 : units.gu(1.3)
                        }
                        Label {
                            id: actcomments
                            visible: comments == '0' ? false : true
                            text: comments
                            fontSize: "x-small"
                            textFormat: Text.RichText
                            wrapMode: Text.WordWrap
                        }
                    }
                    Label {
                        color: "#000"
                        id: user_shout
                        text: usershout
                        width: parent.width - units.gu(1)
                        height: usershout == '' ? 0 : user_shout.contentHeight
                        textFormat: Text.RichText
                        wrapMode: Text.WordWrap
                    }
                }

                Item {
                    id: like_time
                    anchors.top: parent.top
                    anchors.right: parent.right
                    width: units.gu(4)

                    Icon {
                        anchors.horizontalCenter: parent.horizontalCenter
                        id: actlike
                        name: "like"
                        color: like == '1' ? '#ff0000' : UbuntuColors.darkGrey
                        width: units.gu(3)
                        height: width
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (actlike.color == "#ff0000") {
                                    Scripts.like_checkin(id, 0);
                                    actlike.color = UbuntuColors.darkGrey;
                                } else {
                                    Scripts.like_checkin(id, 1);
                                    actlike.color = '#ff0000';
                                }
                            }
                        }
                    }

                    Label {
                        anchors.top: actlike.bottom
                        anchors.topMargin: units.gu(1)
                        anchors.horizontalCenter: parent.horizontalCenter
                        id: actdate
                        text: date
                        fontSize: "x-small"
                        textFormat: Text.RichText
                        wrapMode: Text.WordWrap
                    }
                }

                Rectangle {
                    anchors.top: username_name_address_likes_comments.bottom
                    anchors.topMargin: units.gu(0.5)
                    anchors.left: userimage.right
                    anchors.leftMargin: units.gu(1)
                    id: checkinphoto
                    width: parent.width - userimage.width - units.gu(1)
                    height: checkinimg == '' ? 0 : width
                    color: "transparent"
                    Image {
                        id:checkin_img
                        source: checkinimg
                        width: parent.width
                        height: parent.height
                    }
                }
            }

            onClicked: {
                checkindetails.checkin_details(id);
                pageStack.push(checkinDetails);
            }
        }
        PullToRefresh {
            id: pullToRefresh
            refreshing: activitypage.finished == false
            onRefresh: get_activity()
        }
    }

    Item {
        anchors.centerIn: parent
        opacity: activitypage.finished == false ? 1 : 0

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
