from flask import Flask, render_template,request
from flask_mysqldb import MySQL


app = Flask(__name__)

app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'sarthak'
app.config['MYSQL_PASSWORD'] = 'qwerty123'
app.config['MYSQL_DB'] = 'dbms_projectphase3'

mysql = MySQL(app)

@app.route('/',methods = ['POST','GET'])
def index():
    return render_template('index.html',  )

@app.route('/process', methods=['POST'])
def process():
    query = request.form['query']
    cursor = mysql.connection.cursor()
    cursor.execute(query)
    data = cursor.fetchall()
    colNames = [i[0] for i in cursor.description]
    return render_template('execute.html', dbstuff = data, columns= colNames, query = query)

######################################### USER QUERIES ##################################################
@app.route('/puser', methods=['POST'])
def puser():
    query = 'SELECT distinct show_name from shows LIMIT 15'
    cursor = mysql.connection.cursor()
    cursor.execute(query)
    data = cursor.fetchall()
    colNames = [i[0] for i in cursor.description]
    return render_template('userl.html', dbstuff = data, columns= colNames, query = query)

@app.route('/puserl', methods=['POST'])
def puserl(): # ahve to put insert here
    showname= request.form['query']
    k = str(showname[:-2])
    # print ('++'+k+'++')
    shownamet = '"%'+k+'%"'
    # shownamet = shownamet.replace(' ', '')
    # name_show.strip()
    # name_show = "'"+name_show+"'"

    query = 'SELECT date_event from eventtable where show_id in (select show_id from shows where show_name like '+shownamet+')'
    print ('++++++++D1++++++++')
    print (showname,'++')
    cursor = mysql.connection.cursor()
    cursor.execute(query)
    data = cursor.fetchall()
    colNames = [i[0] for i in cursor.description]
    return render_template('userd.html', dbstuff = data, columns= colNames, query = query,name_show= showname)
    # return render_template('userd.html', query = query, )

@app.route('/puserd', methods=['POST'])
def puserd(): # ahve to put insert here
    showname= request.form['query1']
    k = str(showname[:-2])
    # print ('++'+k+'++')
    shownamet = '"%'+k+'%"'
    showdate = request.form['query']
    showdatet = '"'+showdate+'"'
    # shownamet = shownamet.replace(' ', '')
    # name_show.strip()
    # name_show = "'"+name_show+"'"
    print ('++++++++D2++++++++')
    print (k,'++',showdate)
    query = 'SELECT s.show_name,e.time_event,e.date_event,e.ticket_price from eventtable e join shows s on e.show_id = s.show_id where s.show_id in (select show_id from shows where show_name like '+shownamet+') and e.date_event = '+showdatet
    print ('-----------------')
    print (query)
    cursor = mysql.connection.cursor()
    cursor.execute(query)
    data = cursor.fetchall()
    colNames = [i[0] for i in cursor.description]
    return render_template('userd2.html', dbstuff = data, columns= colNames, query = query,name_show= showname,date_show = showdate)
    # return render_template('userd.html', query = query, )

