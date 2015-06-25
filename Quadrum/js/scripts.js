// DB
function _getDB() {
    return LocalStorage.openDatabaseSync("quadrum", "1.0", "Quadrum - Unofficial Native Foursquare Client", 2048)
}

function initializeUser() {
    var user = _getDB();
    user.transaction(
        function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS user(key TEXT UNIQUE, value TEXT)');
            var table  = tx.executeSql("SELECT * FROM user");
            // Seed the table with default values
            if (table.rows.length == 0) {
                tx.executeSql('INSERT INTO user VALUES(?, ?)', ["access_token", "0"]);
            };
        });
}
// This function is used to write a key into the database
function setKey(key, value) {
    var db = _getDB();
    db.transaction(function(tx) {
        var rs = tx.executeSql('INSERT OR REPLACE INTO user VALUES (?,?);', [key,""+value]);
        if (rs.rowsAffected == 0) {
            throw "Error updating key";
        } else {

        }
    });
}
// This function is used to retrieve a key from the database
function getKey(key) {
    var db = _getDB();
    var returnValue = undefined;

    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT value FROM user WHERE key=?;', [key]);
        if (rs.rows.length > 0)
          returnValue = rs.rows.item(0).value;
    })

    return returnValue;
}
// This function is used to delete a key from the database
function deleteKey(key) {
    var db = _getDB();

    db.transaction(function(tx) {
        var rs = tx.executeSql('DELETE FROM user WHERE key=?;', [key]);
    })
}

// What's good here
function nearby_places(lat, lng, token) {
    whatsgoodhere.finished = false;
    var url = 'https://api.foursquare.com/v2/venues/search?ll='+lat+','+lng+'&oauth_token='+token+'&v=20140926&limit=10';

    var xhr = new XMLHttpRequest;
    xhr.open("GET", url);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {

            nearbyPlacesModel.clear();

            var res = JSON.parse(xhr.responseText);
            var response = res['response'];
            var venues = response['venues'];

            var len = objLength(venues);
            var i;
            for (i = 0; i < len; i++) {
                var id = venues[i]['id'];
                var name = '<b>' + venues[i]['name'] + '</b>';
                var distance = venues[i]['location']['distance'];
                if (distance < 150) {
                    distance = '< 150 m'
                } else {
                    distance = (distance / 1000).toFixed(1) + ' km';
                }

                var category = '';
                for (var j=0; j < objLength(venues[i]['categories']); j++) {
                    if (venues[i]['categories'][j]['primary']) {
                        category = venues[i]['categories'][j];
                    }
                }
                var category_image = category['icon']['prefix'] + 'bg_64' + category['icon']['suffix'];

                var address = venues[i]['location']['address'];
                var crossStreet = venues[i]['location']['crossStreet'];
                var faddress = '';
                if (address) {
                    if (crossStreet) {
                        faddress = ' - ' + address + ' (' + crossStreet + ')';
                    } else {
                        faddress = ' - ' + address;
                    }
                } else {
                    if (crossStreet) {
                        faddress = ' - ' + '(' + crossStreet + ')';
                    }
                }

                var distandadd = distance + '' + faddress;

                nearbyPlacesModel.append({"name":name, "distance":distance, "id":id, "category_image":category_image, "address":faddress, "distandadd":distandadd});
            }
            whatsgoodhere.finished = true;
        }
    }

    xhr.send();
}

// Search what's good here
function search_nearby_places(lat, lng, token, q) {
    whatsgoodhere.finished = false;
    var url = 'https://api.foursquare.com/v2/venues/search?ll='+lat+','+lng+'&oauth_token='+token+'&query='+q+'&v=20140926&limit=30';

    var xhr = new XMLHttpRequest;
    xhr.open("GET", url);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {

            nearbyPlacesModel.clear();

            var res = JSON.parse(xhr.responseText);
            var response = res['response'];
            var venues = response['venues'];

            var len = objLength(venues);
            var i;
            for (i = 0; i < len; i++) {
                var id = venues[i]['id'];
                var name = '<b>' + venues[i]['name'] + '</b>';
                var distance = venues[i]['location']['distance'];
                if (distance < 150) {
                    distance = '< 150 m'
                } else {
                    distance = (distance / 1000).toFixed(1) + ' km';
                }

                var category = '';
                for (var j=0; j < objLength(venues[i]['categories']); j++) {
                    if (venues[i]['categories'][j]['primary']) {
                        category = venues[i]['categories'][j];
                    }
                }
                var category_image = category['icon']['prefix'] + 'bg_64' + category['icon']['suffix'];

                var address = venues[i]['location']['address'];
                var crossStreet = venues[i]['location']['crossStreet'];
                var faddress = '';
                if (address) {
                    if (crossStreet) {
                        faddress = ' - ' + address + ' (' + crossStreet + ')';
                    } else {
                        faddress = ' - ' + address;
                    }
                } else {
                    if (crossStreet) {
                        faddress = ' - ' + '(' + crossStreet + ')';
                    }
                }

                var distandadd = distance + '' + faddress;

                nearbyPlacesModel.append({"name":name, "distance":distance, "id":id, "category_image":category_image, "address":faddress, "distandadd":distandadd});
            }

            whatsgoodhere.finished = true;
        }
    }

    xhr.send();
}

