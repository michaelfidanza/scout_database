import streamlit as st
import pandas.io.sql as sqlio
import psycopg2
from datetime import date
import calendar
from PIL import Image

url_github = 'https://github.com/michaelfidanza'

# titles
st.markdown("<h1 style='text-align: center; color: brown;'>Scout database</h1>", unsafe_allow_html=True)
st.markdown("<h2 style='text-align: center; color: grey;'>Database Project 2021/2022</h2>", unsafe_allow_html=True)
st.markdown("<h3 style='text-align: center; color: grey;'>Michael Fidanza - VR472909</h3>", unsafe_allow_html=True)
st.markdown("<h6 style='text-align: center; color: black;'><a href=" + url_github + ">GitHub profile</a></h6>", unsafe_allow_html=True)

st.write("")
st.write("")
st.write("")

# connect to the DB
conn = psycopg2.connect(dbname='scout', user='sa', host='localhost', password='revihcra1!')
cur = conn.cursor()



operation = st.selectbox('Choose the operation', ['Visualize DATA', 'Insert DATA'])

# retrieve all the tables names from the DB
tables_in_db = sqlio.read_sql_query("SELECT table_name\
                        FROM information_schema.tables\
                        WHERE table_schema='public'\
                        AND table_type='BASE TABLE';", conn)


# create a dictionary containing all dataframes for each table in the DB
tables_dict = {}
for table in tables_in_db.table_name:
        tables_dict[table] = sqlio.read_sql_query('Select * from ' + table, conn)


tables_dict['group_activity'].start_date = tables_dict['group_activity'].start_date.map(lambda x : str(x))
tables_dict['organization_activity'].start_date = tables_dict['organization_activity'].start_date.map(lambda x : str(x))


# show conceptual schema
image = Image.open('database_project_last_version.jpg')
st.image(image)

if 'Visualize' in operation:
    # let the used decide which tables to look at
    tables_to_visualize = st.multiselect('Choose the tables you want to visualize', tables_dict.keys(), default=tables_dict.keys())
    
    col1, col2 = st.columns(2)
    col = 1
    
    for table in tables_to_visualize:
        
        if col == 1:
            with col1:
                st.write(table)
                st.write(tables_dict[table])
                col = 2
        else:
            with col2:
                st.write(table)
                st.write(tables_dict[table])
                col = 1