@app.route('/puserd2', methods=['POST'])
def puserd2(): # ahve to put insert here
    showname= request.form['query1']
    k = str(showname[:-2])
    # print ('++'+k+'++')
    shownamet = '"%'+k+'%"'
    showdate = request.form['query']
    showdatet = '"'+showdate+'"'
    tnum = request.form['numt']

    ########### SHOW ID #################
    query_showid = 'SELECT shows.show_id from shows, eventtable where shows.show_id = eventtable.show_id and shows.show_name like '+shownamet
    cursor = mysql.connection.cursor()
    cursor.execute(query_showid)
    datashow = cursor.fetchall()
    showid = datashow[0][0]
    showid=str(showid)
    ################ E ID ######################
    query_eid = 'SELECT e_id from eventtable e join shows s on e.show_id = s.show_id where s.show_id in (select show_id from shows where show_name like '+shownamet+') and e.date_event = '+showdatet
    cursor = mysql.connection.cursor()
    cursor.execute(query_eid)
    datashow = cursor.fetchall()
    eid = datashow[0][0]
    eid= str(eid)

    ################ Total Price ######################
    query_tprice = 'SELECT distinct ticket_price from eventtable where e_id = '+str(eid)
    cursor = mysql.connection.cursor()
    cursor.execute(query_tprice)
    datashow = cursor.fetchall()
    tprice = datashow[0][0]
    totalprice = int(tprice)*int(tnum)

    ####### INSERT INTO CUSTOMER #############
    cname= request.form['cname']
    cname = '"'+cname+'"'
    emailid= request.form['emailid']
    emailid = '"'+emailid+'"'
    cnum= request.form['cnum']
    cnum = '"'+cnum+'"'
    cardnum= request.form['numcard']
    cardnum = '"'+cardnum+'"'
    query_custin = 'INSERT into customer(customer_name,phone_no,email_id,payment_details) values('+cname+','+cnum+','+emailid+','+cardnum+')'
    print ('------------',query_custin)
    cursor.execute(query_custin)
    print ('++++++++CUSTOMER INSERTED++++++++')
    mysql.connection.commit()


    ########### CUST ID ##############
    query_cid = 'SELECT max(customer_id) from customer order by customer_id desc'
    cursor = mysql.connection.cursor()
    cursor.execute(query_cid)
    data = cursor.fetchall()
    cust_id = data[0][0]+1 # has to go into insert




    ################ CUR DATE AND TIME #############
    query_time = 'SELECT CURTIME();'
    cursor = mysql.connection.cursor()
    cursor.execute(query_time)
    datashow = cursor.fetchall()
    ctime = datashow[0][0]
    ctime = str(ctime)
    ctime = '"'+ctime+'"'
    query_date = 'SELECT CURDATE();'
    cursor = mysql.connection.cursor()
    cursor.execute(query_date)
    datashow = cursor.fetchall()
    cdate = datashow[0][0]
    cdate = str(cdate)
    cdate = '"'+cdate+'"'
    print ('++++++++INSERT DATA++++++++')
    print (eid,cust_id,tnum,totalprice,ctime,cdate)


    ####### INSERT INTO BOOKING #############

    query_insert = 'INSERT into booking(e_id,customer_id,num_tickets,price,booking_date,booking_time,booking_lable) values('+str(eid)+','+str(cust_id-1)+','+str(tnum)+','+str(totalprice)+','+str(cdate)+','+str(ctime)+',"YES")'
    print (query_insert)
    cursor.execute(query_insert)
    print ('++++++++ BOOKING UPDATED++++++++')
    mysql.connection.commit()


    # shownamet = shownamet.replace(' ', '')
    # name_show.strip()
    # name_show = "'"+name_show+"'"
    # print ('++++++++D2++++++++')
    # print (k,'++',showdate)
    # query = 'SELECT s.show_name,e.time_event,e.date_event,e.ticket_price from eventtable e join shows s on e.show_id = s.show_id where s.show_id in (select show_id from shows where show_name like '+shownamet+') and e.date_event = '+showdatet
    # print ('-----------------')
    # print (query)
    # cursor = mysql.connection.cursor()
    # cursor.execute(query)
    # data = cursor.fetchall()
    # colNames = [i[0] for i in cursor.description]
    return render_template('userinsert.html', dbstuff = data, query = query_insert, query1 = query_custin,name_show= showname,date_show = showdate, tnum = tnum, totprice = totalprice)
    # return render_template('userinsert.html',name_show= showname,date_show = showdate, tnum = tnum)



################################################ ADMIN QUERIES #######################################
@app.route('/q3', methods=['POST']) # viewtop 10
def pq3():
    num = request.form['query']
    query = 'SELECT customer_name, COUNT(booking.customer_id) FROM booking, customer WHERE  booking.customer_id = customer.customer_id GROUP BY booking.customer_id ORDER BY COUNT(booking.booking_id) DESC LIMIT ' + num
    cursor = mysql.connection.cursor()
    cursor.execute(query)
    data = cursor.fetchall()
    colNames = [i[0] for i in cursor.description]
    return render_template('q3.html', dbstuff = data, columns= colNames, query = query)

@app.route('/pq1', methods=['POST']) # add event
def pq1():
    cursor = mysql.connection.cursor()
    showid = request.form['showid']
    showid = '"'+showid+'"'
    etime = request.form['etime']
    etime = '"'+etime+'"'
    edate = request.form['edate']
    edate = '"'+edate+'"'
    tprice = request.form['tprice']
    # query = 'SET @show_id='+showid+';SET @time_event ="'+etime+'";set @date_event = "'+edate+'";set @ticket_price = "'+tprice+'";insert into eventtable(show_id,time_event,date_event,ticket_price) values(@show_id,@time_event,@date_event,@ticket_price);'
    query = 'INSERT into eventtable(show_id,time_event,date_event,ticket_price) values('+showid+','+etime+','+edate+','+tprice+');'
    cursor.execute(query)
    print ('++++++++++++++++ce')
    mysql.connection.commit()
    return render_template('q1d.html', query = query)

@app.route('/q2', methods=['POST']) # Option for admin to add event

