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
        <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.1.4/Chart.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/Leaflet.awesome-markers/2.0.2/leaflet.awesome-markers.min.js"></script>
        <script src='https://npmcdn.com/@turf/turf/turf.min.js'></script>  
        <script src='static/js/turf.min.js'></script>
        
     
    </head>
    <body>
        <nav class="navbar navbar-inverse" role="navigation">
            <div class="container">
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-nav-demo" aria-expanded="false">
                        <span class="sr-only">Toggle navigation</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <a href="#" class="navbar-brand">School Finder</a>
                    </div>
                    <div class="collapse navbar-collapse" id="bs-nav-demo"> 
                        <ul class="nav navbar-nav">
                            <li><a href="#">About</a></li>
                            <li><a href="#">Contact</a></li>
                        </ul>
                </div>
            </div>
        </nav>
        
         <div class="container">
            <div class="row">
                <div class="col-lg-8 col-md-8 col-sm-8 col-xs-8">
                    <form action="/show" method="GET">
                        <select name="show" class="styled-select blue semi-square">
                            <option selected="selected" value="">Levels</option>
                            %for row in rows:
                            <option value="{{row['levels']}}">{{row["levels"]}}</option>
                            %end
                        </select>
                        <input type="submit" name="search" value="Submit">
                        <form action="/reset" method="GET">
                            <input type="submit" name="reset" value="Reset">
                        </form>
                    </form>
                </div>
            </div>
        </div>
      
        
        <div class="container">
            <div class="row">
                <div class="col-lg-8 col-md-8 red">
                    <div class="thumbnail">
                        <div id="map" style="width: 100%; height: 75%"></div>
                    </div>
                </div>
                <div class="col-lg-4 col-md-4 pink">
                    <div class="thumbnail">
                        <div class="tab">
                            <button class="tablinks" onclick="openCity(event, 'SchoolZone')">School Zone</button>
                            <button class="tablinks" onclick="openCity(event, 'schoolDetail')">School Detail</button>
                            <button class="tablinks" onclick="openCity(event, 'afterSchool')">After School</button>
                        </div>
                        <div id="SchoolZone" class="tabcontent">
                            <p id="districtname">School Count: </p>
                            <canvas id="Chart" width="300" height="300"></canvas>
                            <p id="districttype">School Type: </p>
                            <canvas id="Chartz" width="300" height="200"></canvas>
                        </div>
                        <div id="schoolDetail" class="tabcontent">
                            <p id="districtname_text">District</p>
                            <p id="school_text">Name: None</p>
                            <p id="address_text">Address: None</p>
                            <p id="type_text">Type: None</p>
                            <p id="gradeRange_text">Grade Range: None</p>
                            <p id="parentrating_text">Parent Rating: None</p>
                            <p id="Contact_text">Contact: None</p>
                            <p id="fax_text">Fax Number: None</p>
                            <canvas id="EnrChart"></canvas>
                            <br>
                            <canvas id="myChart"></canvas>
                        </div>
                        <div id="afterSchool" class="tabcontent">
                            <p id="facility">Name: None</p>
                            <p id="school">School: None</p>
                            <p id="address">Address: None</p>
                            <p id="Contact_name">Facility_contact: None</p>
                            <p id="Email">Email: None</p>
                            <p id="phone">Phone: None</p>
                            <p id="website">website: None</p>
                            
                        </div>
                    </div>
                                                        
                </div>
                        
                     
            </div>
        </div>
         
        <nav class="navbar navbar-default navbar-fixed-bottom">
            <div class="container">
                <div class="footer-block">
                    <ul class="nav navbar-nav navbar-right">
                        <li><a href="">@Rita Asagwara, 2017</a></li>
                    </ul>
                </div>
            </div>
        </nav>   
        
        <script>
            
            var yourLocation = {{!currentLoc}}
            var geojsonList = {{!eventLoc}} 
            var publicSchools = {{!publicsch}} 
            var labels = {{!label}}
            var data = {{!datas}}
            var parentRating = {{!prating}}
//            var afterScholl = {{!AfterSchool}}
            
            // tab js
            function openCity(evt, cityName) {
            // Declare all variables
            var i, tabcontent, tablinks;

            // Get all elements with class="tabcontent" and hide them
            tabcontent = document.getElementsByClassName("tabcontent");
            for (i = 0; i < tabcontent.length; i++) {
                tabcontent[i].style.display = "none";
            }

            // Get all elements with class="tablinks" and remove the class "active"
            tablinks = document.getElementsByClassName("tablinks");
            for (i = 0; i < tablinks.length; i++) {
                tablinks[i].className = tablinks[i].className.replace(" active", "");
            }

            // Show the current tab, and add an "active" class to the button that opened the tab
            document.getElementById(cityName).style.display = "block";
            evt.currentTarget.className += " active";
            }
            
                                
       </script>
        <script src='static/js/main.js'></script>
    </body>
    
</html>