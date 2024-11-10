# 連線到 raspberry 
# 並獲取全部的 sql 命令回應 = cursor.fetchall()
import streamlit as st
import psycopg2
connect = psycopg2.connect( host='192.168.0.252',
                            database='mydatabase_a29',
                            user='a29',
                            password='raspberry',
                            port='5432')
cursor = connect.cursor()
cursor.execute('''SELECT * FROM stations;''')

rows = cursor.fetchall()
names = []
for row in rows:
    names.append(row[2])

cursor.close()
connect.close()

st.write(names)

option = st.selectbox(
    "How would you like to be contacted?",
    names
)

st.write("You selected: ", option)
st.write("index: ", names.index(option))
st.write('地址: ', rows[names.index(option)][4])