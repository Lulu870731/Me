import pandas as pd
import requests
from bs4 import BeautifulSoup
import pymysql


db_config={
    "host":"127.0.0.1",
    "user":"root",
    "password":"0000",
    "database":"data",  #schema名稱
    "charset":"utf8"
}
# 插入資料
def insert_data(table,data):
    try:
        con=pymysql.connect(**db_config)
        cursor=con.cursor()

        if table=="stockprice_up":
            sql=f"""
            INSERT INTO {table} (stock_name,title2,stockprice_up,total_up2,open_price,close_price,trading_price,time)
            VALUES(%s,%s,%s,%s,%s,%s,%s,%s)
            """
        else:  #table=="stockprice_down"
            sql=f"""
                    INSERT INTO {table} (stock_name,title2,stockprice_down,total_down2,open_price,close_price,trading_price,time)
                    VALUES(%s,%s,%s,%s,%s,%s,%s,%s)
                    """
       
        for record in data:
            if table == "stockprice_up":
                cursor.execute(sql, (
                    record.get("股名"),
                    record.get("股號"),
                    record.get("股價(漲價)"),
                    record.get("漲多少"),
                    record.get("開盤"),
                    record.get("收盤"),
                    record.get("成交量"),
                    record.get("時間")
                ))
            else:  
                cursor.execute(sql, (
                    record.get("股名"),
                    record.get("股號"),
                    record.get("股價(降價)"),
                    record.get("降多少"),
                    record.get("開盤"),
                    record.get("收盤"),
                    record.get("成交量"),
                    record.get("時間")
                ))
        con.commit()
        print(f"{table}資料插入完成，共{len(data)}筆")
    except pymysql.MySQLError as e:
        print(f"插入資料時發生錯誤:{e}")
    finally:
        cursor.close()
        con.close()
def get_stock():
    #呼叫網頁
    url='https://tw.stock.yahoo.com/markets'
    headers={'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36'}

    #發送請求
    response=requests.get(url, headers=headers)
    soup=BeautifulSoup(response.text, 'html.parser') #parser 是解析器
    list1=soup.find_all('li', class_='List(n)') #端詳規則每筆資料名稱是List(n)

    #初始化
    stock_up=[]
    stock_down=[]
    data_list=[]
    data_list2=[]

    for j in list1:
        data={}
        data2={}
        stock_name=j.find('div', class_='Lh(20px) Fw(600) Fz(16px) Ell')
        title2=j.find('span', class_='Fz(14px) C(#979ba7) Ell')
        stockprice_up=j.find('span', class_='Jc(fe) Fw(600) D(f) Ai(c) C($c-trend-up)')#上升的股價
        stockprice_down=j.find('span', class_='Jc(fe) Fw(600) D(f) Ai(c) C($c-trend-down)')#降價的股價
        total_up2=j.find('span', class_='Fw(600) Jc(fe) D(f) Ai(c) C($c-trend-up)')#總共漲多少
        total_down2=j.find('span', class_='Fw(600) Jc(fe) D(f) Ai(c) C($c-trend-down)')#總共降多少
        time=j.find('div', class_='Fxs(1) Fxb(0%) Ta(end) Mend($m-table-cell-space) Mend(0):lc Miw(48px) Fxg(0)')#交易時間

        # 找到所有的span元素
        price_spans=j.find_all('span', class_='Jc(fe)')

        # 篩選列表
        if len(price_spans)>= 6:
            open_price=price_spans[3].text
            close_price=price_spans[4].text
            trading_price=price_spans[5].text
        else:
            open_price=close_price=trading_price=None

        #檢查數據
        if stock_name and title2 and ((stockprice_up and total_up2) or (stockprice_down and total_down2)) and open_price and close_price and trading_price and time:
            if stockprice_up and total_up2:
                stock_up.append((stock_name.text title2.text,stockprice_up.text,total_up2.text,open_price,close_price,trading_price,time.text))
                data['股名']=stock_name.text
                data['股號']=title2.text
                data['股價(漲價)']=stockprice_up.text
                data['漲多少']=total_up2.text
                data['開盤']=open_price
                data['收盤']=close_price
                data['成交量']=trading_price
                data['時間']=time.text
                data_list.append(data)
            elif stockprice_down and total_down2:
                stock_down.append((stock_name.text,title2.text,stockprice_down.text,total_down2.text,open_price,close_price,trading_price,time.text))
                data2['股名']=stock_name.text
                data2['股號']=title2.text
                data2['股價(降價)']=stockprice_down.text
                data2['降多少']=total_down2.text
                data2['開盤']=open_price
                data2['收盤']=close_price
                data2['成交量']=trading_price
                data2['時間']=time.text
                data_list2.append(data2)
        #寫入資料庫
    insert_data("stockprice_up", data_list)
    insert_data("stockprice_down", data_list2)
    #with open('stock.json','w',encoding='utf-8') as f:
    # json.dump(data_list,f,ensure_ascii=False, indent=4)
    print('success')
    #列印
    #print("股票漲價：")
    for stock in stock_up:
        a=f"{stock[0]} {stock[1]}: {stock[2]} (股價), {stock[3]} (total Up), {stock[4]} (開盤價), {stock[5]} (收盤價), {stock[6]} (成交量), {stock[7]} (交易時間)"
        #print(a)
    print(data_list)
    df = pd.DataFrame(data_list)
    df.to_excel('漲價的股票.xlsx',index=False,engine='openpyxl')
    #print("\n股票降價：")
    for stock in stock_down:
        b=f"{stock[0]} {stock[1]}: {stock[2]} (股價), {stock[3]} (total Down), {stock[4]} (開盤價), {stock[5]} (收盤價), {stock[6]} (成交量), {stock[7]} (交易時間)"
        #print(b)
    print(data_list2)
    df = pd.DataFrame(data_list2)
    df.to_excel('降價的股票.xlsx',index=False,engine='openpyxl')

#儲存MySQL
get_stock()
