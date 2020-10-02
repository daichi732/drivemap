let map
let geocoder
let marker = [];
let infoWindow = [];
let markerData = gon.places; // コントローラーで定義したインスタンス変数を変数に代入

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
      let id = markerData[i]['id']

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

      
      // 各地点の吹き出しを作成、jsではカラムが配列になるイメージ
      infoWindow[i] = new google.maps.InfoWindow({
        content: `<a id: "btn-add" class: "btn btn-primary" onclick: "addPlace(markerData[i]['name'],markerData[i]['latitude'], markerData[i]['longitude'])">追加</a>`
      });

      // マーカーにクリックイベントを追加,初めはopen状態にする
      markerEvent(i);
    }
  }
}


function codeAddress(){
  let inputAddress = document.getElementById('address').value;

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

// マーカーをクリックしたら吹き出しを表示
function markerEvent(i) {
  marker[i].addListener('click', function () {
    infoWindow[i].open(map, marker[i]);
  });
}

// リストに追加する
function addPlace(name, lat, lng){
  var li = $('<li>', {
      text: name,
      "class": "list-group-item"
  });
  li.attr("data-lat", lat);
  li.attr("data-lng", lng);
  $('#route-list').append(li);
}

var rendererOptions = {
  suppressMarkers : true
}
var directionsDisplay = new google.maps.DirectionsRenderer(rendererOptions);
var directionsService = new google.maps.DirectionsService();

// 複数地点のルートを検索する
function search() {
  var points = $('#route-list li');

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
      directionsService.route(request, function(response, status) {
          if (status == google.maps.DirectionsStatus.OK) {
              // 結果を表示する
              directionsDisplay.setDirections(response);
          }
      });
  }
}
