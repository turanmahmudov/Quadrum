import QtQuick 2.0
import Ubuntu.Components 1.1
import QtQuick.LocalStorage 2.0
import Ubuntu.Components.ListItems 1.0 as ListItem
import QtLocation 5.0 as Location
import Ubuntu.Components.Popups 1.0
import "../js/scripts.js" as Scripts

/*

  * Open user page onClick on comment user

  */

Item {
    anchors {
        fill: parent
    }

    property string refresh
    property bool liked : false
    property var id
    property var place_id
    property var user_id
    property var user_name

    function checkin_details(checkin_id) {
        var token = Scripts.getKey('access_token');
        Scripts.checkin_details(checkin_id, token);
    }

    // Delete Comment
    Component {
        id: deleteCommentDialog

        Dialog {
            id: deleteCommentDialogue

            property var commentText
            property var commentId
            property var id

            text: commentText

            Button {
                text: "Delete"
                color: "#2d5be3"
                onClicked: {
                    Scripts.delete_checkin_comment(id, commentId);
                    PopupUtils.close(deleteCommentDialogue)
                }
            }

            Button {
                text: "Close"
                onClicked: {
                    PopupUtils.close(deleteCommentDialogue)
                }
            }
        }
    }

    Flickable {
        id: flick
        clip: true
        width: parent.width
        height: parent.height
        contentWidth: parent.width
        contentHeight: checkedinitem.height

        Column {
            id: checkedinitem
            spacing: units.gu(1)
            visible: false
            width: parent.width
            clip: true

            Column {
                id: maps
                width: parent.width
                height: parent.width*3/10

                Location.Map {
                    width: parent.width
                    height: parent.height
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

            Column {
                id: others
                spacing: units.gu(1)
                width: parent.width

                Row {
                    width: parent.width
                    spacing: units.gu(1)

                    Item {
                        width: units.gu(0.1)
                        height: units.gu(1)
                    }

                    Image {
                        id: userimage
                        width: units.gu(5)
                        height: units.gu(5)

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                userPage.title = user_name;
                                userpage.get_user(user_id);
                                pageStack.push(userPage);
                            }
                        }
                    }

                    Column {
                        width: parent.width - units.gu(6)
                        spacing: units.gu(0.3)

                        Label {
                            width: parent.width - units.gu(2);
                            color: "#2d5be3"
                            id: placetitle
                            fontSize: "large"
                            textFormat: Text.RichText
                            wrapMode: Text.WordWrap
                            MouseArea {
                                width: parent.width
                                height: parent.height
                                onClicked: {
                                    venuepage.venue(place_id);
                                    pageStack.push(venuePage);
                                }
                            }
                        }

                        Label {
                            id: placeaddress
                            width: parent.width - units.gu(2)
                            fontSize: "small"
                            textFormat: Text.RichText
                            wrapMode: Text.WordWrap
                        }

                        Item {
                            width: parent.width
                            height: units.gu(0.2)
                        }

                        Label {
                            color: "#000"
                            id: user_shout
                            width: parent.width - units.gu(2);
                            textFormat: Text.RichText
                            wrapMode: Text.WordWrap
                        }

                        Item {
                            width: parent.width
                            height: user_shout.text == '' ? 0 : units.gu(0.5)
                        }

                        Item {
                            width: parent.width - units.gu(2)
                            height: checkin_photo.source == '' ? 0 : width
                            Image {
                                id: checkin_photo
                                width: parent.width
                                height: parent.height
                            }
                        }

                        Item {
                            width: parent.width
                            height: checkin_photo.source == '' ? 0 : units.gu(0.5)
                        }

                        Item {
                            id: checkinscores
                            anchors.left: parent.left
                            anchors.leftMargin: -units.gu(3)
                            width: parent.width - units.gu(2)
                            height: scoresC.height

                            ListModel {
                                id: scoresModel
                            }

                            Column {
                                id: scoresC
                                width: parent.width
                                spacing: units.gu(1)

                                Repeater {
                                    model: scoresModel

                                    Row {
                                        width: scoresC.width
                                        spacing: units.gu(1)
                                        Image {
                                            source: icons
                                            width: units.gu(2)
                                            height: units.gu(2)
                                        }

                                        Label {
                                            width: parent.width
                                            text: desc
                                            fontSize: "small"
                                            textFormat: Text.RichText
                                            wrapMode: Text.WordWrap
                                        }
                                    }
                                }
                            }
                        }

                        Item {
                            width: parent.width
                            height: scoresModel.count == 0 ? 0 : units.gu(0.5)
                        }

                        Item {
                            id: likessum
                            anchors.left: parent.left
                            anchors.leftMargin: -units.gu(3)
                            width: parent.width - userimage.width - units.gu(3)
                            height: likessummary.text == '' ? 0 : likessumm.height
                            visible: likessummary.text == '' ? false : true

                            Column {
                                id: likessumm
                                width: parent.width

                                Row {
                                    width: parent.width
                                    spacing: units.gu(1)

                                    Icon {
                                        name: "like"
                                        width: units.gu(2)
                                        height: units.gu(2)
                                    }

                                    Label {
                                        width: parent.width
                                        id: likessummary
                                        text: ""
                                        fontSize: "small"
                                        textFormat: Text.RichText
                                        wrapMode: Text.WordWrap
                                    }
                                }
                            }

                            MouseArea {
                                width: parent.width
                                height: parent.height
                                onClicked: {
                                    console.log("likes list")
                                    checkinlikes.get_likes(id);
                                    pageStack.push(checkinLikes);
                                }
                            }
                        }

                        Item {
                            width: parent.width
                            height: checkinphotosModel.count == 0 ? 0 : units.gu(1.5)
                        }

                        Item {
                            id: checkinphotos
                            width: parent.width
                            height: checkinphotosModel.count == 0 ? 0 : checkinphotosC.height
                            anchors.left: parent.left
                            anchors.leftMargin: -units.gu(7)

                            ListModel {
                                id: checkinphotosModel
                            }

                            Column {
                                id: checkinphotosC
                                width: parent.width
                                spacing: units.gu(1)

                                Repeater {
                                    model: checkinphotosModel

                                    Column {
                                        width: checkinphotosC.width
                                        spacing: units.gu(1)

                                        Rectangle {
                                            width: parent.width - units.gu(2)
                                            height: units.gu(0.1)
                                            color: "#ddd"
                                            anchors.left: parent.left
                                            anchors.leftMargin: units.gu(7.1)
                                        }

                                        Row {
                                            width: parent.width
                                            spacing: units.gu(1)

                                            Item {
                                                width: units.gu(0.1)
                                                height: units.gu(1)
                                            }

                                            Image {
                                                source: userphoto
                                                width: units.gu(5)
                                                height: units.gu(5)
                                            }

                                            Column {
                                                width: parent.width
                                                spacing: units.gu(1)
                                                Label {
                                                    width: parent.width - units.gu(2)
                                                    text: username
                                                    fontSize: "small"
                                                    textFormat: Text.RichText
                                                    wrapMode: Text.WordWrap
                                                }

                                                Image {
                                                    width: parent.width - units.gu(2)
                                                    height: width
                                                    source: checkinphoto
                                                }

                                                Label {
                                                    width: parent.width
                                                    text: time + i18n.tr(' ago')
                                                    fontSize: "small"
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }//checkin photos

                        Item {
                            width: parent.width
                            height: checkinCommentsModel.count == 0 ? 0 : units.gu(1)
                        }

                        Item {
                            id: checkincomments
                            width: parent.width
                            height: checkinCommentsModel.count == 0 ? 0 : checkincommentsC.height
                            anchors.left: parent.left
                            anchors.leftMargin: -units.gu(7)

                            ListModel {
                                id: checkinCommentsModel
                            }

                            Column {
                                id: checkincommentsC
                                width: parent.width
                                spacing: units.gu(1)

                                Repeater {
                                    model: checkinCommentsModel

                                    Column {
                                        width: checkincommentsC.width
                                        spacing: units.gu(1)

                                        Rectangle {
                                            anchors.left: parent.left
                                            anchors.leftMargin: units.gu(7.1)
                                            width: parent.width - units.gu(2)
                                            height: units.gu(0.1)
                                            color: "#ddd"
                                        }

                                        Row {
                                            width: parent.width
                                            spacing: units.gu(1)

                                            Item {
                                                width: units.gu(0.1)
                                                height: units.gu(1)
                                            }

                                            Image {
                                                source: userphoto
                                                width: units.gu(5)
                                                height: units.gu(5)
                                            }

                                            Column {
                                                width: parent.width
                                                spacing: units.gu(0.5)
                                                Label {
                                                    width: parent.width
                                                    text: "<b>" + username + "</b>"
                                                    fontSize: "small"
                                                    textFormat: Text.RichText
                                                    wrapMode: Text.WordWrap
                                                    MouseArea {
                                                        width: parent.width
                                                        height: parent.height
                                                        onClicked: {
                                                            userPage.title = username;
                                                            userpage.get_user(userid);
                                                            pageStack.push(userPage);
                                                        }
                                                    }
                                                }

                                                Label {
                                                    width: parent.width - units.gu(2)
                                                    text: ctext
                                                    textFormat: Text.RichText
                                                    wrapMode: Text.WordWrap

                                                    MouseArea {
                                                        width: parent.width
                                                        height: parent.height
                                                        onPressAndHold: {
                                                            if (relationship == 'self') {
                                                                PopupUtils.open(deleteCommentDialog, mainView, {"commentId":cid, "commentText":ctext, "id":id})
                                                            }
                                                        }
                                                    }
                                                }

                                                Label {
                                                    width: parent.width - units.gu(2)
                                                    text: time + i18n.tr(' ago')
                                                    fontSize: "x-small"
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }// checkin comments
                    }
                }//row end
            }

            Item {
                width: parent.width
                height: units.gu(5)
            }
        }
    }

    Rectangle {
        z: 100
        width: parent.width
        height: units.gu(5)
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        border.color: "#ccc"
        color: "#ddd"
        Row {
            width: parent.width
            height: parent.height
            Item {
                width: units.gu(1.5)
                height: parent.height
            }

            Icon {
                anchors.verticalCenter: parent.verticalCenter
                name: "like"
                color: liked == true ? "#ff0000" : UbuntuColors.darkGrey
                width: units.gu(2.5)
                height: width
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (liked == true) {
                            Scripts.like_checkin(id, 0);
                            liked = false;
                        } else {
                            Scripts.like_checkin(id, 1);
                            liked = true;
                        }
                    }
                }
            }

            Item {
                width: units.gu(1)
                height: parent.height
            }

            TextField {
                id: commentfield
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - units.gu(10)
                hasClearButton: true
                placeholderText: i18n.tr("Add a comment")
            }

            Item {
                width: units.gu(1)
                height: parent.height
            }

            Icon {
                anchors.verticalCenter: parent.verticalCenter
                name: "go-next"
                width: units.gu(2.5)
                height: width
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        Scripts.comment_checkin(id, commentfield.text);
                    }
                }
            }
        }
    }

    Item {
        anchors.centerIn: parent
        opacity: checkedinitem.visible ? 0 : 1

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
