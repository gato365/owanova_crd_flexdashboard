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
## Input: All urls and pn - player name
## Output: Data frame of all years of player of interest
## Purpose: Get Data frames from web
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
gather_data_web = function(imp_links,pn){
  full_data <- vector()
  for(i in 1:length(imp_links)){
    ## Opens Access to website
    tab_df <- get_df(imp_links[i])
    
    ## Change column names vector
    if(ncol(tab_df) == 30){
    
    
    app_cn_vec = c("Rk","G","Date","Age","Tm",
                   "Game_Location","Opp","Game_Outcome",     
                   "GS","MP","FG","FGA","FG_Percent","3P",
                   "3PA","3P_Percent","FT","FTA","FT_Percent",
                   "ORB","DRB","TRB","AST","STL","BLK","TOV",
                   "PF","PTS","GmSc","Plus_Minus")
    colnames(tab_df) = app_cn_vec
    } else if(ncol(tab_df) == 29) {
      
      app_cn_vec = c("Rk","G","Date","Age","Tm",
                     "Game_Location","Opp","Game_Outcome",     
                     "GS","MP","FG","FGA","FG_Percent","3P",
                     "3PA","3P_Percent","FT","FTA","FT_Percent",
                     "ORB","DRB","TRB","AST","STL","BLK","TOV",
                     "PF","PTS","GmSc")
      colnames(tab_df) = app_cn_vec
      tab_df$Plus_Minus = NA
      
    }
    ## Add Season Variable
    tab_df$Season <- paste0("season_",i,sep='')
    ## Joins DF
    full_data <- rbind(full_data,tab_df)  
    
    cat(paste0("season_",i,sep=''),'\n')
  }
  
  ## Add Player Name Variable and Make important Changes
  full_data = full_data %>%
    filter(Rk != "Rk") %>% 
    mutate(name = pn,
           Game_Location = ifelse(Game_Location == "@","Away","Home"),
           Point_Margin = as.numeric(str_remove_all(string = Game_Outcome,"\\(|\\)|W|L|\\+| "),
           Game_Outcome = ifelse(str_detect(string = Game_Outcome, pattern = "W"),"W","L")
           ))
  full_data$number_game = 1:nrow(full_data)
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
num_years = 15

## Create a list of urls for each player
mj_years = 1985:2003
## Removing years at which MJ is not in NBA
mj_years = mj_years[ !mj_years %in% c(1994,1999,2000,2001)]


## Gather Data for MJ
info_mj  = paste("http://www.basketball-reference.com/players/j/jordami01/gamelog/")
mj_links = paste(rep(info_mj,num_years),mj_years,"/",sep="")
mj_data = gather_data_web(mj_links,'MJ')

## Gather Data for KB
info_kb = paste("http://www.basketball-reference.com/players/b/bryanko01/gamelog/")
kb_links = paste(rep(info_kb,num_years),seq(kb_begin_year,kb_begin_year+(num_years-1)),"/",sep="")
kb_data = gather_data_web(kb_links,'KB')

## Gather Data for LJ
info_lj = paste("http://www.basketball-reference.com/players/j/jamesle01/gamelog/")
lj_links = paste(rep(info_lj,num_years),seq(lj_begin_year,lj_begin_year+(num_years-1)),"/",sep="")
lj_data = gather_data_web(lj_links,'LJ')
























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
  rename(Name = name) %>% 
  select(Name,Season,Game_Location, Game_Outcome, Point_Margin,everything())%>%
  mutate(Age_Years = substr(Age,start =1,stop=2),
         Age_Days = substr(Age,start =4,stop = 6))




write.csv(nba,"modern_nba_legends_02242022.csv",row.names = F)


