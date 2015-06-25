import QtQuick 2.0
import Ubuntu.Components 1.1
import QtQuick.LocalStorage 2.0
import Ubuntu.Components.ListItems 1.0 as ListItem
import Ubuntu.Content 1.1
import "../js/scripts.js" as Scripts

Item {
    anchors {
        margins: units.gu(1)
        fill: parent
    }

    // Others
    property string id

    property var venueArray

    property var fileUrl

    property bool facebook : false

    property bool twitter : false

    function checkin(venue_id, venueArray) {
        var token = Scripts.getKey('access_token');
        checkinPage.title = venueArray['response']['venue']['name'];
    }

    function checkedin(id) {
        quadrumMetrics.increment();
        checkindetails.id = id;
        checkindetails.refresh = '1';
        checkindetails.checkin_details(id);
        pageStack.push(checkinDetails);
    }
    /*
    function addImportedImage(contentItem) {
        console.log("CONTENT IMPORTED:", contentItem.url.toString().replace("file://", ""));
        var filepath = contentItem.url.toString().replace("file://", "");
        var fileparts = filepath.split("/");
        var filename = fileparts.pop();
        console.log("Filename: "+filename);
        user_image.source = filepath;
        checkinpage.fileUrl = filepath;
        userimage.visible = true;
        addPicture.visible = false;
        removePicture.visible = true;
    }
    */

    Column {
        width: parent.width

        TextArea {
            id: comment
            width: parent.width
            height: units.gu(12)
            contentWidth: parent.width
            contentHeight: units.gu(30)
            placeholderText: i18n.tr("What are you up to?")
        }

        Item {
            width: parent.width
            height: units.gu(1)
        }

        Row {
            width: facebooksharerect.width + twittersharerect.width + units.gu(1)
            x: parent.width - width
            Rectangle {
                id: facebooksharerect
                width: facebooksharebutton.width
                height: facebooksharebutton.height
                color: "transparent"
                Button {
                    id: facebooksharebutton
                    text: "Facebook"
                    color: checkinpage.facebook ? "#3b5998" : "darkGrey"
                    onClicked: {
                        checkinpage.facebook ? checkinpage.facebook = false : checkinpage.facebook = true;
                        checkinpage.facebook ? facebooksharebutton.color = "#3b5998" : facebooksharebutton.color = "darkGrey";
                    }
                }
            }

            Item {
                width: units.gu(1)
                height: units.gu(1)
            }

            Rectangle {
                id: twittersharerect
                width: twittersharebutton.width
                height: twittersharebutton.height
                color: "transparent"
                Button {
                    id: twittersharebutton
                    text: "Twitter"
                    color: checkinpage.twitter ? "#55ACEE" : "darkGrey"
                    onClicked: {
                        checkinpage.twitter ? checkinpage.twitter = false : checkinpage.twitter = true;
                        checkinpage.twitter ? twittersharebutton.color = "#55ACEE" : twittersharebutton.color = "darkGrey";
                    }
                }
            }
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
                color: "#FD9627"
                text: i18n.tr("Check in")
                onClicked: {
                    var token = Scripts.getKey('access_token');
                    var text = comment.getText(0, 140);
                    //console.log('ehey:' + fileurl);
                    Scripts.add_checkin(checkinpage.id, token, text, checkinpage.fileUrl, checkinpage.facebook, checkinpage.twitter);
                }
            }
        }
    }
}
