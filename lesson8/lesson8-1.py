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
    

# print(os.getenv('POSTGRE_HOST'))

# print('--------')
# print()
# sys.exit(-1)


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

with conn:
    with conn.cursor() as cursor:
        cursor.execute(SQL)
        all_data = cursor.fetchall()
        # print(all_data)
conn.close()

# print(all_data)
# print(type(all_data))

# input_dict = dict(all_data)
# print(input_dict)
# print(type(input_dict))

# print('....')
# input_dict_items = input_dict.items()
# print(input_dict_items)
# print(type(input_dict_items))

# input_dict_keys = input_dict.keys()
# print(input_dict_keys)
# print(type(input_dict_keys))

# input_dict_values = input_dict.values()
# print(input_dict_values)
# print(type(input_dict_values))

# print('----')
# streamlit 開始 ---------

print(sys.argv[0])
# if sys.argv[0] != 'run':
#     print('Not run in stream lit. will finish immediately.')
#     sys.exit(0)

st.title('世界大盤分析')

def user_select():
    print('on_change~~')
    print(options)


with st.sidebar:
    st.write('請選擇股票市場')
    # st.write('## 台灣')  ## MD語法
    # st.write(dict(all_data))
    input_dict = dict(all_data)
    options = st.multiselect('請選擇',
                             input_dict.values(),
                             default='台灣',   # 預設選項
                             placeholder='請選擇市場', #空白時顯示~
                             label_visibility='hidden', # 呈現欄位時不顯示文字 <請選擇> 這3個字
                             on_change=user_select
                             )
    st.write(options)
