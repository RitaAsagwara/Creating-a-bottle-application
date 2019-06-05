<html>
  <head>
    <title>Leaflet map</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" type="text/css" href="/static/css/styles.css">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">  
        <link rel="stylesheet" href="https://unpkg.com/leaflet@1.1.0/dist/leaflet.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/Leaflet.awesome-markers/2.0.2/leaflet.awesome-markers.css">
                
        <script src="https://unpkg.com/leaflet@1.1.0/dist/leaflet.js"></script>
        
        <script type=text/javascript src="static/js/lib/jquery-3.2.0.min.js"></script>
        <script src="https://d3js.org/d3.v5.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/Leaflet.awesome-markers/2.0.2/leaflet.awesome-markers.min.js"></script>
        
        
        
    </head>
    <body>
        <div id="map" style="width: 100%; height: 80%"></div>
        
        <div id="data"></div>
            
        <h1 class="title"></h1>
        
        <p id="city_text">City: None</p>
        
        <p>City: None</p>
        
        <canvas id="myChart" width="50" height="30"></canvas>
        
        <script>
            var yourLocation = {{!currentLoc}}
            var publicSchool = {{!pL}} 
                    
                 
            var publicIcon = L.icon({
                iconUrl: 'https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-violet.png',
                iconSize: [25, 41],
                iconAnchor: [12, 41],
            });
            
            var charterIcon = L.icon({
                iconUrl: 'https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-red.png',
                iconSize: [25, 41],
                iconAnchor: [12, 41],
            });
            
            function iconByStations(feature){
                var icon;
                var line = feature.properties.f2;
                if (line === "public") icon = publicIcon;
                else icon = charterIcon;

              return icon;
            };
            
                        
            var map = L.map('map').setView([29.7604, -95.3698], 12);
            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
             }).addTo(map);
            
            publicSchool.forEach(function(data) {
                var point = L.geoJson(data, {
                    onEachFeature: onClickEachFeature,
                    pointToLayer: function (feature, latlng) {
                        return L.marker(latlng, {icon: iconByStations(feature)});
                    }
                }).addTo(map);
            });
            
            function onClickEachFeature(feature, layer){
              layer.addEventListener('click', function(){
                var name = feature.properties.f1;
                var rating = feature.properties.f3;  
                  
                document.getElementById("city_text").innerHTML = "City: None"; //reset to None
                document.getElementById("city_text").innerHTML = "City: " + name;	  //set city with name
              }
             )
            }
            
        </script>
        
        
    </body>
    
</html>