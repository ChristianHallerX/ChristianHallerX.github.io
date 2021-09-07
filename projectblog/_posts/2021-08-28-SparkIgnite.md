---
title: ignite Spark tables
image: /assets/img/research/SparkIgnite/SparkIgnite_Cover.jpg
description: > 
  Distributed Warehouse Analysis... Go!
---

0. this unordered seed list will be replaced by toc as unordered list
{:toc}


PySpark can do Pandas-like DataFrame operations, transformation, and ML modeling.

The advantage of Spark is that the instructions get sent out to a cluster that divides the DataFrames into segments, processes them in parallel, and then merges the result back together.

A Spark cluster (made up of nodes) can have much more memory (RAM) than a single machine, which enables processing of vastly larger data sets.

Spark DataFrames are data objects that can be partitioned for submitting to the differnt nodes of a Spark cluster.

The number of partitions can be set when creating a DataFrame.

Spark uses 'Lazy Processing'. This means:
- Entering lazy commands is akin to writing a script that gets executed later.
- Updates to the instructions before processing makes for most efficient planning.

A good start for PySpark is delivered <a href="https://spark.apache.org/docs/latest/api/python/getting_started/index.html" target="_blank">here</a> in the official "Getting Started" guide.

## Create a Spark Session

The SparkContext is the connection to the cluster.
The SparkSession is the interface with that connection.

~~~python
from pyspark.sql import SparkSession

# Create spark session, avoid building a second session
my_spark_session = SparkSession.builder.getOrCreate()
~~~

## Name of the Spark application instance
~~~python
app_name = spark.conf.get('spark.app.name')
print("Name: %s" % app_name)
~~~
>Name: pyspark-shell


## Driver TCP port

The cluster consists of one driver node and one or more worker nodes.

~~~python
driver_tcp_port = spark.conf.get('spark.driver.port')
print("Driver TCP port: %s" % driver_tcp_port)
~~~
>Driver TCP port: 41309

## Number of Join and DataFrame Partitions

Default number of partitions is 200.

~~~python
# Get settings, number of join partitions
spark.conf.get('spark.sql.shuffle.partitions')

# Get numbers of partitions of DataFrame
num_partitions_bef = workers_df.rdd.getNumPartitions()
print("Number of DF partitions before: %s" % num_partitions_bef)

# Change settings, number of join partitions
spark.conf.set('spark.sql.shuffle.partitions', 400)

# Reload DataFrame from file
workers_df = spark.read.csv('departures.txt.gz').distinct()

# Get numbers of partitions of DF again
num_partitions_aft = workers_df.rdd.getNumPartitions()
print("Number of DF partitions after: %s" % num_partitions_aft)
~~~
>Number of DF partitions before: 200

>Number of DF partitions after: 400


### Partition SQL Table by Column values

Partition table by 'part' column values:
~~~python
query = """
SELECT
    part,
    LAG(word, 2) OVER(PARTITION BY part ORDER BY id) AS w1,
    LAG(word, 1) OVER(PARTITION BY part ORDER BY id) AS w2,
    word AS w3,
    LEAD(word, 1) OVER(PARTITION BY part ORDER BY id) AS w4,
    LEAD(word, 2) OVER(PARTITION BY part ORDER BY id) AS w5
FROM 
    text
"""
spark.sql(query).where("part = 12").show(10)
~~~

The 'chapter' column has 12 integer categories.

Repartition DataFrame into 12 partitions on 'chapter' column.

~~~python
repart_df = text_df.repartition(12,'chapter')

# Prove that repart_df has 12 partitions
repart_df.rdd.getNumPartitions()
~~~
>12

## Create Spark DataFrames and (SQL-like) Tables

All DataFrames are temporary at this point.

### Convert Pandas DF to Spark DF

~~~python
# Create a pandas DF with random values
df_temp = pd.DataFrame(np.random.random(10))

# Feed the pandas DF into spark DF (SparkSession object is called "spark")
spark_temp = spark.createDataFrame(df_temp)

# The permanent Table catalog will be empty, the DF is only temporary
print(spark.catalog.listTables())
~~~

### Create Temporary Spark DataFrame from CSV

Shortcut version
~~~python
file_path = "/usr/local/share/datasets/airports.csv"

# Read in the airports data
airports = spark.read.csv(file_path, header=True)

# Show DataFrame
airports.show()
~~~

Long version with extra options
~~~python
# Load the CSV file
aa_dfw_df = spark.read.format('csv').options(Header=True).load('AA_DFW_2018.csv.gz')

