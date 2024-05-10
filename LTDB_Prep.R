# Title: 
# Author:
# Email:
# Date:

# Script Name:

# Description:

# Notes:

# Working Environment Setup

# Load required libraries
load_packages <- c("gt", "tidycensus", "tidyverse", "sf") # Add more packages here as needed
lapply(load_packages, library, character.only = TRUE)
rm(load_packages)
# Set global options

# Define functions

# Script

F_1970<-read_csv("data_raw/LTDB_Std_1970_fullcount.csv", col_types = cols(TRTID10 = col_character())) |> 
  mutate(TRTID10 = str_pad(TRTID10, width = 11, side="left", pad= "0"))
S_1970<-read_csv("data_raw/ltdb_std_1970_sample.csv", col_types = cols(TRTID10 = col_character())) |> 
  mutate(TRTID10 = str_pad(TRTID10, width = 11, side="left", pad= "0"))

F_1980<-read_csv("data_raw/LTDB_Std_1980_fullcount.csv", col_types = cols(TRTID10 = col_character())) |> 
  mutate(TRTID10 = str_pad(TRTID10, width = 11, side="left", pad= "0"))
S_1980<-read_csv("data_raw/ltdb_std_1980_sample.csv", col_types = cols(trtid10 = col_character())) |> 
  mutate(TRTID10 = str_pad(trtid10, width = 11, side="left", pad= "0"))

F_1990<-read_csv("data_raw/LTDB_Std_1990_fullcount.csv", col_types = cols(TRTID10 = col_character())) |> 
  mutate(TRTID10 = str_pad(TRTID10, width = 11, side="left", pad= "0"))
S_1990<-read_csv("data_raw/ltdb_std_1990_sample.csv", col_types = cols(TRTID10 = col_character())) |> 
  mutate(TRTID10 = str_pad(TRTID10, width = 11, side="left", pad= "0"))

F_2000<-read_csv("data_raw/LTDB_Std_2000_fullcount.csv", col_types = cols(TRTID10 = col_character())) |> 
  mutate(TRTID10 = str_pad(TRTID10, width = 11, side="left", pad= "0"))
S_2000<-read_csv("data_raw/ltdb_std_2000_sample.csv", col_types = cols(TRTID10 = col_character())) |> 
  mutate(TRTID10 = str_pad(TRTID10, width = 11, side="left", pad= "0"))

F_2010<-read_csv("data_raw/LTDB_Std_2010_fullcount.csv", col_types = cols(tractid = col_character()))
S_2010<-read_csv("data_raw/LTDB_std_200812_Sample.csv", col_types = cols(tractid = col_character())) |> 
  rename(TRTID10 = tractid)

F_2020<-read_csv("data_raw/LTDB_Std_2020_fullcount.csv", col_types = cols(TRTID2010 = col_character()))
S_2020<-read_csv("data_raw/LTDB_std_201519_Sample.csv", col_types = cols(tractid = col_character())) |> 
  rename(TRTID10 = tractid)

inc_70<-S_1970 |>  
  select(TRTID10, INCPC70)
inc_80<-S_1980 |>  
  select(TRTID10, INCPC80 = incpc80)
inc_90<-S_1990 |>  
  select(TRTID10, INCPC90)
inc_00<-S_2000 |>  
  select(TRTID10, INCPC00)
inc_10<-S_2010 |>  
  select(TRTID10, INCPC12 = incpc12)
inc_20 <- S_2020 |> 
  select(TRTID10, STATE = statea, COUNTY = countya, TRACT = tracta, INCPC19 = incpc19)

income<-left_join(inc_20, inc_10, by="TRTID10")
income<-left_join(income, inc_00, by="TRTID10")
income<-left_join(income, inc_90, by="TRTID10")
income<-left_join(income, inc_80, by="TRTID10")
income<-left_join(income, inc_70, by="TRTID10")

income<-income  |>  
  select(TRTID10, STATE, COUNTY, TRACT, INCPC70, INCPC80, INCPC90, INCPC00, INCPC12, INCPC19)

income<-income |> 
  mutate(
    INCPC70 = INCPC70*6.66,
    INCPC80 = INCPC80*3.24,
    INCPC90 = INCPC90*1.98,
    INCPC00 = INCPC00*1.49,
    INCPC12 = INCPC12*1.11
  )

income<-income |> 
  mutate(COFIPS = substr(TRTID10, 0, 5))

rm(inc_70, inc_80, inc_90, inc_00, inc_10, inc_20)

pop_70<- F_1970 |> select(TRTID10, POP70)
pop_80<- F_1980 |> select(TRTID10, POP80)
pop_90<- F_1990 |> select(TRTID10, POP90)
pop_00<- F_2000 |> select(TRTID10, POP00)
pop_10<- F_2010 |> select(TRTID10 = tractid, POP10=pop10) # note the renaming of variables.
pop_20<- F_2020 |> select(TRTID10 = TRTID2010, POP20=pop20) # note the renaming of variables.

pop<-left_join(pop_20, pop_10, by="TRTID10")
pop<-left_join(pop, pop_00, by="TRTID10")
pop<-left_join(pop, pop_90, by="TRTID10")
pop<-left_join(pop, pop_80, by="TRTID10")
pop<-left_join(pop, pop_70, by="TRTID10")
pop <- pop |> select(TRTID10, POP70, POP80, POP90, POP00, POP10, POP20)
rm(pop_70, pop_80, pop_90, pop_00, pop_10, pop_20)
