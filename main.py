import streamlit as st
import psycopg2

conn = psycopg2.connect(dbname='scout', user='sa', host='localhost', password='revihcra1!')
cur = conn.cursor()


cur.execute("SELECT * FROM adult;")
print(cur.fetchone())

cur.execute("INSERT INTO test (num, data) VALUES (%s, %s)", (100, "abc'def"))



# Make the changes to the database persistent
conn.commit()

# Close communication with the database
cur.close()
conn.close()