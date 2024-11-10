import streamlit as st
# 連線到 raspberry 
import psycopg2
from dotenv import load_dotenv, find_dotenv
import os
import sys
import pandas as pd
success = load_dotenv()

if success:
    #print("成功載入 .env 檔案\n")
    pass
else:
    load_dotenv(find_dotenv(f'.env.raspberry'))
    #load_dotenv(find_dotenv(f'.env.render'))



#把敏感資料改成從 .env檔案 讀取
# conn = psycopg2.connect(host     = os.getenv('POSTGRE_HOST'),
#                         database = os.getenv('POSTGRE_DATABASE'),
#                         user     = os.getenv('POSTGRE_USER'),
#                         password = os.getenv('POSTGRE_PASSWORD'))


@st.cache_data
def getData(country:tuple[str])->list[tuple]:
    conn = psycopg2.connect(host     = os.getenv('POSTGRE_HOST'),
                        database = os.getenv('POSTGRE_DATABASE'),
                        user     = os.getenv('POSTGRE_USER'),
                        password = os.getenv('POSTGRE_PASSWORD'))
    with conn:
        with conn.cursor() as cursor:
            sql = '''
            SELECT country,市場.name,date,adj_close,volume
            FROM 股市 JOIN 市場 ON 股市.name = 市場.name
            WHERE country IN %s;
            '''
            cursor.execute(sql,(country,))
            all_data = cursor.fetchall()
    conn.close()
    return all_data


@st.cache_resource
def get_country():
    conn = psycopg2.connect(host     = os.getenv('POSTGRE_HOST'),
                            database = os.getenv('POSTGRE_DATABASE'),
                            user     = os.getenv('POSTGRE_USER'),
                            password = os.getenv('POSTGRE_PASSWORD'))
    with conn:
        with conn.cursor() as cursor:
            sql = '''
            SELECT * FROM 市場
            '''
            cursor.execute(sql)
            all_country = cursor.fetchall()
    conn.close()
    input_dict = dict(all_country)
    return input_dict.values()

def user_select():
    print('使用者選擇了')
    print(st.session_state.stocks)

st.title('世界大盤分析')
default_country = '台灣'
with st.sidebar:    
    st.title('請選擇股票市場:')
    
    st.multiselect("請選擇",get_country(),
                    default=default_country,
                    placeholder="請選擇市場",
                    label_visibility='hidden',
                    key='stocks',
                    on_change=user_select)
    st.write(default_country)

df = pd.DataFrame(getData((default_country,)),columns=['國家','代號','日期','收盤價','成交量'])
df['收盤價'] = df['收盤價'].astype('float').round(decimals=2)
st.line_chart(data=df,x='日期',y='收盤價',color='國家')