// Activities
function activities(token) {
    activitypage.finished = false;
    var url = 'https://api.foursquare.com/v2/checkins/recent?oauth_token='+token+'&limit=50&v=20140926';

    var xhr = new XMLHttpRequest;
    xhr.open("GET", url);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {

            activitiesModel.clear();

            var res = JSON.parse(xhr.responseText);
            var response = res['response'];
            var recent = response['recent'];

            var len = objLength(recent);
            var i;
            for (i = 0; i < len; i++) {
                var id = recent[i]['id'];
                if (recent[i]['shout']) {
                    var shout = recent[i]['shout'];
                } else {
                    var shout = '';
                }

                var placename = recent[i]['venue']['name'] ? recent[i]['venue']['name'] : '';

                var user = recent[i]['user'];
                var user_image = user['photo']['prefix'] + '100x100' + user['photo']['suffix'];
                var firstname = user['firstName'];
                var lastname = user['lastName'];
                var username = '';
                if (firstname) {
                    if (lastname) {
                        username = firstname + ' ' + lastname;
                    } else {
                        username = firstname;
                    }
                } else {
                    if (lastname) {
                        username = lastname;
                    }
                }

                var city = recent[i]['venue']['location']['city'];
                var country = recent[i]['venue']['location']['country'];
                var faddress = '';
                if (city) {
                    if (country) {
                        faddress = city + ', ' + country;
                    } else {
                        faddress = city;
                    }
                } else {
                    if (country) {
                        faddress = country;
                    }
                }

                var cphot = '';
                var cphotos = recent[i]['photos']['items'];
                if (objLength(cphotos) > 0) {
                    for (var z=0; z<objLength(cphotos); z++) {
                        var cphoto = cphotos[0]['prefix'] + '600x600' + cphotos[0]['suffix'];
                    }
                    cphot = cphoto;
                } else {
                    cphot = '';
                }

                var d = new Date(recent[i]['createdAt']*1000);
                //var date = d.toLocaleDateString ();
                var date = time_ago(d);

                var likes = recent[i]['likes']['count'];

                var comments = recent[i]['comments']['count'];

                var like = recent[i]['like'];

                activitiesModel.append({"id":id, "user_image":user_image, "username":username, "placeadd":faddress, "placename":placename, "usershout":shout, "checkinimg":cphot, "date":date, "likes":likes, "comments":comments, "like":like, "index":i, "relationship":user['relationship']});
            }

            activitypage.finished = true;
        }
    }
    xhr.send();
}

// Like & Unlike checkin
function like_checkin(checkin_id, set) {
    var token = getKey('access_token');
    var url = 'https://api.foursquare.com/v2/checkins/' + checkin_id + '/like/?set=' + set + '&oauth_token='+token+'&v=20140926&m=swarm';

    var xhr = new XMLHttpRequest;
    xhr.open("POST", url);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            //console.log(JSON.stringify(xhr.responseText));
            var res = JSON.parse(xhr.responseText);
            var response = res['response'];
        }
    }

    var data = {
        'CHECKIN_ID' : checkin_id,
        'set' : set,
        'oauth_token' : token
    }

    xhr.send(JSON.stringify(data));
}

// Add comment to checkin
function comment_checkin(checkin_id, text) {
    var token = getKey('access_token');
    var url = 'https://api.foursquare.com/v2/checkins/' + checkin_id + '/addcomment/?text=' + text + '&oauth_token='+token+'&v=20140926&m=swarm';

    var xhr = new XMLHttpRequest;
    xhr.open("POST", url);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            console.log(JSON.stringify(xhr.responseText));
            var res = JSON.parse(xhr.responseText);

            if (res['meta']['code'] == '200') {
                var response = res['response']['comment'];

                var user = response['user'];
                var user_image = user['photo']['prefix'] + '100x100' + user['photo']['suffix'];
                var firstname = user['firstName'];
                var lastname = user['lastName'];
                var username = '';
                if (firstname) {
                    if (lastname) {
                        username = firstname + ' ' + lastname;
                    } else {
                        username = firstname;
                    }
                } else {
                    if (lastname) {
                        username = lastname;
                    }
                }
                username = '<b>' + username + '</b>';

                var text = response['text'];

                var relationship = 'self';

                var cd = new Date(response['createdAt']*1000);
                var cdate = time_ago(cd);

                checkinCommentsModel.append({"cid":response['id'], "username":username, "userphoto":user_image, "ctext":text, "time":cdate, "relationship":relationship});

                commentfield.text = '';
            } else {
                console.log("ERROR!");
            }

        }
    }

    var data = {
        'CHECKIN_ID' : checkin_id,
        'text' : text,
        'oauth_token' : token
    }

    xhr.send(JSON.stringify(data));
}

// Leave note
function leavenote(venue_id, text) {
    var token = getKey('access_token');
    var url = 'https://api.foursquare.com/v2/tips/add/?venueId='+venue_id+'&text=' + text + '&oauth_token='+token+'&v=20140926&m=foursquare';

    var xhr = new XMLHttpRequest;
    xhr.open("POST", url);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            //console.log(JSON.stringify(xhr.responseText));
            var res = JSON.parse(xhr.responseText);

            if (res['meta']['code'] == '200') {
                var response = res['response']['tip'];

                pageStack.pop();
            } else {
                console.log("ERROR!");
            }

        }
    }

    xhr.send();
}

// Delete checkin comment
function delete_checkin_comment(checkin_id, comment_id) {
    var token = getKey('access_token');
    var url = 'https://api.foursquare.com/v2/checkins/' + checkin_id + '/deletecomment/?commentId=' + comment_id + '&oauth_token='+token+'&v=20140926&m=swarm';

    var xhr = new XMLHttpRequest;
    xhr.open("POST", url);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            //console.log(JSON.stringify(xhr.responseText));
            var res = JSON.parse(xhr.responseText);

            if (res['meta']['code'] == '200') {
                // Checkin comments
                checkinCommentsModel.clear()

                var checkin = res['response']['checkin'];

                var cresponse = checkin['comments'];
                var comments = cresponse['items'];

                if (objLength(comments) > 0) {
                    for (var m=0; m<objLength(comments); m++) {
                        var couser = comments[m]['user'];
                        var couser_image = couser['photo']['prefix'] + '100x100' + couser['photo']['suffix'];
                        var cofirstname = couser['firstName'];
                        var colastname = couser['lastName'];
                        var cousername = '';
                        if (cofirstname) {
                            if (colastname) {
                                cousername = cofirstname + ' ' + colastname;
                            } else {
                                cousername = cofirstname;
                            }
                        } else {
                            if (colastname) {
                                cousername = colastname;
                            }
                        }
                        cousername = '<b>' + cousername + '</b>';

                        var relationship = couser['relationship'];

                        var text = comments[m]['text'];

                        var cd = new Date(comments[m]['createdAt']*1000);
                        var cdate = time_ago(cd);

                        checkinCommentsModel.append({"cid":comments[m]['id'], "username":cousername, "userphoto":couser_image, "ctext":text, "time":cdate, "relationship":relationship});
                    }
                }
            } else {
                console.log("ERROR!");
            }

        }
    }

    var data = {
        'CHECKIN_ID' : checkin_id,
        'commentId' : comment_id,
        'oauth_token' : token
    }

    xhr.send(JSON.stringify(data));
}