def pq2():
    showname = request.form['query']
    showname = '"%'+showname+'%"'
    query = 'SELECT show_name, COUNT(reservation.show_id) AS num_of_reservations FROM	shows JOIN 	reservation ON reservation.show_id = shows.show_id  WHERE show_name like '+showname+' GROUP BY reservation.show_id '
    cursor = mysql.connection.cursor()
    cursor.execute(query)
    data = cursor.fetchall()
    colNames = [i[0] for i in cursor.description]
    return render_template('q2.html', dbstuff = data, columns= colNames, query = query)

@app.route('/q4', methods=['POST']) # Number of movies released in the year selected by the admin
def pq4():
    year = request.form['year']
    print (year)
    query = 'SELECT release_date, COUNT(shows.show_id) AS Total_movie FROM shows JOIN movie ON movie.show_id = shows.show_id WHERE release_date ='+year+' GROUP BY release_date'
    cursor = mysql.connection.cursor()
    cursor.execute(query)
    data = cursor.fetchall()
    colNames = [i[0] for i in cursor.description]
    return render_template('q4.html', dbstuff = data, columns= colNames, query = query)

@app.route('/q5', methods=['POST']) # viewtop 10
def pq5():
    showname = request.form['query']
    showname = '"%'+showname+'%"'
    query = 'SELECT e_id, ticket_price FROM eventtable WHERE 	eventtable.show_id in (SELECT  shows.show_id FROM shows	WHERE 	show_name like '+showname+')'
    cursor = mysql.connection.cursor()
    cursor.execute(query)
    data = cursor.fetchall()
    colNames = [i[0] for i in cursor.description]
    return render_template('q5.html', dbstuff = data, columns= colNames, query = query)

@app.route('/q6', methods=['POST']) # viewtop 10
def pq6():
    ptype = request.form['query']
    ptype = '"%'+ptype+'%"'
    num = request.form['num']
    query = 'SELECT	performance.show_id, performers, show_name FROM	performance, shows WHERE	performance_type like '+ptype+' 	AND shows.show_id = performance.show_id LIMIT '+ num
    cursor = mysql.connection.cursor()
    cursor.execute(query)
    data = cursor.fetchall()
    colNames = [i[0] for i in cursor.description]
    return render_template('q6.html', dbstuff = data, columns= colNames, query = query)

@app.route('/q7', methods=['POST']) # viewtop 10
def pq7():
    eid = request.form['query']
    eid = '"'+eid+'"'

    query = 'SELECT	COUNT(booking_id) FROM	booking WHERE 	e_id = '+ eid+ ' GROUP BY e_id'
    cursor = mysql.connection.cursor()
    cursor.execute(query)
    data = cursor.fetchall()
    colNames = [i[0] for i in cursor.description]
    return render_template('q7.html', dbstuff = data, columns= colNames, query = query)

@app.route('/q8', methods=['POST']) # viewtop 10
def pq8():
    numt = request.form['query']
    numt = '"'+numt+'"'
    num = request.form['num']
    query = 'SELECT customer_name FROM	(SELECT    customer_id, COUNT(booking.num_tickets) 	FROM    	booking	GROUP BY booking.customer_id	HAVING COUNT(booking.num_tickets) = '+numt+ ') AS s,	customer WHERE 	s.customer_id = customer.customer_id LIMIT '+num
    cursor = mysql.connection.cursor()
    cursor.execute(query)
    data = cursor.fetchall()
    colNames = [i[0] for i in cursor.description]
    return render_template('q8.html', dbstuff = data, columns= colNames, query = query)

@app.route('/q9', methods=['POST']) # viewtop 10
def pq9():
    eid = request.form['query']
    eid = '"'+eid+'"'

    query = 'SELECT	hall.name_hall FROM	hall WHERE hall.hall_id IN (SELECT reservation.hall_id FROM reservation WHERE reservation.show_id IN (SELECT show_id FROM eventtable WHERE e_id ='+eid+'))'
    cursor = mysql.connection.cursor()
    cursor.execute(query)
    data = cursor.fetchall()
    colNames = [i[0] for i in cursor.description]
    return render_template('q9.html', dbstuff = data, columns= colNames, query = query)

@app.route('/q10', methods=['POST']) # viewtop 10
def pq10():
    showid = request.form['query']
    showid = '"'+showid+'"'

    query = 'SELECT	show_name, reservation.r_date, reservation.r_time FROM reservation JOIN shows ON reservation.show_id = shows.show_id WHERE	reservation.show_id = '+showid
    cursor = mysql.connection.cursor()
    cursor.execute(query)
    data = cursor.fetchall()
    colNames = [i[0] for i in cursor.description]
    return render_template('q10.html', dbstuff = data, columns= colNames, query = query)