if 'Insert' in operation:
    # let the user decide which tables to insert data
    st.subheader('Input Table')
    table_to_insert_data = st.selectbox('Choose the table you want to add data to', tables_in_db.table_name)
    
    st.write("")
    st.write("")
    st.write("")

    st.subheader('Current Data')
    st.write(tables_dict[table_to_insert_data])

    st.write("")
    st.write("")
    st.write("")

    user_inputs = {}
    st.subheader('Input parameters')

    if table_to_insert_data == 'nation':
        user_inputs['name'] = "'" + (st.text_input('Insert the name of the nation')) + "'"
    
    elif table_to_insert_data == 'organization':
        user_inputs['name'] = "'" + (st.text_input('Insert the name of the organization')) + "'"
        user_inputs['nation_name'] = "'" + st.selectbox('Choose the nation of the organization', tables_dict['nation'].name) + "'"
    
    elif table_to_insert_data == 'group_zone':
        user_inputs['organization_name'] = "'" + st.selectbox('Choose the organization you want to create a new zone for', tables_dict['organization'].name) + "'"
        user_inputs['zone_description'] = "'" + st.text_input('Insert a description for the zone') + "'"
    
    elif table_to_insert_data == 'scout_group':
        user_inputs['name'] = "'" + st.text_input('Insert the name of the scout group') + "'"
        user_inputs['phone'] = "'" + st.text_input('Insert the phone number') + "'"
        user_inputs['address'] = "'" + st.text_input('Insert the address') + "'"
        user_inputs['website']  = "'" + st.text_input('Insert the website (if any)') + "'"
        user_inputs['zone_id'] = int(st.selectbox('Choose the zone the scout group belongs to', tables_dict['group_zone'].id.map(lambda x : str(x)) + ': ' + tables_dict['group_zone'].organization_name + ', ' + tables_dict['group_zone'].zone_description).split(':')[0])
    
    elif table_to_insert_data == 'boyscout':
        user_inputs['name'] = "'" + st.text_input('Insert the name of the boyscout') + "'"
        user_inputs['surname'] = "'" + st.text_input('Insert the surname') + "'"
        user_inputs['phone'] = "'" + st.text_input('Insert the phone number') + "'"
        user_inputs['emergency_contact'] = "'" + st.text_input('Insert the emergency contact') + "'"
        
        col1, col2, col3 = st.columns(3)
        with col1:
            year = st.selectbox('Birth date: year', range(date.today().year -9, date.today().year -22 , -1), 0)
        with col2:
            month = st.selectbox('month', range(1, 13))
        with col3:
            if month == 2:
                if calendar.isleap(year):
                    day = st.selectbox('day', range(1,30))
                else:
                    day = st.selectbox('day', range(1, 29))
            elif month in (11, 4, 6, 9):
                day = st.selectbox('day', range(1,31))
            else:
                day = st.selectbox('day', range(1,32))
        st.columns(1)
        user_inputs['birthdate'] = "'" + str(year) + "-" + str(month) + "-" + str(day) + "'"
        
        cur.callproc('category_by_age', [user_inputs['birthdate'], ])
        
        user_inputs['category_name'] = "'" + st.selectbox('Scout category', cur.fetchall()[0]) + "'"
        user_inputs['group_name'] = "'" + st.selectbox('Select the scout group', tables_dict['scout_group'].name) + "'"
    
    elif table_to_insert_data == 'adult': 
        user_inputs['name'] = "'" + st.text_input('Insert the name of the adult') + "'"
        user_inputs['surname'] = "'" + st.text_input('Insert the surname') + "'"
        user_inputs['phone'] = "'" + st.text_input('Insert the phone number') + "'"
        user_inputs['emergency_contact'] = "'" + st.text_input('Insert the emergency contact') + "'"
        
        col1, col2, col3 = st.columns(3)
        with col1:
            year = st.selectbox('Birth date: year', range(date.today().year -22, date.today().year -100 , -1), 0)
        with col2:
            month = st.selectbox('month', range(1, 13))
        with col3:
            if month == 2:
                if calendar.isleap(year):
                    day = st.selectbox('day', range(1,30))
                else:
                    day = st.selectbox('day', range(1, 29))
            elif month in (11, 4, 6, 9):
                day = st.selectbox('day', range(1,31))
            else:
                day = st.selectbox('day', range(1,32))
        st.columns(1)
        user_inputs['birthdate'] = "'" + str(year) + "-" + str(month) + "-" + str(day) + "'"  
        user_inputs['training_level'] = "'" + st.text_input('Insert the training level') + "'"     
        user_inputs['scout_role'] = "'" + st.text_input('Insert the scout role') + "'"
        user_inputs['head_of_category'] = "'" + st.selectbox('Head of category', ['L/C', 'E/G', 'R/S']) + "'"
        user_inputs['group_name'] = "'" + st.selectbox('Select the scout group', tables_dict['scout_group'].name) + "'"
    
    elif table_to_insert_data == 'year_to_pay':
        user_inputs['year_to_pay'] = st.selectbox('Insert new year', range(date.today().year + 1, date.today().year - 100, -1), 0 )
    
    elif table_to_insert_data == 'boyscout_annual_fee':
        user_inputs['boyscout_id'] = int(st.selectbox('Choose the boyscout who has paid', tables_dict['boyscout'].id.map(lambda x : str(x)) + ': ' + tables_dict['boyscout'].name \
            + " " + tables_dict['boyscout'].surname + ", " + tables_dict['boyscout'].group_name).split(':')[0])
        user_inputs['year_paid'] = "'" + str(st.selectbox('Choose the year that has been paid', tables_dict['year_to_pay'].year_to_pay)) + "'"
    
    elif table_to_insert_data == 'group_activity':
        user_inputs['group_name'] = "'" + st.selectbox('Select the scout group', tables_dict['scout_group'].name) + "'"
        user_inputs['description'] = "'" + st.text_input('Insert a description for the event') + "'"
        col1, col2, col3 = st.columns(3)
        with col1:
            year = st.selectbox('Start date of the event: year', range(date.today().year, date.today().year +2), 0)
        with col2:
            month = st.selectbox('month', range(1, 13))
        with col3:
            if month == 2:
                if calendar.isleap(year):
                    day = st.selectbox('day', range(1,30))
                else:
                    day = st.selectbox('day', range(1, 29))
            elif month in (11, 4, 6, 9):
                day = st.selectbox('day', range(1,31))
            else:
                day = st.selectbox('day', range(1,32))
        st.columns(1)
        user_inputs['start_date'] = "'" + str(year) + "-" + str(month) + "-" + str(day) + "'"  
        user_inputs['duration'] =  "'" + st.text_input('Insert the duration') + "'"
        user_inputs['location'] =  "'" + st.text_input('Insert the location') + "'"
        user_inputs['price'] =  st.text_input('Insert the price', value=0)
        try:
            user_inputs['price'] = float(user_inputs['price'])
        except:
            st.markdown("<h6 style='text-align: left; color: red;'>The price must be a number</h6>", unsafe_allow_html=True)
            
        user_inputs['phone'] =  "'" + st.text_input('Insert the phone number') + "'"
    
    elif table_to_insert_data == 'organization_activity':
        user_inputs['organization_name'] = "'" + st.selectbox('Select the scout group', tables_dict['organization'].name) + "'"
        user_inputs['description'] = "'" + st.text_input('Insert a description for the event') + "'"
        col1, col2, col3 = st.columns(3)
        with col1:
            year = st.selectbox('Start date of the event: year', range(date.today().year, date.today().year +2), 0)
        with col2:
            month = st.selectbox('month', range(1, 13))
        with col3:
            if month == 2:
                if calendar.isleap(year):
                    day = st.selectbox('day', range(1,30))
                else:
                    day = st.selectbox('day', range(1, 29))
            elif month in (11, 4, 6, 9):
                day = st.selectbox('day', range(1,31))
            else:
                day = st.selectbox('day', range(1,32))
        st.columns(1)
        user_inputs['start_date'] = "'" + str(year) + "-" + str(month) + "-" + str(day) + "'"  
        user_inputs['duration'] =  "'" + st.text_input('Insert the duration') + "'"
        user_inputs['location'] =  "'" + st.text_input('Insert the location') + "'"
        user_inputs['price'] =  st.text_input('Insert the price', value=0)
        try:
            user_inputs['price'] = float(user_inputs['price'])
        except:
            st.markdown("<h6 style='text-align: left; color: red;'>The price must be a number</h6>", unsafe_allow_html=True)
            
        user_inputs['phone'] =  "'" + st.text_input('Insert the phone number') + "'"
    
    elif table_to_insert_data == 'group_activity_category':
        if len(tables_dict['group_activity'].id) > 0 :
            
            user_inputs['id'] = int(st.selectbox('Choose the activity you want to add a category to', tables_dict['group_activity'].id.map(lambda x : str(x)) + ": " \
            + tables_dict['group_activity'].description + " organized by " + tables_dict['group_activity'].group_name + " on " + tables_dict['group_activity'].start_date).split(':')[0])
            
            user_inputs['category_allowed'] = "'" + st.selectbox('Choose a category which is allowed to participate to the event', tables_dict['category'].name) + "'"
        else:
            st.markdown("<h6 style='text-align: left; color: red;'>There are no activity organized by scout groups yet</h6>", unsafe_allow_html=True)
    elif table_to_insert_data == 'organization_activity_category':
        if len(tables_dict['organization_activity'].id) > 0 :
            user_inputs['id'] = "'" + str(st.selectbox('Choose the activity you want to add a category to', tables_dict['organization_activity'].id.map(lambda x : str(x)) + ": " \
            + tables_dict['organization_activity'].description + " organized by " + tables_dict['organization_activity'].group_name + " on " + tables_dict['organization_activity'].start_date)) + "'"
            user_inputs['category_allowed'] = "'" + st.selectbox('Choose a category which is allowed to participate to the event', tables_dict['category'].name) + "'"
        else:
            st.markdown("<h6 style='text-align: left; color: red;'>There are no activity organized by organizations yet</h6>", unsafe_allow_html=True)
    
    st.columns(1)
    
    
    
    columns = user_inputs.keys()
    values = user_inputs.values()

    # transform keys of the dict in columns to insert
    str_columns = ""
    for col in columns:
        if str_columns == "":
            str_columns = str_columns + col
        else:
            str_columns = str_columns + "," + col
    
    # values of dict to insert inside DB
    str_values = ""
    for value in values:
        if str_values == "":
            str_values = str_values + str(value)
        else:
            str_values = str_values + "," + str(value)  
    

    insert_data_trigger = st.button('Insert data')
    
    if insert_data_trigger:
        cur.execute("INSERT INTO " + table_to_insert_data + " (" + str_columns + ") VALUES (" + str_values + ")")
        # Make the changes to the database persistent
        conn.commit()

        st.experimental_rerun()
        

# Close communication with the database
cur.close()
conn.close()