// Checkin details
function checkin_details(checkin_id, token) {
    flick.contentY = 0;
    checkedinitem.visible = false;
    id = checkin_id;

    checkinphotosModel.clear();
    scoresModel.clear();
    checkinCommentsModel.clear();

    var url = 'https://api.foursquare.com/v2/checkins/'+checkin_id+'?oauth_token='+token+'&v=20140926&m=swarm';

    var xhr = new XMLHttpRequest;
    xhr.open("GET", url);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {

            var res = JSON.parse(xhr.responseText);
            var response = res['response'];
            var checkin = response['checkin'];

            var id = checkin['id'];
            var shout = checkin['shout'];
            if (shout) { shout = shout; } else { shout = ''; }

            var venue = checkin['venue'];
            var venue_id = venue['id'];
            var venue_name = venue['name'];

            var user = checkin['user'];
            var user_image = user['photo']['prefix'] + '100x100' + user['photo']['suffix'];
            var firstname = user['firstName'];
            var lastname = user['lastName'];
            var username = '';
            if (firstname) {
                if (lastname) {
                    username = firstname + ' ' + lastname;
                } else {
                    username = firstname;
                }
            } else {
                if (lastname) {
                    username = lastname;
                }
            }

            var city = venue['location']['city'];
            var country = venue['location']['country'];
            var faddress = '';
            if (city) {
                if (country) {
                    faddress = city + ', ' + country;
                } else {
                    faddress = city;
                }
            } else {
                if (country) {
                    faddress = country;
                }
            }

            var photos = checkin['photos']['items'];
            if (objLength(photos) > 0) {
                for (var i=0; i<objLength(photos); i++) {
                    var photo = photos[0]['prefix'] + '600x600' + photos[0]['suffix'];

                    if (i != 0) {
                        var cfirstname = photos[i]['user']['firstName'];
                        var clastname = photos[i]['user']['lastName'];
                        var cusername = '';
                        if (cfirstname) {
                            if (clastname) {
                                cusername = cfirstname + ' ' + clastname;
                            } else {
                                cusername = cfirstname;
                            }
                        } else {
                            if (clastname) {
                                cusername = clastname;
                            }
                        }
                        cusername = '<b>' + cusername + '</b>';

                        var cd = new Date(photos[i]['createdAt']*1000);
                        var cdate = time_ago(cd);
                        checkinphotosModel.append({"checkinphoto":photos[i]['prefix'] + '600x600' + photos[i]['suffix'], "userphoto":photos[i]['user']['photo']['prefix'] + '100x100' + photos[i]['user']['photo']['suffix'], "username":cusername, "time":cdate})
                    }
                }
                checkin_photo.source = photo;
            } else {
                checkin_photo.source = '';
            }

            var location = {
                latitude: venue['location']['lat'],
                longitude: venue['location']['lng']
            }
            map.center.latitude = venue['location']['lat'];
            map.center.longitude = venue['location']['lng'];

            // Scores
            var score = checkin['score'];
            var scores = score['scores'];
            if (objLength(scores) > 0) {
                for (var k=0; k<objLength(scores); k++) {
                    scoresModel.append({"index":k, "desc":scores[k]['message'], "icons":scores[k]['icon']});
                }
            }

            // Likes
            var likes = checkin['likes']['count'] != "0" ? checkin['likes']['summary'] : '';
            likessummary.text = likes;

            // Checkin comments
            var cresponse = checkin['comments'];
            var comments = cresponse['items'];

            if (objLength(comments) > 0) {
                for (var m=0; m<objLength(comments); m++) {
                    var couser = comments[m]['user'];
                    var couser_image = couser['photo']['prefix'] + '100x100' + couser['photo']['suffix'];
                    var cofirstname = couser['firstName'];
                    var colastname = couser['lastName'];
                    var cousername = '';
                    if (cofirstname) {
                        if (colastname) {
                            cousername = cofirstname + ' ' + colastname;
                        } else {
                            cousername = cofirstname;
                        }
                    } else {
                        if (colastname) {
                            cousername = colastname;
                        }
                    }
                    cousername = cousername;

                    var relationship = couser['relationship'];

                    var text = comments[m]['text'];

                    var cd = new Date(comments[m]['createdAt']*1000);
                    var cdate = time_ago(cd);

                    checkinCommentsModel.append({"cid":comments[m]['id'], "username":cousername, "userid":couser['id'], "userphoto":couser_image, "ctext":text, "time":cdate, "relationship":relationship});
                }
            }

            checkinDetails.title = username;

            placetitle.text = venue_name;
            place_id = venue_id;
            userimage.source = user_image;
            placeaddress.text = faddress;
            user_shout.text = shout;

            liked = checkin['like'];

            user_id = user['id'];
            user_name = username;

            checkedinitem.visible = true;
        }
    }
    xhr.send();
}

