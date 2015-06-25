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

    function best_places() {
        Scripts.bestPlaces(mainView.coord.latitude, mainView.coord.longitude, Scripts.getKey('access_token'));
    }

    Button {
        id: food
        width: parent.width
        height: units.gu(6)
        anchors.top: parent.top
        anchors.topMargin: units.gu(0)
        Rectangle  {
            anchors.fill: parent
            Image  {
               anchors.fill: parent
               source: "../imgs/food.jpg"
            }
            Item {
                anchors.centerIn: parent
                height: units.gu(4)
                width: foodimage.width + foodlabel.width
                Item {
                    id: foodimage
                    width: units.gu(4)
                    height: parent.height
                    Image {
                        anchors.fill: parent
                        source: "../imgs/food_img.png"
                    }
                }
                Item {
                    id: foodlabel
                    anchors.left: foodimage.right
                    height: units.gu(4)
                    width: foodlabell.contentWidth
                    Label {
                        anchors.centerIn: parent
                        id: foodlabell
                        text: i18n.tr("Food")
                        fontSize: "x-large"
                        color: "#ffffff"
                    }
                }
            }
        }
        onClicked: {
            categorypage.section = 'food';
            categoryPage.head.sections.selectedIndex = 0
            categorypage.category('food');
            pageStack.push(categoryPage);
            categoryPage.title = i18n.tr('Food');
        }
    }

    Button {
        id: coffee
        width: parent.width
        height: units.gu(6)
        anchors.top: food.bottom
        anchors.topMargin: units.gu(1)

        Rectangle  {
            anchors.fill: parent
            Image  {
               anchors.fill: parent
               source: "../imgs/coffee.jpg"
            }
            Item {
                anchors.centerIn: parent
                height: units.gu(4)
                width: coffeeimage.width + coffeelabel.width
                Item {
                    id: coffeeimage
                    width: units.gu(4)
                    height: parent.height
                    Image {
                        anchors.fill: parent
                        source: "../imgs/coffee_img.png"
                    }
                }
                Item {
                    id: coffeelabel
                    anchors.left: coffeeimage.right
                    height: units.gu(4)
                    width: coffeelabell.contentWidth
                    Label {
                        anchors.centerIn: parent
                        id: coffeelabell
                        text: i18n.tr("Coffee")
                        fontSize: "x-large"
                        color: "#ffffff"
                    }
                }
            }
        }
        onClicked: {
            categorypage.section = 'coffee';
            categoryPage.head.sections.selectedIndex = 0
            categorypage.category('coffee');
            pageStack.push(categoryPage);
            categoryPage.title = i18n.tr('Coffee');
        }
    }

    Button {
        id: outdoors
        width: parent.width
        height: units.gu(6)
        anchors.top: coffee.bottom
        anchors.topMargin: units.gu(1)

        Rectangle  {
            anchors.fill: parent
            Image  {
               anchors.fill: parent
               source: "../imgs/outdoors.jpg"
            }
            Item {
                anchors.centerIn: parent
                height: units.gu(4)
                width: outdoorsimage.width + outdoorslabel.width
                Item {
                    id: outdoorsimage
                    width: units.gu(4)
                    height: parent.height
                    Image {
                        anchors.fill: parent
                        source: "../imgs/outdoors_img.png"
                    }
                }
                Item {
                    id: outdoorslabel
                    anchors.left: outdoorsimage.right
                    height: units.gu(4)
                    width: outdoorslabell.contentWidth
                    Label {
                        anchors.centerIn: parent
                        id: outdoorslabell
                        text: i18n.tr("Outdoors")
                        fontSize: "x-large"
                        color: "#ffffff"
                    }
                }
            }
        }
        onClicked: {
            categorypage.section = 'outdoors';
            categoryPage.head.sections.selectedIndex = 0
            categorypage.category('outdoors');
            pageStack.push(categoryPage);
            categoryPage.title = i18n.tr('Outdoors');
        }
    }

    Button {
        id: nightlife
        width: parent.width
        height: units.gu(6)
        anchors.top: outdoors.bottom
        anchors.topMargin: units.gu(1)

        Rectangle  {
            anchors.fill: parent
            Image  {
               anchors.fill: parent
               source: "../imgs/nightlife.jpg"
            }
            Item {
                anchors.centerIn: parent
                height: units.gu(4)
                width: nightlifeimage.width + nightlifelabel.width
                Item {
                    id: nightlifeimage
                    width: units.gu(4)
                    height: parent.height
                    Image {
                        anchors.fill: parent
                        source: "../imgs/nightlife_img.png"
                    }
                }
                Item {
                    id: nightlifelabel
                    anchors.left: nightlifeimage.right
                    height: units.gu(4)
                    width: nightlifelabell.contentWidth
                    Label {
                        anchors.centerIn: parent
                        id: nightlifelabell
                        text: i18n.tr("Nightlife")
                        fontSize: "x-large"
                        color: "#ffffff"
                    }
                }
            }
        }
        onClicked: {
            categorypage.section = 'nightlife';
            categoryPage.head.sections.selectedIndex = 0
            categorypage.category('nightlife');
            pageStack.push(categoryPage);
            categoryPage.title = i18n.tr('Nightlife');
        }
    }

    Button {
        id: shopping
        width: parent.width
        height: units.gu(6)
        anchors.top: nightlife.bottom
        anchors.topMargin: units.gu(1)

        Rectangle  {
            anchors.fill: parent
            Image  {
               anchors.fill: parent
               source: "../imgs/shopping.jpg"
            }
            Item {
                anchors.centerIn: parent
                height: units.gu(4)
                width: shoppingimage.width + shoppinglabel.width
                Item {
                    id: shoppingimage
                    width: units.gu(4)
                    height: parent.height
                    Image {
                        anchors.fill: parent
                        source: "../imgs/shopping_img.png"
                    }
                }
                Item {
                    id: shoppinglabel
                    anchors.left: shoppingimage.right
                    height: units.gu(4)
                    width: shoppinglabell.contentWidth
                    Label {
                        anchors.centerIn: parent
                        id: shoppinglabell
                        text: i18n.tr("Shopping")
                        fontSize: "x-large"
                        color: "#ffffff"
                    }
                }
            }
        }
        onClicked: {
            categorypage.section = 'shops';
            categoryPage.head.sections.selectedIndex = 0
            categorypage.category('shops');
            pageStack.push(categoryPage);
            categoryPage.title = i18n.tr('Shopping');
        }
    }

    Button {
        id: entertainment
        width: parent.width
        height: units.gu(6)
        anchors.top: shopping.bottom
        anchors.topMargin: units.gu(1)

        Rectangle  {
            anchors.fill: parent
            Image  {
               anchors.fill: parent
               source: "../imgs/entertainment.jpg"
            }
            Item {
                anchors.centerIn: parent
                height: units.gu(4)
                width: enternainmentimage.width + enternainmentlabel.width
                Item {
                    id: enternainmentimage
                    width: units.gu(4)
                    height: parent.height
                    Image {
                        anchors.fill: parent
                        source: "../imgs/entertainment_img.png"
                    }
                }
                Item {
                    id: enternainmentlabel
                    anchors.left: enternainmentimage.right
                    height: units.gu(4)
                    width: enternainmentlabell.contentWidth
                    Label {
                        anchors.centerIn: parent
                        id: enternainmentlabell
                        text: i18n.tr("Entertainment")
                        fontSize: "x-large"
                        color: "#ffffff"
                    }
                }
            }
        }
        onClicked: {
            categorypage.section = 'arts';
            categoryPage.head.sections.selectedIndex = 0
            categorypage.category('arts');
            pageStack.push(categoryPage);
            categoryPage.title = i18n.tr('Entertainment');
        }
    }
}
