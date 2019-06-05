<html>
    <head>
        <title>Leaflet map</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" type="text/css" href="/static/css/homepage.css">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">  
        <link rel="stylesheet" href="https://unpkg.com/leaflet@1.1.0/dist/leaflet.css" />
        <script src="https://unpkg.com/leaflet@1.1.0/dist/leaflet.js"></script>
        <script src="https://code.jquery.com/jquery-3.2.1.js"></script>
        <script type=text/javascript src="static/js/lib/jquery-3.2.0.min.js"></script>
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
                    <a href="#" class="navbar-brand">GLC</a>
                    </div>
                    <div class="collapse navbar-collapse" id="bs-nav-demo"> 
                        <ul class="nav navbar-nav">
                            <li><a href="#">About</a></li>
                            <li><a href="#">Contact</a></li>
                        </ul>
                </div>
            </div>
        </nav>
            
        <div id="content">
            <div class="container">
                <div class="row">
                    <div class="col-lg-12">
                        <h1>Enter Address : </h1>
                        <form action="/home" method="GET">
                            <div class="form-group form-group-lg">
                                <input type="text" class="form-control" name="address" id="address" aria-describedby="addressHelp" placeholder="Enter address">
                                <button type="submit" class="btn btn-primary btn-lg" name="add" value="add">Enter</button>
                            </div>
                        </form> 
                    </div>

                </div>
            </div>
        </div>
        
    </body>
</html>