// Checkin likes
function checkin_likes(checkin_id, token) {
    checkinlikes.finished = false;
    var url = 'https://api.foursquare.com/v2/checkins/'+checkin_id+'/likes?oauth_token='+token+'&v=20140926&m=swarm';

    var xhr = new XMLHttpRequest;
    xhr.open("GET", url);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {

            likesModel.clear();

            var res = JSON.parse(xhr.responseText);
            var response = res['response'];
            var likes = response['likes'];

            var items = likes['items'];
            if (objLength(items) > 0) {
                for (var i=0; i<objLength(items); i++) {
                    var firstname = items[i]['firstName'];
                    var lastname = items[i]['lastName'];
                    var username = '';
                    if (firstname) {
                        if (lastname) {
                            username = firstname + ' ' + lastname;
                        } else {
                            username = firstname;
                        }
                    } else {
                        if (lastname) {
                            username = lastname;
                        }
                    }

                    likesModel.append({"id":items[i]['id'], "username":username});
                }

                checkinlikes.finished = true;
            }
        }
    }
    xhr.send();
}

function venue_details(venue_id, token) {
    venuePage.title = '';
    //panel.close();
    flick.contentY = 0;
    venueitem.visible = false;
    id = venue_id;

    var url = 'https://api.foursquare.com/v2/venues/'+venue_id+'?oauth_token='+token+'&v=20140926';

    var xhr = new XMLHttpRequest;
    xhr.open("GET", url);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            specModel.clear();
            friendsTipsModel.clear();
            othersTipsModel.clear();
            selfTipsModel.clear();

            specFromVenue.visible = true;
            specFromVenueValue.text = '';
            friendTip.visible = false;
            friendTipValue.text = '';
            otherTip.visible = false;
            otherTipValue.text = '';
            selfTip.visible = false;
            selfTipValue.text = '';

            var res = JSON.parse(xhr.responseText);
            venuepage.venueArray = res;
            var response = res['response'];
            var venue = response['venue'];

            var id = venue['id'];
            var name = venue['name'];
            venuePage.title = name;
            venuename.text = name;

            var rating = venue['rating'] ? venue['rating'] : '';
            var ratingColor = venue['ratingColor'] ? venue['ratingColor'] : '';
            var ratingSignals = venue['ratingSignals'] ? venue['ratingSignals'] : '';
            venueratingtext.text = rating;
            venuepage.ratingColor = "#" + ratingColor;
            venuerating.color = "#" + ratingColor;

            if (venue['photos']['count'] != 0) {
                var photos = venue['photos']['groups'][0]['items'];
                var photo = photos[0]['prefix'] + '304x304' + photos[0]['suffix'];
                venue_image.source = photo;
            } else {
                venue_image.source = '';
            }

            var category = '';
            for (var i=0; i < objLength(venue['categories']); i++) {
                if (venue['categories'][i]['primary']) {
                    category = venue['categories'][i];
                }
            }
            venuecategory.text = category.name;

            var address = venue['location']['address'];
            var crossStreet = venue['location']['crossStreet'];
            var faddress = '';
            if (address) {
                if (crossStreet) {
                    faddress = '<font color="#2d5be3">' + address + '</font> (' + crossStreet + ')';
                } else {
                    faddress = '<font color="#2d5be3">' + address + '</font>';
                }
            } else {
                if (crossStreet) {
                    faddress = '(' + crossStreet + ')';
                }
            }
            venueaddress.text = faddress;

            if (venue['contact']['formattedPhone']) {
                var phone = venue['contact']['formattedPhone'];
                venuephone.text = phone;
            }

            if (venue['friendVisits']) {
                var friendVisits = venue['friendVisits']['summary'];
                if (friendVisit) {
                    friendVisit.text = friendVisits;
                }
            }

            var location = {
                latitude: venue['location']['lat'],
                longitude: venue['location']['lng']
            }
            map.center.latitude = venue['location']['lat'];
            map.center.longitude = venue['location']['lng'];

            // Specials
            var specials = venue['specials']['items'];
            if (objLength(specials) == 0) {
                specFromVenue.visible = false;
                specFromVenueValue.text = '';
            } else {
                specFromVenue.visible = true;
            }
            for (var i=0; i < objLength(specials); i++) {
                var photo = specials[i]['photo'];
                var spec_image = photo['prefix'] + '600x600' + photo['suffix'];

                var spec_name = specials[i]['page']['firstName'];
                specFromVenueValue.text = "From " + name;

                var spec_likes = specials[i]['likes']['count'];

                specModel.append({"message":specials[i]['message'], "spec_image":spec_image, "title":spec_name, "likes":spec_likes + " Likes"});
            }

            // Tips
            var tips = venue['tips'];
            for (var i=0; i < objLength(tips['groups']); i++) {
                if (tips['groups'][i]['type'] == "friends") {
                    var friendTipName = tips['groups'][i]['name'];
                    var friendsTips = tips['groups'][i]['items'];
                    if (objLength(friendsTips) == 0) {
                        friendTip.visible = false;
                        friendTipValue.text = '';
                    } else {
                        friendTip.visible = true;
                        friendTipValue.text = friendTipName;
                    }
                    for (var k=0; k < objLength(friendsTips); k++) {

                        var photo = friendsTips[k]['photo'];
                        var tip_image = photo ? photo['prefix'] + '600x600' + photo['suffix'] : '';

                        var tip_likes = friendsTips[k]['likes']['count'];
                        var user = friendsTips[k]['user'];
                        var user_photo = user['photo']['prefix'] + "80x80" + user['photo']['suffix'];
                        var firstname = user['firstName'];
                        var lastname = user['lastName'];
                        var username = '';
                        if (firstname) {
                            if (lastname) {
                                username = firstname + ' ' + lastname;
                            } else {
                                username = firstname;
                            }
                        } else {
                            if (lastname) {
                                username = lastname;
                            }
                        }

                        var d = new Date(friendsTips[k]['createdAt']*1000);
                        var date = d.toLocaleDateString ();

                        friendsTipsModel.append({"message":friendsTips[k]['text'], "likes":tip_likes + " Likes", "username":username, "userid":user['id'], "userimage":user_photo, "date":date, "tip_img":tip_image});
                    }
                } else if (tips['groups'][i]['type'] == "self") {
                    var selfTipName = tips['groups'][i]['name'];
                    var selfTips = tips['groups'][i]['items'];
                    if (objLength(selfTips) == 0) {
                        selfTip.visible = false;
                        selfTipValue.text = '';
                    } else {
                        selfTip.visible = true;
                        selfTipValue.text = selfTipName;
                    }
                    for (var k=0; k < objLength(selfTips); k++) {

                        var photo = selfTips[k]['photo'];
                        var tip_image = photo ? photo['prefix'] + '600x600' + photo['suffix'] : '';

                        var tip_likes = selfTips[k]['likes']['count'];
                        var user = selfTips[k]['user'];
                        var user_photo = user['photo']['prefix'] + "80x80" + user['photo']['suffix'];
                        var firstname = user['firstName'];
                        var lastname = user['lastName'];
                        var username = '';
                        if (firstname) {
                            if (lastname) {
                                username = firstname + ' ' + lastname;
                            } else {
                                username = firstname;
                            }
                        } else {
                            if (lastname) {
                                username = lastname;
                            }
                        }

                        var d = new Date(selfTips[k]['createdAt']*1000);
                        var date = d.toLocaleDateString ();

                        selfTipsModel.append({"message":selfTips[k]['text'], "likes":tip_likes + " Likes", "username":username, "userid":user['id'], "userimage":user_photo, "date":date, "tip_img":tip_image});
                    }
                } else if (tips['groups'][i]['type'] == "others") {
                    var otherTipName = tips['groups'][i]['name'];
                    var othersTips = tips['groups'][i]['items'];
                    if (objLength(othersTips) == 0) {
                        otherTip.visible = false;
                        otherTipValue.text = '';
                    } else {
                        otherTip.visible = true;
                        otherTipValue.text = otherTipName;
                    }
                    for (var k=0; k < objLength(othersTips); k++) {

                        var photo = othersTips[k]['photo'];
                        var tip_image = photo ? photo['prefix'] + '600x600' + photo['suffix'] : '';

                        var tip_likes = othersTips[k]['likes']['count'];
                        var user = othersTips[k]['user'];
                        var user_photo = user['photo']['prefix'] + "80x80" + user['photo']['suffix'];
                        var firstname = user['firstName'];
                        var lastname = user['lastName'];
                        var username = '';
                        if (firstname) {
                            if (lastname) {
                                username = firstname + ' ' + lastname;
                            } else {
                                username = firstname;
                            }
                        } else {
                            if (lastname) {
                                username = lastname;
                            }
                        }

                        var d = new Date(othersTips[k]['createdAt']*1000);
                        var date = d.toLocaleDateString ();

                        othersTipsModel.append({"message":othersTips[k]['text'], "likes":tip_likes + " Likes", "username":username, "userid":user['id'], "userimage":user_photo, "date":date, "tip_img":tip_image});

                    }
                }
            }

            venueitem.visible = true;
            //panel.open();
        }
    }
    xhr.send();
}