# Add the airport column using the F.lower() method
aa_dfw_df = aa_dfw_df.withColumn('airport', F.lower(aa_dfw_df['Destination Airport']))

# Drop the Destination Airport column
aa_dfw_df = aa_dfw_df.drop(aa_dfw_df['Destination Airport'])

# Show the DataFrame
aa_dfw_df.show()
~~~

### Create DataFrame with Schema

When reading without schema, the data type gets inferred and may be incorrect, and it takes more time to read. For optimal speed, create schema.

Pass options to remove invalid rows: .options(mode=’DROPMALFORMED’)

~~~python
from pyspark.sql.types import *

# Define a new schema using the StructType method
schema = StructType([StructField("brand", StringType(), nullable=False),
	StructField("model", StringType(), nullable=False),
	StructField("absorption_rate", ByteType(), nullable=True),
	StructField("comfort", ByteType(), nullable=True)
])
df = spark.read.options(header="true", mode=’DROPMALFORMED’).schema(schema).csv("/home/repl/workspace/mnt/lake/inbound/ratings.csv")

pprint(df.dtypes)
~~~
>[('brand', 'string'),
>('model', 'string'),
>('absorption_rate', 'tinyint'),
>('comfort', 'tinyint')]


~~~python
from pyspark.sql.types import *

# Define a new schema using the StructType method
people_schema = StructType([
	# Define a StructField for each field
	StructField('name', StringType(), nullable=False),
	StructField('age', IntegerType(), nullable=False),
	StructField('city',StringType(),nullable=False)
])
~~~

### DataType overview

| DataType      | Value Type in Python              |
|---------------|-----------------------------------|
| ByteType()    | Numbers -128 to 127               |
| ShortType()   | Numbers -32768 to 32767           |
| IntegerType() | Numbers -2147483648 to 2147483647 |
| FloatType()   | Floating point number             |
| StringType()  | String                            |
| BooleanType() | bool (True, False, 0, 1)          |
| DateType()    | datetime.date                     |


### View DataFrame schema

Show the columns in a DataFrame and their data types.

~~~python
split_df.printSchema()
~~~

### Save DataFrame to File

Shortcut version
~~~python
df.write.parquet('filename.parquet')
~~~

Long version with extra options
~~~python
df.write.format('parquet').save('filename.paruqet')
~~~


## DataFrames and SQL-like Tables

### Register Spark DataFrame in SQL Table Catalog

After registering the table, we can run .sql() methods with queries against it. 

~~~python
# Add spark_temp to the catalog
temp_df.createOrReplaceTempView("my_sqltable")
~~~

### SQL query against Spark table

~~~python
# write a query string
query = "FROM flights SELECT * LIMIT 10"

# apply query string with .sql() method to the session object
flights10 = my_spark_session.sql(query)

# print results table in console
flights10.show()
~~~

|year|month|day|dep_time|dep_delay|arr_time|arr_delay|carrier|tailnum|flight|origin|dest|air_time|distance|hour|minute|
|----|-----|---|--------|---------|--------|---------|-------|-------|------|------|----|--------|--------|----|------|
|2014|   12|  8|     658|       -7|     935|       -5|     VX| N846VA|  1780|   SEA| LAX|     132|     954|   6|    58|
|2014|    1| 22|    1040|        5|    1505|        5|     AS| N559AS|   851|   SEA| HNL|     360|    2677|  10|    40|
|2014|    3|  9|    1443|       -2|    1652|        2|     VX| N847VA|   755|   SEA| SFO|     111|     679|  14|    43|


### Query SQL Table and save to Pandas DF

~~~python
# write a query string
query = "SELECT origin, dest, COUNT(*) as N FROM flights GROUP BY origin, dest"

# apply query string with .sql() method to the session object
flight_counts = spark.sql(query)

# convert the results to a pandas DataFrame
pd_counts = flight_counts.toPandas()

# print results pandas DF
pd_counts.head()
~~~

~~~python
long_films_df = spark.sql('SELECT * FROM my_sqltable WHERE filmduration >100')
~~~

Load file to DataFrame, register table, then query the table.
~~~python
# Read the Parquet file into films_df
films_df = spark.read.parquet('films.parquet')

# Register the temp table
films_df.createOrReplaceTempView('films')

# Run a SQL query of the average film duration
avg_duration = spark.sql('SELECT AVG(film_duration) from films').collect()[0]
print('The average film time is: %d' % avg_duration)
~~~
> The average film time is: 88

### Describe an SQL Table

