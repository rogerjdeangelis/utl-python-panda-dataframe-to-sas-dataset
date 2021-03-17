Panda dataframe to sas dataset

   1. I was unable to create a SAS table directly in python using the Carolina S-JDBC driver
   2. I was unable to read a pyhton 'feather' file in R ( this would be faster)

 Method
    1. Export a Panda dataframe to an R datafrima file (R Rds type file).
    2. Convert the Rds file created in python to an R dataframe.
    3. Create a SAS dataset from the python to R dataframe.

GitHub
https://tinyurl.com/c8efpsty
https://github.com/rogerjdeangelis/utl-python-panda-dataframe-to-sas-dataset

*_                   _
(_)_ __  _ __  _   _| |_
| | '_ \| '_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
;

libname sd1 'd:/sd1';
options validvarname=upcase;
data sd1.class;
  set sashelp.class(obs=10);
run;quit;

/*
SD1.CLASS total obs=10

Obs    NAME       SEX    AGE    HEIGHT    WEIGHT

  1    Joyce       F      11     51.3       50.5
  2    Louise      F      12     56.3       77.0
  3    Alice       F      13     56.5       84.0
...
*/

*
 _ __  _ __ ___   ___ ___  ___ ___
| '_ \| '__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
;


%utlfkil("d:/sd1/want.sas7bdat");
%utlfkil("d:/rds/have.Rds");

* PYTHON - Create R Rds file;

%utl_submit_py64_38('
import pandas as pd;
import numpy as np;
import pandas as pd;
import pyreadstat;
import pyreadr;
have, meta = pyreadstat.read_sas7bdat("d:/sd1/class.sas7bdat");
have;
pyreadr.write_rds("d:/rds/have.Rds",have);
');

* R - Rds file from Python to SAS dataset;

%utl_submit_r64(%tslit(
library(RJDBC);
library(haven);
want <- readRDS("d:/rds/have.Rds");
drv<- JDBC("com.dullesopen.jdbc.Driver","d:/carolina/carolina-jdbc-2.4.3.jar");
conn <- dbConnect(drv, "jdbc:carolina:bulk:libnames=(dir='d:/sd1')", "", "");
colnames(iris)=c("SepalLength", "SepalWidth", "PetalLength", "PetalWidth", "Species");
head(want);
rc<- dbWriteTable(conn,"want",want);
));

proc print data=sd1.want;
run;quit;

*            _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| '_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|
;
SD1.WANT total obs=10

Obs    NAME       SEX    AGE    HEIGHT    WEIGHT

  1    Joyce       F      11     51.3       50.5
  2    Louise      F      12     56.3       77.0
  3    Alice       F      13     56.5       84.0
  4    James       M      12     57.3       83.0
  5    Thomas      M      11     57.5       85.0
  6    John        M      12     59.0       99.5
  7    Jane        F      12     59.8       84.5
  8    Janet       F      15     62.5      112.5
  9    Jeffrey     M      13     62.5       84.0
 10    Carol       F      14     62.8      102.5





