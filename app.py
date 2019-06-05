import requests, os, json, psycopg2, sys, re
from bottle import route, run, debug
from bottle import redirect, request, template, static_file, get, delete
from geopy.geocoders import GoogleV3
from geopy.exc import GeocoderInsufficientPrivileges
from geopy.exc import GeocoderTimedOut

con = psycopg2.connect("host='host' dbname='database' user='username' password='password'")
cur = con.cursor()

@route("/static/css/<filepath:re:.*\.css>")
def css(filepath):
    return static_file(filepath, root="static/css")

@route("/static/js/<filepath:re:.*\.js>")
def send_static(filepath):
    return static_file(filepath, root="./static/js")

@route('/home', method='GET')
def new_item():
    if request.GET.get('add','').strip():
        Addres = request.GET.get('address', '').strip()
        geolocator = GoogleV3()
        location = geolocator.geocode(Addres, timeout=10)
        lat = location.latitude
        long = location.longitude
        
        cur.execute("DROP TABLE IF EXISTS myLocation")
        cur.execute("CREATE TABLE if not exists myLocation (id SERIAL PRIMARY KEY, Address VARCHAR)")
        cur.execute("INSERT INTO myLocation (Address) VALUES (%s)", (Addres,))
        cur.execute("ALTER TABLE myLocation ADD COLUMN Latitude double precision, ADD COLUMN Longitude double precision")
        cur.execute("UPDATE myLocation SET Latitude = (%s), Longitude = (%s)", (lat, long))
        cur.execute("ALTER TABLE myLocation ADD COLUMN geom geometry(POINT,4326)")
        cur.execute("UPDATE myLocation SET geom = ST_SetSRID(ST_MakePoint(Longitude,Latitude),4326)")
        con.commit()
        
        return redirect('/show')
    else:
        return template('view/Homepage.tpl')
    
@route('/show', method='GET')
def compare_List():
    # for dropdown
    cur.execute("SELECT distinct levels from public.hisdattendance ORDER BY levels")
    levels = cur.fetchall()
    row_list =[]
    for i in levels:
        license_dict = {"levels": str(i[0])}
        row_list.append(license_dict)
    
    # for my current location
    cur.execute("Select * FROM myLocation")
    currentLocation = cur.fetchall()
    d =[]
    for i in currentLocation:
        Json_dict = {"Latitude": i[2], "Longitude": i[3]}
        d.append(Json_dict)
    j = json.dumps(d)
    
     # for xy location intersect school attendance zone
    slevel = request.GET.get('show', '').strip()
    cur.execute("DROP TABLE IF EXISTS public.mypoly")
    con.commit()
    cur.execute("CREATE TABLE if not exists public.mypoly (geom geometry)")
    cur.execute("INSERT INTO public.mypoly (geom) (SELECT a.wkb_geometry from public.hisdattendance a join public.myLocation b on ST_Within(b.geom, a.wkb_geometry) WHERE level like '%s')" % slevel)
    cur.execute("SELECT row_to_json(fc) AS geojson FROM (SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features FROM (SELECT 'Feature' As type, ST_AsGeoJSON(ST_Transform(lg.wkb_geometry, 4326),15,0)::json As geometry, row_to_json((fid, levels)) As properties FROM (SELECT * FROM public.hisdattendance b join public.mylocation t on ST_Intersects(t.geom, b.wkb_geometry)) As lg  WHERE lg.levels LIKE '%s') As f ) As fc" % slevel)
    con.commit()
    poly = cur.fetchall()
    z = json.dumps(poly)
    
    #for publicschools intersect school attendance zone
    cur.execute("DROP TABLE IF EXISTS selectedSchool")
    con.commit()
    cur.execute("CREATE TABLE if not exists public.selectedSchool(id integer, gsid integer, name character varying, type character varying, graderange character varying, enrollment character varying, gsrating character varying, parentrating character varying, city character varying, districtid character varying, districtname character varying, districtno character varying, state character varying,address character varying, phone character varying, fax character varying, latitude double precision, longitude double precision, ranges text, geom geometry)")
    cur.execute("INSERT INTO public.selectedSchool (SELECT id, gsid, name, type, graderange, enrollment, gsrating, parentrating, city, districtid, districtname, districtno, state, address, phone, fax, latitude, longitude, ranges FROM public.hisdFullSchool b join public.myPoly t on ST_Within(b.geom, t.geom) where ranges LIKE '%s')" % slevel)
    cur.execute("UPDATE public.selectedSchool SET geom = ST_SetSRID(ST_MakePoint(longitude,latitude),4326)")
    cur.execute("SELECT row_to_json(fc) AS geojson FROM (SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features FROM (SELECT 'Feature' As type, ST_AsGeoJSON((lg.geom),15,0)::json As geometry, row_to_json((name, type, graderange, enrollment, gsrating, parentrating, city, districtid, districtname, state, address, phone, fax)) As properties FROM public.selectedSchool As lg) As f ) As fc;")
    con.commit()
    schoolsLocation = cur.fetchall()
    elem = json.dumps(schoolsLocation)
    
    cur.execute("Select distinct * FROM public.selectedSchool")
    currentLocation = cur.fetchall()
    labels =[]
    data = []
    pr = []
    for item in currentLocation:
        Json_dict = item[2]
        json_enroll = item[5]
        json_pr = item[5]
        
        labels.append(Json_dict)
        data.append(json_enroll)
        pr.append(json_pr)
    l = labels
    d = data
    p = pr
    
#    cur.execute(""SELECT row_to_json(fc) AS geojson FROM (SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features FROM (SELECT 'Feature' As type, ST_AsGeoJSON((lg.geom),15,0)::json As geometry, row_to_json((facility, school_nam, address, contact, email, call_num, website)) As properties FROM (SELECT distinct a.* FROM public.afterschool a, public.selectedschool b WHERE a.othername = b.name) AS lg) As f ) As fc"")
#    afterSchool = cur.fetchall()
#    ASkool = json.dumps(afterSchool)
    
    
    output = template('view/mainPage', rows = row_list, publicsch = elem, currentLoc=j, eventLoc=z, label = l, datas = data, prating = pr)
    return output

@route('/reset', method='GET')
def delete_item():
    if request.GET.get('reset','').strip():
        cur.execute("DROP TABLE IF EXISTS selectedSchool")
        con.commit()
        cur.execute("DROP TABLE IF EXISTS myPoly")
        con.commit()
        return redirect('/show')
    else:
        return template('view/mainPage')


run(host='localhost',port=5000,debug=True)
