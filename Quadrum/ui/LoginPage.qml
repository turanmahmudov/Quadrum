import QtQuick 2.0
import Ubuntu.Components 1.1
import QtQuick.LocalStorage 2.0
import Ubuntu.Web 0.2
import "../js/scripts.js" as Scripts

Page {
    id: webPage
    title: i18n.tr("Login")

    Item {
        anchors {
            margins: units.gu(2)
            fill: parent
        }

        WebView {
            id: webView

            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height

            // zoomTo:
            property string client_id: "N2PTS3LRPQXFXJRLVPQ45AWORSELMYHVP2W1CKMD3A0M1KRP"
            property string client_secret: "D1YM2VTUGRMTWKUBVWGNP0ACM05OGWRIFIXYBUYQM5O0QVHF"

            // the redirect_uri can be any site
            property string redirect_uri: "https://api.github.com/zen"
            property string access_token_url: "https://foursquare.com/oauth2/access_token?client_id="+client_id+"&client_secret="+client_secret+"&grant_type=authorization_code&redirect_uri="+encodeURIComponent(redirect_uri)

            url: "https://foursquare.com/oauth2/authenticate?client_id="+client_id+"&response_type=code&redirect_uri="+encodeURIComponent(redirect_uri)

            onUrlChanged: {
                if (url.toString().substring(0, 32) === redirect_uri + "?code=") {
                    var code = url.toString().substring(32);
                    var xhr = new XMLHttpRequest;
                    var requesting = access_token_url + "&code=" + code;
                    xhr.open("POST", requesting);
                    xhr.onreadystatechange = function() {
                        if (xhr.readyState === XMLHttpRequest.DONE) {
                            var res = JSON.parse(xhr.responseText)
                            var token = res['access_token']
                            console.log("Oauth token is now : " + token)

                            Scripts.setKey('access_token', token);
                            pageStack.clear();
                            pageStack.push(tabs);
                        }
                    }
                    xhr.send();
                }
            }
            onLoadingChanged: {
                if (webView.lastLoadFailed) {
                error(i18n.tr("Connection Error"), i18n.tr("Unable to authenticate to Foursquare. Check your connection and firewall settings."), pageStack.pop)
                }
            }
        }

        UbuntuShape {
            anchors.centerIn: parent
            width: column.width + units.gu(4)
            height: column.height + units.gu(4)
            color: Qt.rgba(0.2,0.2,0.2,0.8)
            opacity: webView.loading ? 1 : 0

            Behavior on opacity {
                UbuntuNumberAnimation {
                    duration: UbuntuAnimation.SlowDuration
                }
            }
            Column {
                id: column
                anchors.centerIn: parent
                spacing: units.gu(1)

                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    fontSize: "large"
                    text: webView.loading ? i18n.tr("Loading web page...")
                    : i18n.tr("Success!")
                }

                ProgressBar {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: units.gu(30)
                    maximumValue: 100
                    minimumValue: 0
                    value: webView.loadProgress
                }
            }
        }
    }
}

