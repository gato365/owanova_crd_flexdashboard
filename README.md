# One-Way ANOVA CRD Flexdashboard
## Website: 
https://gato365.shinyapps.io/one_way_ANOVA_flex/

## Purpose:
This paper provides introductory statistics instructors the capacity to use engaging NBA data within a R Shiny within a flexdashboard to either strengthen students' understanding or introduce the concept of variance and One-Way ANOVA. Using engaging data within the classroom provides context to data that students deem applicable to their lives. 


## 1. How to Use R Shiny

### Panel 1: Context 

This tab explains the context of the R Shiny, seen in figure 1,  to answer the question, “Who is the Greatest Basketball Player of All Time (the GOAT)?”. The tab introduces a few concepts that may make a player the best such as number of championships or work ethic but ultimately poses the question to the reader “What really determines who is the best?” It includes pictures of the three players (Lebron James, Kobe Bryant, and Michael Jordan) the activity will focus on.

### Panel 2: "Get Hyped!"

A “hype” video to get students excited for the activity is available within this tab. It is a two-minute video of career highlights of Lebron James, Kobe Bryant, and Michael Jordan, including their draft nights. This is meant to get students familiar and excited about the activity that will connect statistics to a familiar topic.

### Panel 3: Intro to Variance

Within the Intro to Variance tab, there are 4 panes that contribute to the learning process of variance. An illustration of this tab can be seen in figure 2. Within the top right pane, students will see the equation for variance in the top right corner followed by the choices (player and variable) they have in terms of learning this topic. If students are not familiar with any topic further explanations of the variables are also included. The pane below allows the student to determine the sample size, player, and variable that will display in the pane next to it.

### Panel 4: Intro to ANOVA: Sum of Squares

This tab begins the transition from variance to analysis of variance. The three panes provide the sums of squares for the two sources of variability (between and within), as well as the total variability. The sum of squares is the total amount of squared deviations of each observation and its mean. The sum of squares between groups examines the squared deviation of each group's mean with the overall mean multiplied by the sample size, whereas the within group considers the squared deviation of each individual observation within each group and that group's mean. 


### Panel 5: Intro to One-Way ANOVA: Mean Square & F

The first pane explains degrees of freedom in each source of variability and includes the equations for the three types of degrees of freedom (within, between and total). This can be supplemented with teacher instruction to explain why the formulas for degrees of freedom make sense. The formulas for the two mean squares (between and within) demonstrate to students that we divide the sum of squares of each type with its corresponding degrees of freedom. 

### Panel 6: One-Way Analysis of Variance

The final tab allows students to visualize and analyze One-Way ANOVA regarding all three players and one variable. Students can select the variable to compare among the three players and view the data using the following visualizations: vertical boxplots, vertical dot plots, or vertical violin plots. The class should be reminded of the null hypothesis of One-Way ANOVA, which is that the population mean of the selected statistic is the same across all three players, with the same sample size chosen within the ‘Intro to Variance’ tab being used

## 2. Important Files
A. Data Extraction from Sports Reference and Cleaning - 'retrieving_data_for_general_data.R'

B. Actual R Shiny Flexdashboard - 'anova_slr_new.Rmd'

C. Data from Sports Reference - 'modern_nba_legends_02242022.csv'


## 3. Reference

Sports Reference LLC. Pro-Basketball-Reference.com - Pro Basketball Statistics and History. https://www.pro-football-reference.com/. (March 2021)

Wickham, H. (2017c), The tidy tools manifesto [online]. Retrieved from https://cran.r- project.org/web/packages/tidyverse/vignettes/manifesto.html. 				

Wickham, H. (2017), “tidyverse: Easily Install and Load 'Tidyverse' Packages.” R package version 1.1.1. https://CRAN.R-project.org/package=tidyverse. 

Wickham, H., & Wickham, M. H. (2016). Package ‘rvest’. URL: https://cran. r-project. org/web/packages/rvest/rvest. pdf, p156.








