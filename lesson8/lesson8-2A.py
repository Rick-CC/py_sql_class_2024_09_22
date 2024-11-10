import streamlit as st
# 連線到 raspberry 
import psycopg2
from dotenv import load_dotenv, find_dotenv
import os
import sys
success = load_dotenv()

if success:
    #print("成功載入 .env 檔案\n")
    pass
else:
    load_dotenv(find_dotenv(f'.env.raspberry'))
    #load_dotenv(find_dotenv(f'.env.render'))



#把敏感資料改成從 .env檔案 讀取
conn = psycopg2.connect(host     = os.getenv('POSTGRE_HOST'),
                        database = os.getenv('POSTGRE_DATABASE'),
                        user     = os.getenv('POSTGRE_USER'),
                        password = os.getenv('POSTGRE_PASSWORD'))


SQL_old = '''
SELECT country,市場.name,date,adj_close,volume
FROM 股市 join 市場 on 股市.name=市場.name
WHERE country='台灣';
'''
SQL = '''
SELECT *
FROM 市場;
'''
SQL_all_data_TWII =  '''
SELECT country,市場.name,date,adj_close,volume
FROM 股市 JOIN 市場 ON 股市.name = 市場.name
WHERE country = '台灣';
'''

SQL_all_data_HSI = '''
SELECT country,市場.name,date,adj_close,volume
FROM 股市 join 市場 on 股市.name=市場.name
WHERE country='香港恆生';
'''

@st.cache_data  #<--------- 加入此功能, 註冊 conn, 只運行一次
def get_country():
    with conn:
        with conn.cursor() as cursor:
            cursor.execute(SQL)
            all_data = cursor.fetchall()
            # print(all_data)
    conn.close()    
    input_dict = dict(all_data)
    values = input_dict.values()
    return values

@st.cache_data  #<--------- 加入此功能, 註冊 conn, 只運行一次
def getData():
    with conn:
        with conn.cursor() as cursor:
            cursor.execute(SQL_all_data_TWII)
            all_data = cursor.fetchall()
    conn.close()
    return all_data

print(getData())

st.title('世界大盤分析')

def user_select():
    print('使用者選擇了:', end='')
    print(st.session_state.stocks)


with st.sidebar:
    st.write('請選擇股票市場')
    # st.write('## 台灣')  ## MD語法
    # st.write(dict(all_data))
    default_country = '台灣'
    
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
    
    