function venue_more_details(venue_id, token, venueArray) {
    venueDetailsPage.title = '';
    venueitem.visible = false;
    id = venue_id;

    var res = venueArray;
    var response = res['response'];
    var venue = response['venue'];

    var id = venue['id'];
    var name = venue['name'];
    venueDetailsPage.title = i18n.tr('More Info');
    venuename.text = '<b>'+name+'</b>';

    var address = venue['location']['address'];
    var crossStreet = venue['location']['crossStreet'];
    var faddress = '';
    if (address) {
        if (crossStreet) {
            faddress = address + ' (' + crossStreet + ')';
        } else {
            faddress = address;
        }
    } else {
        if (crossStreet) {
            faddress = '(' + crossStreet + ')';
        }
    }
    venueaddress.text = faddress;

    var city = venue['location']['city'] ? venue['location']['city'] : false;
    var state = venue['location']['state'] ? venue['location']['state'] : false;
    var citystate = '';
    if (city) {
        if (state) {
            citystate = city + ', ' + state;
        } else {
            citystate = city
        }
    } else {
        if (state) {
            citystate = state;
        }
    }
    venuecity.text = citystate;

    var days = venue['hours'] ? venue['hours']['timeframes'][0]['days'] : '';
    var time = venue['hours'] ? venue['hours']['timeframes'][0]['open'][0]['renderedTime'] : '';
    venuedays.text = days;
    venuetime.text = time;

    var attributes = venue['attributes'];
    var servename = '';
    var servevalue = '';
    var diningname = '';
    var diningvalue = '';
    var reservationsname = '';
    var reservationsvalue = '';
    var paymentsname = '';
    var paymentsvalue = '';
    var outdoorSeatingname = '';
    var outdoorSeatingvalue = '';
    var musicname = '';
    var musicvalue = '';
    var wifiname = '';
    var wifivalue = '';
    var drinkname = '';
    var drinkvalue = '';
    var restroomname = '';
    var restroomvalue = '';
    for (var i=0; i < objLength(attributes['groups']); i++) {
        if (venue['attributes']['groups'][i]['type'] == "serves") {
            var servename = venue['attributes']['groups'][i]['name'];
            var serveitems = venue['attributes']['groups'][i]['items'];
            for (var j=0; j < objLength(serveitems); j++) {
                servevalue = servevalue + serveitems[j]['displayValue'];
                if (j != objLength(serveitems)-1) {
                    servevalue = servevalue + ', ';
                }
             }
        }
        if (venue['attributes']['groups'][i]['type'] == "diningOptions") {
            var diningname = venue['attributes']['groups'][i]['name'];
            var diningitems = venue['attributes']['groups'][i]['items'];
            for (var k=0; k < objLength(diningitems); k++) {
                diningvalue = diningvalue + diningitems[k]['displayValue'];
                if (k != objLength(diningitems)-1) {
                    diningvalue = diningvalue + ', ';
                }
             }
        }
        if (venue['attributes']['groups'][i]['type'] == "reservations") {
            var reservationsname = venue['attributes']['groups'][i]['name'];
            var reservationsitems = venue['attributes']['groups'][i]['items'];
            for (var l=0; l < objLength(reservationsitems); l++) {
                reservationsvalue = reservationsvalue + reservationsitems[l]['displayValue'];
                if (l != objLength(reservationsitems)-1) {
                    reservationsvalue = reservationsvalue + ', ';
                }
             }
        }
        if (venue['attributes']['groups'][i]['type'] == "payments") {
            var paymentsname = venue['attributes']['groups'][i]['name'];
            var paymentsitems = venue['attributes']['groups'][i]['items'];
            for (var m=0; m < objLength(paymentsitems); m++) {
                paymentsvalue = paymentsvalue + paymentsitems[m]['displayValue'];
                if (m != objLength(paymentsitems)-1) {
                    paymentsvalue = paymentsvalue + ', ';
                }
             }
        }
        if (venue['attributes']['groups'][i]['type'] == "outdoorSeating") {
            var outdoorSeatingname = venue['attributes']['groups'][i]['name'];
            var outdoorSeatingitems = venue['attributes']['groups'][i]['items'];
            for (var n=0; n < objLength(outdoorSeatingitems); n++) {
                outdoorSeatingvalue = outdoorSeatingvalue + outdoorSeatingitems[n]['displayValue'];
                if (n != objLength(outdoorSeatingitems)-1) {
                    outdoorSeatingvalue = outdoorSeatingvalue + ', ';
                }
             }
        }
        if (venue['attributes']['groups'][i]['type'] == "music") {
            var musicname = venue['attributes']['groups'][i]['name'];
            var musicitems = venue['attributes']['groups'][i]['items'];
            for (var o=0; o < objLength(musicitems); o++) {
                musicvalue = musicvalue + musicitems[o]['displayValue'];
                if (o != objLength(musicitems)-1) {
                    musicvalue = musicvalue + ', ';
                }
             }
        }
        if (venue['attributes']['groups'][i]['type'] == "wifi") {
            var wifiname = venue['attributes']['groups'][i]['name'];
            var wifiitems = venue['attributes']['groups'][i]['items'];
            for (var p=0; p < objLength(wifiitems); p++) {
                wifivalue = wifivalue + wifiitems[p]['displayValue'];
                if (p != objLength(wifiitems)-1) {
                    wifivalue = wifivalue + ', ';
                }
             }
        }
        if (venue['attributes']['groups'][i]['type'] == "drinks") {
            var drinkname = venue['attributes']['groups'][i]['name'];
            var drinkitems = venue['attributes']['groups'][i]['items'];
            for (var q=0; q < objLength(drinkitems); q++) {
                drinkvalue = drinkvalue + drinkitems[q]['displayValue'];
                if (q != objLength(drinkitems)-1) {
                    drinkvalue = drinkvalue + ', ';
                }
             }
        }
        if (venue['attributes']['groups'][i]['type'] == "restroom") {
            var restroomname = venue['attributes']['groups'][i]['name'];
            var restroomitems = venue['attributes']['groups'][i]['items'];
            for (var r=0; r < objLength(restroomitems); r++) {
                restroomvalue = restroomvalue + restroomitems[r]['displayValue'];
                if (r != objLength(restroomitems)-1) {
                    restroomvalue = restroomvalue + ', ';
                }
             }
        }
    }
    venueserve.text = servename;
    venueservevalue.text = servevalue;

    venuediningOptions.text = diningname;
    venuediningOptionsvalue.text = diningvalue;

    venuereservations.text = reservationsname;
    venuereservationsvalue.text = reservationsvalue;

    venuepayments.text = paymentsname;
    venuepaymentsvalue.text = paymentsvalue;

    venueoutdoorSeating.text = outdoorSeatingname;
    venueoutdoorSeatingvalue.text = outdoorSeatingvalue;

    venuemusic.text = musicname;
    venuemusicvalue.text = musicvalue;

    venuewifi.text = wifiname;
    venuewifivalue.text = wifivalue;

    venuedrinks.text = drinkname;
    venuedrinksvalue.text = drinkvalue;

    venuerestroom.text = restroomname;
    venuerestroomvalue.text = restroomvalue;

    var twitter = venue['contact']['twitter'] ? venue['contact']['twitter'] : '';
    venuetwittername.text = venue['contact']['twitter'] ? 'Twitter' : '';
    venuetwittervalue.text = twitter;

    var web = venue['url'] ? venue['url'] : '';
    venueweb.text = venue['url'] ? 'Website' : '';
    venuewebvalue.text = web.replace(/http:\/\/w/gi,"w");;

    var totalvisitors = venue['stats']['usersCount'] ? venue['stats']['usersCount'] : '';
    venuetotalvisitors.text = venue['stats']['usersCount'] ? 'Total visitors' : '';
    venuetotalvisitorsvalue.text = totalvisitors;

    venueitem.visible = true;
}

