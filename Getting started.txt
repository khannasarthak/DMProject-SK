Please follow the steps to get up and running with the project.

Data generation and table population
1. Requirements:
	I. Python 2.7
	II. Libraries 
		a. Pandas ( pip install pandas )
		b. Faker ( pip install Faker )
2. Run the script datagen.py, it will generate 10 CSV's.
3. Place the CSV's generated in a folder name 'DBMS_Project' and place this folder in the  drive ( this is because we were unable to have
	 a relative location in the MySQL script. )
	Path - C:/DBMS_Project

4. Execute the DDLqueries.sql file and given that the CSV's are located in the corerct place, the database will be generated and 
	the tables will be populated with the data.

5. Execute any queries on the database.

Folder Strcuture:

1. The folder "Flask App" contains the web implementation of the project.

2. 'Phase_3_DML' contains the queries that we are implementing on the web app.

3. 'Phase_3_tables' contains the CSV's that were generated from the datagen.py script and these are being used to populate the tables.

4. The file 'DDLqueries' is defining the schema, creating tables and importing the data. 





	
	