@app.route('/q11', methods=['POST']) # viewtop 10
def pq11():
    bid = request.form['query']
    bid = '"'+bid+'"'
    query = 'SELECT	* FROM	customer HAVING customer_id IN (SELECT booking.customer_id	FROM  booking WHERE  booking_id = '+bid+')'
    cursor = mysql.connection.cursor()
    cursor.execute(query)
    data = cursor.fetchall()
    colNames = [i[0] for i in cursor.description]
    return render_template('q11.html', dbstuff = data, columns= colNames, query = query)

@app.route('/q12', methods=['POST']) # viewtop 10
def pq12():
    hid = request.form['query']
    hid = '"'+hid+'"'
    query = 'SELECT	shows.show_name FROM shows WHERE	shows.show_id IN (SELECT  eventtable.show_id FROM  eventtable HAVING eventtable.show_id IN (SELECT  reservation.show_id FROM reservation WHERE reservation.hall_id = '+hid+'))'
    cursor = mysql.connection.cursor()
    cursor.execute(query)
    data = cursor.fetchall()
    colNames = [i[0] for i in cursor.description]
    return render_template('q12.html', dbstuff = data, columns= colNames, query = query)

@app.route('/q13', methods=['POST']) # viewtop 10
def pq13():
    rating = request.form['query']
    rating = '"%'+rating+'%"'
    num = request.form['num']
    query = 'SELECT	shows.show_name FROM shows WHERE shows.show_id IN (SELECT ALL movie.show_id FROM  movie WHERE  rating like '+rating+' GROUP BY movie.rating) LIMIT '+num
    cursor = mysql.connection.cursor()
    cursor.execute(query)
    data = cursor.fetchall()
    colNames = [i[0] for i in cursor.description]
    return render_template('q13.html', dbstuff = data, columns= colNames, query = query)

@app.route('/q14', methods=['POST']) # viewtop 10
def pq14():
    cnum = request.form['query']
    num = request.form['num']
    query = 'SELECT DISTINCT	show_name, release_date FROM movie,	shows WHERE shows.show_id IN (SELECT show_id FROM  eventtable  GROUP BY show_id HAVING COUNT(show_id) > '+cnum+')  AND release_date = 2017 LIMIT '+num
    cursor = mysql.connection.cursor()
    cursor.execute(query)
    data = cursor.fetchall()
    colNames = [i[0] for i in cursor.description]
    return render_template('q14.html', dbstuff = data, columns= colNames, query = query)



######################################## APP ROUTES #####################################

@app.route('/execute', methods = ['POST','GET'])
def execute():
    return render_template('execute.html')

@app.route('/execute/q3', methods = ['POST','GET'])
def q3():
    return render_template('q3.html')

@app.route('/execute/q2', methods = ['POST','GET'])
def q2():
    return render_template('q2.html')

@app.route('/execute/q1', methods = ['POST','GET'])
def q1():
    return render_template('q1.html')

@app.route('/execute/q4', methods = ['POST','GET'])
def q4():
    return render_template('q4.html')

@app.route('/execute/q5', methods = ['POST','GET'])
def q5():
    return render_template('q5.html')

@app.route('/execute/q6', methods = ['POST','GET'])
def q6():
    return render_template('q6.html')

@app.route('/execute/q7', methods = ['POST','GET'])
def q7():
    return render_template('q7.html')

@app.route('/execute/q9', methods = ['POST','GET'])
def q9():
    return render_template('q9.html')

@app.route('/execute/q10', methods = ['POST','GET'])
def q10():
    return render_template('q10.html')

@app.route('/execute/q11', methods = ['POST','GET'])
def q11():
    return render_template('q11.html')

@app.route('/execute/q12', methods = ['POST','GET'])
def q12():
    return render_template('q12.html')

@app.route('/execute/q8', methods = ['POST','GET'])
def q8():
    return render_template('q8.html')

@app.route('/execute/q13', methods = ['POST','GET'])
def q13():
    return render_template('q13.html')

@app.route('/execute/q14', methods = ['POST','GET'])
def q14():
    return render_template('q14.html')



@app.route('/user', methods = ['POST','GET'])
def user():
    return render_template('user.html')

@app.route('/userl', methods = ['POST','GET'])
def userl():
    return render_template('userl.html')

@app.route('/userd', methods = ['POST','GET'])
def userd():
    return render_template('userd.html')

@app.route('/userd2', methods = ['POST','GET'])
def userd2():
    return render_template('userd2.html')
@app.route('/userinsert', methods = ['POST','GET'])
def userinsert():
    return render_template('userinsert.html')

@app.route('/userconf', methods = ['POST','GET'])
def userconf():
    return render_template('userconf.html')



if __name__=='__main__':
    app.run(debug = True)