// Add checkin
function add_checkin(venue_id, token, shout, photo, facebook, twitter) {
    var url = 'https://api.foursquare.com/v2/checkins/add/?venueId='+venue_id+'&oauth_token='+token+'&v=20140926&m=swarm&shout='+shout;

    var xhr = new XMLHttpRequest;
    xhr.open("POST", url);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            //console.log(JSON.stringify(xhr.responseText));
            var res = JSON.parse(xhr.responseText);
            var response = res['response'];
            if (objLength(response['checkin'])) {
                var checkin = response['checkin'];
                var id = checkin['id'];
            }

            checkedin(id);
            if (photo != '') {
                //add_photo(id, 'checkin', token, photo);
            }
        }
    }

    var broad = [];
    if (facebook) {
        broad.push('facebook');
    }
    if (twitter) {
        broad.push('twitter');
    }
    var broadc = broad.join(',');

    var data = {
        'venueId' : venue_id,
        'oauth_token' : token,
        'v' : '20140926',
        'm' : 'swarm',
        'shout' : shout,
        'broadcast' : broadc
    }

    xhr.send(JSON.stringify(data));
}

// User lists
function self_user_lists(venue_id) {
    var token = getKey('access_token');

    var url = 'https://api.foursquare.com/v2/users/self/lists?group=created&oauth_token='+token+'&v=20140926&limit=100';

    var xhr = new XMLHttpRequest;
    xhr.open("GET", url);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            var res = JSON.parse(xhr.responseText);

            var response = res['response']['lists'];
            var items = response['items'];

            var i = 0;
            for (i in items) {
                ulistsModel.append({"id":items[i]['id'], "name":items[i]['name'], "venue_id":venue_id});
            }
        }
    }
    xhr.send();
}

