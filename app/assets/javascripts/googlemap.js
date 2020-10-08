var map
var geocoder
var marker = [];
var infoWindow = [];
var markerData = gon.places; // コントローラーで定義したインスタンス変数を変数に代入
var place_name = [];
var place_lat = [];
var place_lng = [];
function initMap(){
  geocoder = new google.maps.Geocoder()
  if(document.getElementById('map_form')){
    map = new google.maps.Map(document.getElementById('map_form'), {
      center: { lat: 35.6585, lng: 139.7486 },
      zoom: 14
      });
  }else if(document.getElementById('map_show')){
    map = new google.maps.Map(document.getElementById('map_show'), {
      center: {
        lat: gon.place.latitude,
        lng: gon.place.longitude
      },
      zoom: 14,
    });
    marker = new google.maps.Marker({
      position: {
        lat: gon.place.latitude,
        lng: gon.place.longitude
      },
      map: map
    });
  }else{
    if(document.getElementById('map_index')){
      element= 'map_index';
    }else{
      element= 'map_likes';
    }
    map = new google.maps.Map(document.getElementById(element), {
      center: { lat: 35.6585, lng: 139.7486 }, // 東京タワーを中心
      zoom: 9,
    });

    // 繰り返し処理でマーカーと吹き出しを複数表示させる
    for (var i = 0; i < markerData.length; i++) {
      // name = markerData[i]['name']

      // 各地点の緯度経度を算出
      markerLatLng = new google.maps.LatLng({
        lat: markerData[i]['latitude'],
        lng: markerData[i]['longitude']
      });
      
      if(markerData[i]['genre'] == "food"){
        marker[i] = new google.maps.Marker({
        position: markerLatLng,
        map: map,
        icon: 'http://maps.google.com/mapfiles/kml/pal2/icon32.png'
      });
      }else if(markerData[i]['genre'] == "view"){
        marker[i] = new google.maps.Marker({
        position: markerLatLng,
        map: map,
        icon: 'http://maps.google.com/mapfiles/kml/pal3/icon29.png'
      });
      }else{
        marker[i] = new google.maps.Marker({
        position: markerLatLng,
        map: map,
        icon: 'http://maps.google.com/mapfiles/kml/pal2/icon49.png'
      });
      }
      place_name[i]= markerData[i]['name'];
      place_lat[i]= markerData[i]['latitude'];
      place_lng[i]= markerData[i]['longitude'];
      infoWindow[i] = new google.maps.InfoWindow({
        content: `<input type="button" value="追加" onclick="addPlace(place_name, place_lat, place_lng, ${i})">`
      });
      markerEvent(i);
    }
  }
}
// リストに追加する
function addPlace(name, lat, lng, number){
  var li = $('<li>', {
    text: name[number],
    "class": "list-group-item"
  });
  li.attr("data-lat", lat[number]);
  li.attr("data-lng", lng[number]);
  $('#route-list').append(li);

}
// マーカーをクリックしたら吹き出しを表示
function markerEvent(i) {
  marker[i].addListener('click', function () {
    infoWindow[i].open(map, marker[i]);
  });
}



function codeAddress(){
  var inputAddress = document.getElementById('address').value;

  geocoder.geocode( { 'address': inputAddress}, function(results, status) {
    if (status == 'OK') {
      map.setCenter(results[0].geometry.location);
      var marker = new google.maps.Marker({
          map: map,
          position: results[0].geometry.location,
          animation: google.maps.Animation.DROP
      });
    } else {
      alert('住所が見つかりませんでした');
    }
  });
}

// var rendererOptions = {
//   map: map, // 描画先の地図
//   suppressMarkers : true
// }
// var directionsDisplay = new google.maps.DirectionsRenderer(rendererOptions);
// var directionsService = new google.maps.DirectionsService();

// 複数地点のルートを検索する
function search() {
  var points = $('#route-list li');
  console.log("a")

  // 2地点以上のとき
  if (points.length >= 2){
      var origin; // 開始地点
      var destination; // 終了地点
      var waypoints = []; // 経由地点

      // origin, destination, waypointsを設定する
      for (var i = 0; i < points.length; i++) {
          points[i] = new google.maps.LatLng($(points[i]).attr("data-lat"), $(points[i]).attr("data-lng"));
          if (i == 0){
            origin = points[i];
          } else if (i == points.length-1){
            destination = points[i];
          } else {
            waypoints.push({ location: points[i], stopover: true });
          }
      }
      // リクエスト作成
      var request = {
        origin:      origin,
        destination: destination,
        waypoints: waypoints,
        travelMode:  google.maps.TravelMode.DRIVING
      };
      // ルートサービスのリクエスト
      new google.maps.DirectionsService().route(request, function(response, status) {
        if (status == google.maps.DirectionsStatus.OK) {
          new google.maps.DirectionsRenderer({
            map: map, // 描画先の地図
            // suppressMarkers : true
            polylineOptions: {
              strokeColor: '#00ffdd',
              strokeOpacity: 1,
              strokeWeight: 5
            }
          }).setDirections(response);
          //ライン描画部分
      
            //距離、時間を表示する
            var data = response.routes[0].legs;
            for (var i = 0; i < data.length; i++) {
                console.log(data[i].distance.text);
                console.log(data[i].duration.text);
                var li = $('<li>', {
                  text: data[i].distance.text,
                  "class": "display-group-item"
                });
                $('#display-list').append(li);

                var li = $('<li>', {
                  text: data[i].duration.text,
                  "class": "display-group-item"
                });
                $('#display-list').append(li);
            }
            
        }
      });
  }
}

