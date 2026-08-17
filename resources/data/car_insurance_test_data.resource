*** Settings ***
Documentation       Reusable vehicle and insurant profiles for the car insurance quote
...                 wizard tests. Values satisfy the live application's validation rules
...                 confirmed during development (e.g. list price/annual mileage ranges,
...                 minimum street length, insurant age between 18 and 70).


*** Variables ***
&{VEHICLE_MERCEDES_BENZ}    make=Mercedes Benz
...                         engine_performance=68
...                         manufacture_date=08/25/2023
...                         seats=7
...                         fuel=Diesel
...                         list_price=50000
...                         annual_mileage=32185
&{VEHICLE_VOLKSWAGEN}       make=Volkswagen
...                         engine_performance=75
...                         manufacture_date=01/15/2022
...                         seats=5
...                         fuel=Petrol
...                         list_price=28000
...                         annual_mileage=15000
&{VEHICLE_BMW}              make=BMW
...                         engine_performance=140
...                         manufacture_date=03/10/2021
...                         seats=5
...                         fuel=Diesel
...                         list_price=45000
...                         annual_mileage=20000

&{INSURANT_JANE_DOE}        first_name=Jane
...                         last_name=Doe
...                         birthdate=05/14/1990
...                         gender=Female
...                         street=Baker Street 221B
...                         zip_code=10115
...                         city=Berlin
&{INSURANT_JOHN_SMITH}      first_name=John
...                         last_name=Smith
...                         birthdate=01/01/1985
...                         gender=Male
...                         street=Main Street 1
...                         zip_code=10115
...                         city=Berlin
