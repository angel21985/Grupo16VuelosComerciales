import pandas as pd
import numpy as np
from sqlalchemy import create_engine
import MySQLdb
#pip install mysqlclient
#pip install sqlalchemy

# se importan los csv
plane_data = pd.read_csv('dirty_csv/plane-data.csv')
airlines = pd.read_csv('dirty_csv/airlines.csv')
airports = pd.read_csv('dirty_csv/airports.csv')
flights = pd.read_csv('dirty_csv/flights.csv')
available_seat = pd.read_csv('dirty_csv/available_seat.csv', sep=';')
revenue_passenger = pd.read_csv('dirty_csv/revenue_passenger.csv', sep=';')

# limpieza y normalizacion de los datos
plane_data.loc[plane_data.year=='None','year']=np.nan
plane_data.year = plane_data.year.astype(np.float).astype("Int32")
newCode = flights.TAIL_NUMBER
newCode.drop_duplicates(inplace=True)
newCode = newCode[~newCode.isin(plane_data.tailnum)]
plane_data = plane_data.append([{"tailnum": v} for v in newCode], ignore_index=True)

airlines.columns = ['IATA_CODE_AIRLINE','AIRLINE']
newCode = flights.AIRLINE
newCode.drop_duplicates(inplace=True)
newCode = newCode[~newCode.isin(airlines.IATA_CODE_AIRLINE)]
airlines = airlines.append([{"IATA_CODE_AIRLINE": v} for v in newCode], ignore_index=True)

airports.IATA_CODE = airports.IATA_CODE.astype('str')
newCode = flights.ORIGIN_AIRPORT
newCode = newCode.astype('str')
newCode.drop_duplicates(inplace=True)
newCode = newCode[~newCode.isin(airports.IATA_CODE)]
airports = airports.append([{"IATA_CODE": v} for v in newCode], ignore_index=True)
newCode = flights.DESTINATION_AIRPORT
newCode = newCode.astype('str')
newCode = newCode[~newCode.isin(airports.IATA_CODE)]
airports = airports.append([{"IATA_CODE": v} for v in newCode], ignore_index=True)
airports = airports.rename(columns={'IATA_CODE':'IATA_CODE_AIRPORT'})

flights.reset_index(inplace=True)
flights['IdDate'] = flights.YEAR*10000+flights.MONTH*100+flights.DAY
flights['IdFlight'] = flights.IdDate.map(str)+flights.index.map(str) 
flights = flights.rename(columns={'AIRLINE':'IATA_CODE_AIRLINE'})
flights = flights.drop(columns=['FLIGHT_NUMBER','TAXI_OUT','TAXI_IN','WHEELS_ON','WHEELS_OFF','index'])
flights1 = flights.iloc[0:1000000]
flights2 = flights.iloc[1000000:2000000]
flights3 = flights.iloc[2000000:3000000]
flights4 = flights.iloc[3000000:4000000]
flights5 = flights.iloc[4000000:5000000]
flights6 = flights.iloc[5000000:]

available_seat = available_seat.loc[available_seat.Month != 'TOTAL', :]
available_seat.Month = available_seat.Month.map({'1':'01','2':'02','3':'03','4':'04','5':'05','6':'06','7':'07','8':'08','9':'09','10':'10','11':'11','12':'12'},na_action=None)
available_seat['IdPeriod'] = available_seat.Year.map(str)+available_seat.Month
available_seat.DOMESTIC = available_seat['DOMESTIC'].str.replace(",", "")
available_seat.INTERNATIONAL = available_seat['INTERNATIONAL'].str.replace(",", "")
available_seat.TOTAL = available_seat['TOTAL'].str.replace(",", "")
available_seat.Month = available_seat.Month.astype('int')
available_seat.DOMESTIC = available_seat.DOMESTIC.astype('int')
available_seat.INTERNATIONAL = available_seat.INTERNATIONAL.astype('int')
available_seat.TOTAL = available_seat.TOTAL.astype('int')
available_seat.IdPeriod = available_seat.IdPeriod.astype('int')

revenue_passenger = revenue_passenger.loc[revenue_passenger.Month != 'TOTAL', :]
revenue_passenger.Month = revenue_passenger.Month.map({'1':'01','2':'02','3':'03','4':'04','5':'05','6':'06','7':'07','8':'08','9':'09','10':'10','11':'11','12':'12'},na_action=None)
revenue_passenger['IdPeriod'] = revenue_passenger.Year.map(str)+revenue_passenger.Month
revenue_passenger.DOMESTIC = revenue_passenger['DOMESTIC'].str.replace(",", "")
revenue_passenger.INTERNATIONAL = revenue_passenger['INTERNATIONAL'].str.replace(",", "")
revenue_passenger.TOTAL = revenue_passenger['TOTAL'].str.replace(",", "")
revenue_passenger.Month = revenue_passenger.Month.astype('int')
revenue_passenger.DOMESTIC = revenue_passenger.DOMESTIC.astype('int')
revenue_passenger.INTERNATIONAL = revenue_passenger.INTERNATIONAL.astype('int')
revenue_passenger.TOTAL = revenue_passenger.TOTAL.astype('int')
revenue_passenger.IdPeriod = revenue_passenger.IdPeriod.astype('int')

# se envian los datos a mysql(rds)
engine = create_engine("mysql://admin:henry-grupo16@database-grupo16.c1j3dywqwwns.us-east-1.rds.amazonaws.com:3306/vuelosComerciales")

plane_data.to_sql(con=engine,name='plane_data',if_exists='append',index=False)
airlines.to_sql(con=engine,name='airline',if_exists='append',index=False)
airports.to_sql(con=engine,name='airport',if_exists='append',index=False)
available_seat.to_sql(con=engine,name='available_seat',if_exists='append',index=False)
revenue_passenger.to_sql(con=engine,name='revenue_passenger',if_exists='append',index=False)
flights1.to_sql(con=engine,name='flight_2015',if_exists='append',index=False)
flights2.to_sql(con=engine,name='flight_2015',if_exists='append',index=False)
flights3.to_sql(con=engine,name='flight_2015',if_exists='append',index=False)
flights4.to_sql(con=engine,name='flight_2015',if_exists='append',index=False)
flights5.to_sql(con=engine,name='flight_2015',if_exists='append',index=False)
flights6.to_sql(con=engine,name='flight_2015',if_exists='append',index=False)

#plane_data.to_csv('clean_csv/plane-data.csv')
#airlines.to_csv('clean_csv/airlines.csv')
#airports.to_csv('clean_csv/airports.csv')
#flights.to_csv('clean_csv/flights.csv')
#available_seat.to_csv('clean_csv/available_seat.csv')
#revenue_passenger.to_csv('clean_csv/revenue_passenger.csv')