~~~python
spark.sql("DESCRIBE schedule").show()
~~~

|col_name|data_type|comment|
|--------|---------|-------|
|train_id|   string|   null|
| station|   string|   null|
|    time|   string|   null|


### List SQL Table Catalog

~~~python
print(spark.catalog.listTables())
~~~
>[Table(name='my_sqltable', database=None, description=None, tableType='TEMPORARY', isTemporary=True)]


## Column and Value Manipulation

### Remove Missing Values in a Column with .fillna()

All null values in column 'comfort' will be filled with default value "4".

~~~python
ratings = ratings.fillna(4, subset=["comfort"])
~~~

### Categorization/binning of Column Values .withColumn() and .when()

~~~python
from pyspark.sql.functions import col, when

categorized_ratings = ratings.withColumn("comfort", when(ratings.comfort > 3, "sufficient").otherwise("insufficient"))

categorized_ratings.show()
~~~

### Creating new Columns / Computation with .withColumn()

Spark DataFrames are immutable. We need to overwrite the old DF.
That means creating new column based on old column

~~~python
# Create the DataFrame flights
flights = spark.table("flights")

# Show prints 20 rows
flights.show()

# Add new column ‘duration_hrs’ using method .withColumn()
flights = flights.withColumn("duration_hrs", flights.air_time / 60)
~~~

### Select Columns with .select()

Keep specified columns only.

~~~python
# string style
selected1 = flights.select("tailnum","origin","dest")

# boolean style
selected2 = flights.select(flights.origin, flights.dest, flights.carrier)
~~~

### Drop Columns with .drop()

~~~python
flights.drop("superfluous_column")
~~~

### Select Columns and use SQL statements with .selectExpr()

The SQL expression is passed as string.

~~~python
speed_df = flights.selectExpr("origin", "dest", "tailnum", "distance/(air_time/60) as avg_speed")
~~~

### Rename Columns I: .alias()

~~~python
flights = flights.select((flights.air_time/60).alias("duration_hrs"))
~~~

### Rename Columns II: .withColumnRenamed()

Overwrite original DF. 'worked_df.withColumnRenamed(“old_name”, “new_name”)’

~~~python
airports = airports.withColumnRenamed("faa", "dest")
~~~

### Aggregation with .groupBy() and .min() .max() .avg()

Group by month and destination, calculate average departure delay of the groups.

~~~python
flights.groupBy("month", "dest").avg(“dep_delay”).show()
~~~

|month|dest|      avg(dep_delay)|
|-----|----|--------------------|
|   11| TUS| -2.3333333333333335|
|   11| ANC|   7.529411764705882|
|    1| BUR|               -1.45|
|    1| PDX| -5.6923076923076925|
|    6| SBA|                -2.5|


### Keep specified values rows with .filter()

String and Boolean column both produce the same results.
Similar to SQL’s 'WHERE' clause.

~~~python
# passing a string (weird)
long_flights1 = flights.filter("distance > 1000")
long_flights1.show()

# passing a column of boolean values
long_flights2 = flights.filter(flights.distance > 1000)
long_flights2.show()

# remove missing (Null, NaN) values in multiple columns
long_flights3 = long_flights.filter("arr_delay is not NULL and dep_delay is not NULL and air_time is not NULL and plane_year is not NULL")

# filter for strings starting with specified letter (regex-like)
long_flights4 = long_flights.filter(long_flights.airline.like('A%'))
~~~


Filter for flights with origin PDX and select minimum distance
~~~python
flights.filter(flights.origin == "PDX").groupBy().min('distance').show()
~~~

|min(distance)|
|-------------| 
|106| 

Filter for all flights with origin SEA and select maximum air time
~~~python
flights.filter(flights.origin == "SEA").groupBy().max('air_time').show()
~~~

|max(air_time)|
|-------------|
|409|

Filter carriers for Delta (DL) and origin SEA then calculate average air time (flight duration)
~~~python
flights.filter(flights.carrier == "DL").filter(flights.origin == "SEA").groupBy().avg("air_time").show()
~~~

|avg(air_time)|
|-------------|
|188.20689655172413|


Duration hours (divide by 60 mins) and sum up entire column
~~~python
# Total hours in the air
flights.withColumn("duration_hrs", flights.air_time/60).groupBy().sum("air_time").show()
~~~

|sum(air_time)|
|-------------|
|1517376|


Aggregate three columns of the purchased df and alias two of them.
~~~python
from pyspark.sql.functions import col, avg, stddev_samp, max as sfmax

