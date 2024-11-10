# -*- coding: utf-8 -*-
"""
Created on Sun Oct 27 09:04:53 2024

@author: Rick_NB_2023
"""

print('hello')


# 連線到 raspberry 
import psycopg2
connect = psycopg2.connect( host='192.168.0.252',
                            database='mydatabase_a29',
                            user='a29',
                            password='raspberry')
cursor = connect.cursor()
cursor.execute("SELECT version();")
db_version = cursor.fetchone()
print(db_version)
print('finish db connect')
cursor.close()
connect.close()



