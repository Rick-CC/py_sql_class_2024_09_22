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


SQL = '''
SELECT *
FROM 市場;
'''
SQL_stock=  '''
SELECT country,市場.name,date,adj_close,volume
FROM 股市 JOIN 市場 ON 股市.name = 市場.name
WHERE country IN %s;
'''

@st.cache_data  #<--------- 加入此功能, 註冊 conn, 只運行一次
def getData(_country:tuple[str])->list[tuple]:
    conn = psycopg2.connect(host     = os.getenv('POSTGRE_HOST'),
                            database = os.getenv('POSTGRE_DATABASE'),
                            user     = os.getenv('POSTGRE_USER'),
                            password = os.getenv('POSTGRE_PASSWORD'))
    with conn:
        with conn.cursor() as cursor:
            cursor.execute(SQL_stock,(_country,))
            all_data = cursor.fetchall()
    conn.close()
    return all_data


@st.cache_resource  #<--------- 加入此功能, 註冊 conn, 只運行一次
def get_country():
    conn = psycopg2.connect(host     = os.getenv('POSTGRE_HOST'),
                            database = os.getenv('POSTGRE_DATABASE'),
                            user     = os.getenv('POSTGRE_USER'),
                            password = os.getenv('POSTGRE_PASSWORD'))
    with conn:
        with conn.cursor() as cursor:
            cursor.execute(SQL)
            all_data = cursor.fetchall()
            # print(all_data)
    conn.close()    
    input_dict = dict(all_data)
    values = input_dict.values()
    return values


def user_select():
    print('使用者選擇了:', end='')
    print(st.session_state.stocks)

default_country = '台灣'
st.title('世界大盤分析')
with st.sidebar:
    st.write('請選擇股票市場')
    # st.write('## 台灣')  ## MD語法
    # st.write(dict(all_data))
    st.multiselect('請選擇',
                    get_country(),
                    default=default_country,   # 預設選項
                    placeholder='請選擇市場', #空白時顯示~
                    label_visibility='hidden', # 呈現欄位時不顯示文字 <請選擇> 這3個字
                    key='stocks',
                    on_change=user_select
                    )
    # st.write(default_country)
    # st.write(st.session_state.stocks)
    # 注意 st.session_state.stocks 為 list
    # for l in st.session_state.stocks:
    #     # print(l)
    #     st.write(l)
    
    
df = pd.DataFrame(getData((default_country,)),columns=['國家','代號','日期','收盤價','成交量'])
df['收盤價'] = df['收盤價'].astype('float').round(decimals=2)
st.line_chart(data=df,x='日期',y='收盤價',color='國家')