aggregated_df = (purchased.groupBy(col('Country'))
 .agg(avg('Salary').alias('average_salary'),
         stddev_samp('Salary'),
         sfmax('Salary').alias('highest_salary')
              		         )
 )

aggregated.show()
~~~

|Country|average_salary|stddev_samp(Salary)|highest_salary| 
|-------|--------------|-------------------|--------------|
|Germany|       63000.0|                NaN|         63000| 
| France|       48000.0|                NaN|         48000|
|  Spain|       62000.0| 12727.922061357855|         71000|


## Special Functions F

String to upper case
~~~python
import pyspark.sql.functions as F

film_df.withColumn('upper', F.upper('name')
~~~

Split Strings
~~~python
import pyspark.sql.functions as F

film_df.withColumn('split_string', F.split('film_name', ' '))
~~~


.agg() and F.stddev
~~~python
# Standard deviation of departure delay
by_month_dest.agg(F.stddev("dep_delay")).show()
~~~

|month|dest|stddev_samp(dep_delay)|
|-----|----|----------------------|
|   11| TUS|    3.0550504633038935|
|   11| ANC|    18.604716401245316|
|    1| BUR|     15.22627576540667|


### Add an ID column

The are IDs generated as Int64, contain gaps (non sequential), but retain parallelization across a cluster.

Important Note: DataFrames with many partitions will get much more more digits in the IDs.

~~~python
import pyspark.sql.functions as F

worker_df = worker_df.withColumn('ROW_ID', F.monotonically_increasing_id())
~~~


### User-Defined Functions udf()

We can wrap one of your own Python functions into a udf() and apply it to a Spark DF's column.

~~~python
import pyspark.sql.functions as F
import pyspark.sql.types

# Define a python function
def reverseName(name):
  return name[::-1]

# Store function as a UDF -> python function and data type definition
udfReverseName = F.udf(reverseName, StringType())

# Create a new column using the UDF
workerr_df = worker_df.withColumn('worker_name_reversed', udfReverseName(worker_df.worker_name))

worker_df.show()
~~~

|      date|    job_title|        worker_name| worker_name_reversed|
|----------|-------------|-------------------|---------------------|
|02/08/2019|     engineer|       Jen M. Gates|         setaG .M neJ|
|02/08/2019|     engineer|  Pippa F. Kingston|    notsgniK .F appiP|
|02/08/2019|     director|   Mike S. Rawlings|     sgnilwaR .S ekiM|


### If/When statements with inline methods

Add a column with random numbers for workers with the title *engineer* using .when()
~~~python
worker_df = worker_df.withColumn('random_val',
				when(worker_df.job_title=='engineer', F.rand())
				)

worker_df.show()
~~~

|      date|    job_title|        worker_name|         random_val|
|----------|-------------|-------------------|-------------------|
|02/08/2019|     engineer|       Jen M. Gates| 0.4420037036681319|
|02/08/2019|     engineer|  Pippa F. Kingston| 0.9169317912957646|
|02/08/2019|     director|   Mike S. Rawlings|               null|


Add a column with multiple chained .when() clauses. 
The role of 'else' in Python is taken by .otherwise().

~~~python
worker_df = worker_df.withColumn('random_val',
				when(voter_df.TITLE == 'engineer', F.rand())
				.when(voter_df.TITLE == 'director', 2)
				.otherwise(0)
				)

worker_df.show()
~~~

|      date|    job_title|        worker_name|          random_val|
|----------|-------------|-------------------|--------------------|
|02/08/2019|     engineer|       Jen M. Gates|  0.0473898980592975|
|02/08/2019|     engineer|  Pippa F. Kingston|  0.1810667508308076|
|02/08/2019|     director|   Mike S. Rawlings|                 2.0|
|02/08/2019|     engineer|      Alvaro Verano|  0.4672294882395198|


## Caching

### Caching DataFrames with .cache()

Creating local caches for DataFrames that get called repeatedly can help improving speed.

~~~python
# Set start time
start_time1 = time.time()

# Add caching to df
workers_df = workers_df.distinct().cache()

# Print how long counting took when reading first time. This time without pre-cached material takes longer.
print("Counting %d rows took %f seconds" % (workers_df.count(), time.time() - start_time1))

# Do it again, this time it will be faster
start_time2 = time.time()
print("Counting %d rows again took %f seconds" % (workerss_df.count(), time.time() - start_time2))
~~~
>Counting 319532 rows took 2.255696 seconds

>Counting 319532 rows again took 0.404590 seconds


### Checking and Removing DataFrames from Cache

~~~python
# Check status
print("Is workers_df cached?: %s" % workers_df.is_cached)

# Remove caching
workers_df.unpersist()

# Check status again
print("Is workers_df cached?: %s" % workers_df.is_cached)
~~~
>Is workers_df cached?: True \\ Is workers_df cached?: False


## Broadcasting in Joins

Broadcasting distributed the entire dataframe that is selected to all workers.
This can expedite up join commands.

~~~python
from pyspark.sql.functions import broadcast

# Join the trains_rides_df and stations_df DataFrames using broadcasting
broadcast_df = train_rides_df.join(broadcast(stations_df), \
    train_rides_df["Arrival Station"] == stations_df["Station_Name"] )

# Show the query plan and compare against the original
broadcast_df.explain()
~~~

## Pipelines

Creating a pipeline can simplify and formalize preprocessing of training data and the ML model training. Using them avoids mistakes in repetition.

<a href="https://spark.apache.org/docs/3.1.2/ml-pipeline.html#pipeline-components" target="_blank">https://spark.apache.org/docs/3.1.2/ml-pipeline.html#pipeline-components</a>

Create a pipeline from a workflow such as this:

~~~python
departures_df = spark.read.csv('2015-departures.csv.gz', header=True)

# get column id from printSchema()
departures_df.printSchema()

# Remove any duration of 0 -> where the column has null rows
departures_df = departures_df.drop(departures_df[departures_df.columns[3]].isNull())

# Add an ID column
departures_df = departures_df.withColumn('ID', F.monotonically_increasing_id())

# Write the file
departures_df.write.json('output_file.json', mode='overwrite')
~~~


### Casting DataFrame columns

- ML modeling requires exclusively numeric input.
- All string columns need to be cast to integer or double.
- Linear data has to be categorized.


~~~python
spark_df = spark_df.withColumn(“col_name”, spark_df.col_name.cast(“integer”))
~~~

'double' = double precision float
'integer' = integer


### Joining Columns .join()

~~~python
first_df.join(second_df, on=”key”, how=”leftinner”)'
~~~


### One-Hot-Encoding (StringIndexer, OneHotEncoder)

StringIndexer() takes a column’s strings and converts it to categorical integers '1', '2', '3', '4'....
~~~python
from pyspark.ml.feature import StringIndexer

carr_indexer = StringIndexer(inputCol="Carrier", outputCol="carrier_index")
~~~

<a href="https://spark.apache.org/docs/latest/ml-features#stringindexer" target="_blank">https://spark.apache.org/docs/latest/ml-features#stringindexer</a>



OneHotEncoder() takes a categorical numbers and expands it into category columns and '1' / '0' categories.
~~~python
from pyspark.ml.feature import OneHotEncoder

carr_encoder = OneHotEncoder(inputCol="carrier_index", outputCol="carrier_fact")
~~~

<a href="https://spark.apache.org/docs/latest/ml-features#onehotencoder" target="_blank">https://spark.apache.org/docs/latest/ml-features#onehotencoder</a>

### VectorAssembler

Before running ML training, all feature columns need to be converted to a single vector column.
~~~python
from pyspark.ml.feature import VectorAssembler

vec_assembler = VectorAssembler(inputCols=["month", "air_time", "carrier_fact", "dest_fact", "plane_age"],
				outputCol="features"
				)
~~~

<a href="https://spark.apache.org/docs/latest/ml-features#vectorassembler" target="_blank">https://spark.apache.org/docs/latest/ml-features#vectorassembler</a>

### ML Pipeline stages with Pipeline()

The Pipeline “stages” argument holds a list of all the stages the data goes through. All these stage objects have to be defined beforehand and now are brought in order.
~~~python
from pyspark.ml import Pipeline

flights_pipe = Pipeline(stages=[dest_indexer, dest_encoder, carr_indexer, carr_encoder, vec_assembler])
~~~

<a href="https://spark.apache.org/docs/latest/ml-features#vectorassembler" target="_blank">https://spark.apache.org/docs/latest/ml-features#vectorassembler</a>

#### Fit and Transform Pipeline

The pipeline now gets applied with fit and transform.
The DataFrame gets passed as argument to both.
~~~python
piped_data = flights_pipe.fit(model_data).transform(model_data)
~~~

### Train-Test Split

IMPORTANT: split after the StringIndexer ran, otherwise the train and test sets may end up with different codes for the same category.
Train: 60%, Test:  40%
~~~python
training, test = piped_data.randomSplit([.6, .4])
~~~