// Add venue to user list
function save_venue_to_list(list_id, venue_id) {
    var token = getKey('access_token');

    var url = 'https://api.foursquare.com/v2/lists/'+list_id+'/additem?venueId='+venue_id+'&oauth_token='+token+'&v=20140926';

    var xhr = new XMLHttpRequest;
    xhr.open("POST", url);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            var res = JSON.parse(xhr.responseText);
        }
    }

    var data = {
        'LIST_ID' : list_id,
        'venueId' : venue_id,
        'oauth_token' : token
    }

    xhr.send(JSON.stringify(data));
}

function category(lat, lng, section, token, headSection) {
    categorypage.finished = false;
    if (!headSection || headSection == '') {
        headSection = '0';
    }
    if (headSection == '0') {
        var url = 'https://api.foursquare.com/v2/venues/explore?ll='+lat+','+lng+'&oauth_token='+token+'&v=20140926&limit=30&section='+section;
    } else if (headSection == '1') {
        var url = 'https://api.foursquare.com/v2/venues/explore?ll='+lat+','+lng+'&oauth_token='+token+'&v=20140926&limit=30&section='+section+'&specials=1';
    } else if (headSection == '2') {
        var url = 'https://api.foursquare.com/v2/venues/explore?ll='+lat+','+lng+'&oauth_token='+token+'&v=20140926&limit=30&section='+section+'&openNow=1';
    }

    var xhr = new XMLHttpRequest;
    xhr.open("GET", url);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            sectionPlacesModel.clear();
            categorypage.finished = true;

            //console.log(xhr.responseText);

            var res = JSON.parse(xhr.responseText);
            var response = res['response'];
            if (objLength(response['groups'])) {
                var groups = response['groups'][0]['items'];

                var len = objLength(groups);
                var i;
                for (i = 0; i < len; i++) {
                    var id = groups[i]['venue']['id'];
                    var name = "<b>"+groups[i]['venue']['name']+"</b>"
                    var distance = groups[i]['venue']['location']['distance'];
                    if (distance < 150) {
                        distance = '< 150 m'
                    } else {
                        distance = (distance / 1000).toFixed(1) + ' km';
                    }

                    var category = '';
                    for (var j=0; j < objLength(groups[i]['venue']['categories']); j++) {
                        if (groups[i]['venue']['categories'][j]['primary']) {
                            category = groups[i]['venue']['categories'][j];
                        }
                    }
                    var category_name = category['name'];
                    var category_image = category['icon']['prefix'] + 'bg_32' + category['icon']['suffix'];

                    if (groups[i]['tips']) {
                        var tips = groups[i]['tips'];
                        var tiptext = tips[0]['text'];

                        tiptext = '"' + tiptext + '"';
                        var tipuserfirstname = (tips[0]['user']['firstName']) ? tips[0]['user']['firstName'] : '';
                        var tipuserlastname = (tips[0]['user']['lastName']) ? tips[0]['user']['lastName'] : '';
                        var tipuser = ' - ' + tipuserfirstname + ' ' + tipuserlastname;
                        var tip = tiptext + '' + tipuser;
                    } else {
                        var tiptext = '';
                        var tipuser = '';
                        var tip = '';
                    }

                    var rating = groups[i]['venue']['rating'] ? groups[i]['venue']['rating'] : '';
                    var rating_color = groups[i]['venue']['ratingColor'] ? "#"+groups[i]['venue']['ratingColor'] : '';

                    sectionPlacesModel.append({"name":name, "distance":distance, "id":id, "category_image":category_image, "category_name":category_name, "rating":rating, "ratingColor":rating_color, "tiptext":tiptext, "tipuser":tipuser, "tip":tip});
                }
            }

        }
    }
    xhr.send();

    indicat.opacity = 0;
}

