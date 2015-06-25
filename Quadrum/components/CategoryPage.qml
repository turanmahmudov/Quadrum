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

    property string section
    property bool finished: false

    function category(section, headSection) {
        sectionPlacesModel.clear();
        indicat.opacity = 1;
        if (!headSection || headSection == '') {
            headSection = categoryPage.head.sections.selectedIndex;
        }
        if (mainView.coord.latitude) {
            var token = Scripts.getKey('access_token');
            Scripts.category(mainView.coord.latitude, mainView.coord.longitude, section, token, headSection);
        }
    }

    ListModel {
        id: sectionPlacesModel
    }

    ListView {
        id:sectionPlaces
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        clip: true
        model: sectionPlacesModel
        delegate: ListItem.Empty {
            width: parent.width
            height: tip == '' ? placetitle.height + placerating.height + units.gu(4) :
                                placetitle.height + placerating.height + placetip.height + units.gu(4)
            Item {
                id: delegateitem
                anchors.fill: parent
                width: parent.width
                anchors.topMargin: units.gu(1)
                Label {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    color: "#2d5be3"
                    fontSize: "small"
                    id: placetitle
                    text: name
                    textFormat: Text.RichText
                }
                Item {
                    id: placeinfos
                    anchors.top: placetitle.bottom
                    anchors.left: parent.left
                    Rectangle {
                        visible: (placeratingtext.text == '') ? false : true
                        anchors.top: parent.top
                        anchors.left: parent.left
                        id: placerating
                        width: rating == '' ? 0 : placeratingtext.width + units.gu(1)
                        height: rating == '' ? 0 : placeratingtext.height + units.gu(1)
                        color: ratingColor
                        Label {
                            id: placeratingtext
                            anchors.centerIn: parent
                            color: "#ffffff"
                            fontSize: "xx-small"
                            text: rating
                        }
                    }
                    Label {
                        anchors.top: parent.top
                        anchors.left:placerating.right
                        anchors.leftMargin: (placeratingtext.text == '') ? 0 : units.gu(1)
                        fontSize: "x-small"
                        id: placecategory
                        text: category_name
                    }
                    Label {
                        anchors.top: parent.top
                        anchors.left: placecategory.right
                        anchors.leftMargin: units.gu(1)
                        fontSize: "x-small"
                        id: placeaddress
                        text: distance
                    }
                }
                Item {
                    id: placetips
                    width: parent.width
                    height: tip == '' ? 0 : placetip.height
                    anchors.top: placeinfos.bottom
                    anchors.topMargin: units.gu(2)
                    anchors.left: parent.left
                    Text {
                        id: placetip
                        text: tip
                        width: parent.width
                        font.pointSize: units.gu(1.1)
                        wrapMode: Text.WordWrap
                    }
                }

            }
            showDivider: true

            onClicked: {
                venuepage.venue(id);
                pageStack.push(venuePage);
            }
        }
    }

    Item {
        id: indicat
        anchors.centerIn: parent
        opacity: finished == false ? 1 : 0

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
        visible: sectionPlacesModel.count == 0 && mainView.coord.latitude && finished == true ? true : false
        anchors.margins: units.gu(1)
        anchors.fill: parent

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: i18n.tr("Sorry! No results for ") + "<b>" + section + "</b>"
        }

    }
}
