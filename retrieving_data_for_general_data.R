##----------------------------------------
## Step 0: Load Libraries
##----------------------------------------
library(XML)        ## Extract urls
library(httr)       ## Extract urls
library(tidyverse)  ## String and data frame Manipulation


##----------------------------------------
## Step 1: Created Functions 
##----------------------------------------
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Name: get_df
## Input: The url used to scrap data
## Output: Table of stats as a data frame
## Purpose: Be able to get pertinent table from url
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
get_df = function(url){
  ## Open website
  tabs <- GET(url)
  tabs <- readHTMLTable(rawToChar(tabs$content), stringsAsFactors = F)
  ## Get DF
  s_df = tabs$pgl_basic
  return(s_df)
}


##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Name: gather_data_web
## Input: All urls and number of years on interest
## Output: Data frame of all years of player of interest
## Purpose: Get Data frames from web
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
gather_data_web = function(imp_links,num_years){
  full_data <- vector()
  for(i in 1:num_years){
    ## Opens Access to website
    tab_df <- get_df(imp_links[i])
    tab_df$Season <- paste0("season_",i,sep='')
    ## Joins DF
    full_data <- rbind(full_data,tab_df)  
    
    cat(paste0("season_",i,sep=''),'\n')
  }
  return(full_data)
}





##----------------------------------------
## Step 2: Curate Data
##----------------------------------------

## State the 1st year for each player
mj_begin_year =  1985;
lj_begin_year =  2004;
kb_begin_year =  1997;


## Number of years of Interest
num_years_mj = 19
num_years = 15

## Create a list of urls for each player
info_mj  = paste("http://www.basketball-reference.com/players/j/jordami01/gamelog/")
mj_links = paste(rep(info_mj,num_years_mj),seq(mj_begin_year,mj_begin_year+(num_years-1)),"/",sep="")

## Removing years at which MJ is not in NBA
mj_years_no_ply = c(
  "http://www.basketball-reference.com/players/j/jordami01/gamelog/1994/",
  "http://www.basketball-reference.com/players/j/jordami01/gamelog/1999/",
  "http://www.basketball-reference.com/players/j/jordami01/gamelog/2000/",
  "http://www.basketball-reference.com/players/j/jordami01/gamelog/2001/")

mj_links = mj_links[!(mj_links %in% mj_years_no_ply)]

info_kb = paste("http://www.basketball-reference.com/players/b/bryanko01/gamelog/")
kb_links = paste(rep(info_kb,num_years),seq(kb_begin_year,kb_begin_year+(num_years-1)),"/",sep="")

info_lj = paste("http://www.basketball-reference.com/players/j/jamesle01/gamelog/")
lj_links = paste(rep(info_lj,num_years),seq(lj_begin_year,lj_begin_year+(num_years-1)),"/",sep="")






## Gathering Data Using Functions
mj_data = gather_data_web(mj_links,num_years)
lj_data = gather_data_web(lj_links,num_years)

## First 4 years of data for Kobe
kb_data = gather_data_web(kb_links,4)

## KB Cleaning, new format for years 5 and on
n_seasons = 11
kb_data_new = vector()
for(i in 1:n_seasons){
  kb_data_tmp = get_df(kb_links[4+i])
  kb_data_tmp = kb_data_tmp[,-30]; 
  kb_data_tmp$Season <- paste0("season_",4+i,sep='')
  kb_data_new = rbind(kb_data_new,kb_data_tmp)
}

colnames(kb_data_new) = colnames(kb_data)
kb_data = rbind(kb_data,kb_data_new)



## Create Variable for home or away
mj_data$Game_Location = ifelse(mj_data[,6] == "@","Away","Home")
kb_data$Game_Location = ifelse(kb_data[,6] == "@","Away","Home")
lj_data$Game_Location = ifelse(lj_data[,6] == "@","Away","Home")




## Create Variable for win or lose
mj_data$Game_Outcome = ifelse(str_detect(string = mj_data[,8], pattern = "W"),"W","L")
kb_data$Game_Outcome = ifelse(str_detect(string = kb_data[,8], pattern = "W"),"W","L")
lj_data$Game_Outcome = ifelse(str_detect(string = lj_data[,8], pattern = "W"),"W","L")



## Create Variable for point margin
mj_data$Point_Margin = as.numeric(str_remove_all(string = mj_data[,8],"\\(|\\)|W|L|\\+| "))
kb_data$Point_Margin = as.numeric(str_remove_all(string = kb_data[,8],"\\(|\\)|W|L|\\+| "))
lj_data$Point_Margin = as.numeric(str_remove_all(string = lj_data[,8],"\\(|\\)|W|L|\\+| "))






## Remove columns that are not important and add a label for players
mj_data = mj_data[,-c(6,8)]; mj_data$Name = "MJ"
kb_data = kb_data[,-c(6,8)];  kb_data$Name = "KB"
lj_data = lj_data[,-c(6,8,30)] ; lj_data$Name = "LJ"



mj_data$number_game = 1:nrow(mj_data)
lj_data$number_game = 1:nrow(lj_data)
kb_data$number_game = 1:nrow(kb_data)




## Combine all data frames
all_df <- rbind(mj_data,kb_data,lj_data)


## Remove rows that are not important
all_df <- all_df %>%
  filter(Rk != "Rk")

all_df$MP = as.numeric(str_replace_all(all_df$MP,":","."))



## Data Manipulation to get other statistics
nba = all_df %>%
  mutate(PTS = as.numeric(PTS),
         TRB = as.numeric(TRB),
         AST = as.numeric(AST),
         STL = as.numeric(STL),
         BLK = as.numeric(BLK),
         double_PTS = ifelse(PTS >= 10,1,0),
         double_TRB = ifelse(TRB >= 10,1,0),
         double_AST = ifelse(AST >= 10,1,0),
         double_STL = ifelse(STL >= 10,1,0),
         double_BLK = ifelse(BLK >= 10,1,0)) %>%
  mutate(sum_d = rowSums(select(., starts_with("double"))),
         DD = ifelse(sum_d == 2,1,0),
         TD = ifelse(sum_d == 3,1,0)) %>%
  select(-double_PTS,-double_TRB,-double_AST,
         -double_STL,-double_BLK,-sum_d) %>%
  select(Name,Season,Game_Location, Game_Outcome, Point_Margin,everything())%>%
  mutate(Age_Years = substr(Age,start =1,stop=2),
         Age_Days = substr(Age,start =4,stop = 6))

colnames(nba) = str_replace_all(colnames(nba), '%','_Percent')

setwd("C:/Users/james/OneDrive/Documents/Important_Files/Stat_ed_2018_papers/paper_0_bball_data/0_basketball_data")
write.csv(nba,"modern_nba_legends_08062019.csv",row.names = F)