function bestPlaces(lat, lng, token) {
    console.log('bashladi')
    var url = 'https://api.foursquare.com/v2/venues/explore?ll='+lat+','+lng+'&oauth_token='+token+'&v=20140926&limit=10&section=topPicks';

    var xhr = new XMLHttpRequest;
    xhr.open("GET", url);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            //console.log(xhr.responseText)

            bestPlacesModel.clear();

            var res = JSON.parse(xhr.responseText);
            var response = res['response'];
            if (objLength(response['groups'])) {
                var groups = response['groups'][0]['items'];

                var len = objLength(groups);
                var i;
                for (i = 0; i < len; i++) {
                    var id = groups[i]['venue']['id'];
                    var name = "<b>"+groups[i]['venue']['name']+"</b>"
                    var distance = groups[i]['venue']['location']['distance'];
                    if (distance < 150) {
                        distance = '< 150 m'
                    } else {
                        distance = (distance / 1000).toFixed(1) + ' km';
                    }

                    var category = '';
                    for (var j=0; j < objLength(groups[i]['venue']['categories']); j++) {
                        if (groups[i]['venue']['categories'][j]['primary']) {
                            category = groups[i]['venue']['categories'][j];
                        }
                    }
                    var category_name = category['name'];
                    var category_image = category['icon']['prefix'] + 'bg_32' + category['icon']['suffix'];

                    if (groups[i]['tips']) {
                        var tips = groups[i]['tips'];
                        var tiptext = tips[0]['text'];

                        tiptext = '"' + tiptext + '"';
                        var tipuserfirstname = (tips[0]['user']['firstName']) ? tips[0]['user']['firstName'] : '';
                        var tipuserlastname = (tips[0]['user']['lastName']) ? tips[0]['user']['lastName'] : '';
                        var tipuser = ' - ' + tipuserfirstname + ' ' + tipuserlastname;
                        var tip = tiptext + '' + tipuser;
                    } else {
                        var tiptext = '';
                        var tipuser = '';
                        var tip = '';
                    }

                    var rating = groups[i]['venue']['rating'] ? groups[i]['venue']['rating'] : '';
                    var rating_color = groups[i]['venue']['ratingColor'] ? "#"+groups[i]['venue']['ratingColor'] : '';

                    bestPlacesModel.append({"name":name, "distance":distance, "id":id, "category_image":category_image, "category_name":category_name, "rating":rating, "ratingColor":rating_color, "tiptext":tiptext, "tipuser":tipuser, "tip":tip});
                }
            }
        }
    }
    xhr.send();
}

function get_me(token) {
    mepage.finished = false;
    var userid = 'self';
    var url = 'https://api.foursquare.com/v2/users/'+userid+'?oauth_token='+token+'&v=20140926';

    var xhr = new XMLHttpRequest;
    xhr.open("GET", url);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {

            //console.log(xhr.responseText)

            mepage.finished = true;

            var res = JSON.parse(xhr.responseText);
            var response = res['response'];
            var user = response['user'];

            var id = user['id'];
            var userimage = user['photo']['prefix'] + '250x250' + user['photo']['suffix'];

            var firstname = user['firstName'];
            var lastname = user['lastName'];
            var username = '';
            if (firstname) {
                if (lastname) {
                    username = firstname + ' ' + lastname;
                } else {
                    username = firstname;
                }
            } else {
                if (lastname) {
                    username = lastname;
                }
            }

            var homeCity = user['homeCity'];
            var bio = user['bio'];

            user_image.source = userimage;
            user_name.text = '<b>'+username+'</b>';
            user_homecity.text = homeCity;
            user_bio.text = nl2br(bio);
        }
    }
    xhr.send();
}

function get_user(id, token) {
    useritem.visible = false;
    userpage.finished = false;
    var userid = id;
    var url = 'https://api.foursquare.com/v2/users/'+userid+'?oauth_token='+token+'&v=20140926';

    var xhr = new XMLHttpRequest;
    xhr.open("GET", url);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {

            //console.log(xhr.responseText)

            userpage.finished = true;

            var res = JSON.parse(xhr.responseText);
            var response = res['response'];
            var user = response['user'];

            var id = user['id'];
            var userimage = user['photo']['prefix'] + '250x250' + user['photo']['suffix'];

            var firstname = user['firstName'];
            var lastname = user['lastName'];
            var username = '';
            if (firstname) {
                if (lastname) {
                    username = firstname + ' ' + lastname;
                } else {
                    username = firstname;
                }
            } else {
                if (lastname) {
                    username = lastname;
                }
            }

            var homeCity = user['homeCity'];
            var bio = user['bio'];

            user_image.source = userimage;
            user_name.text = '<b>'+username+'</b>';
            user_homecity.text = homeCity;
            user_bio.text = nl2br(bio);

            useritem.visible = true;
        }
    }
    xhr.send();
}

function objLength(obj){
  var i=0;
  for (var x in obj){
    if(obj.hasOwnProperty(x)){
      i++;
    }
  }
  return i;
}

function nl2br (str, is_xhtml) {
  var breakTag = (is_xhtml || typeof is_xhtml === 'undefined') ? '<br ' + '/>' : '<br>'; // Adjust comment to avoid issue on phpjs.org display

  return (str + '').replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '$1' + breakTag + '$2');
}

function time_ago(time){
    switch (typeof time) {
        case 'number': break;
        case 'string': time = +new Date(time); break;
        case 'object': if (time.constructor === Date) time = time.getTime(); break;
        default: time = +new Date();
    }
    var time_formats = [
        [60, 's', 1], // 60
        [3600, 'm', 60], // 60*60, 60
        [86400, 'h', 3600], // 60*60*24, 60*60
        [604800, 'd', 86400], // 60*60*24*7, 60*60*24
        [2419200, 'w', 604800], // 60*60*24*7*4, 60*60*24*7
        [29030400, 'm', 2419200], // 60*60*24*7*4*12, 60*60*24*7*4
        [2903040000, 'y', 29030400], // 60*60*24*7*4*12*100, 60*60*24*7*4*12
        [58060800000, 'c', 2903040000] // 60*60*24*7*4*12*100*20, 60*60*24*7*4*12*100
    ];
    var seconds = (+new Date() - time) / 1000,
        token = '', list_choice = 1;

    if (seconds == 0) {
        return '1s'
    }
    if (seconds < 0) {
        seconds = Math.abs(seconds);
        token = 'from now';
        list_choice = 2;
    }
    var i = 0, format;
    while (format = time_formats[i++])
        if (seconds < format[0]) {
            if (typeof format[2] == 'string')
                return format[list_choice];
            else
                return Math.floor(seconds / format[2]) + '' + format[1] + ' ' + token;
        }
    return time;
}
