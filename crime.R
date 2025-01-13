#load required packages
library(tidyverse)

#read in crime concern data to explore
crime_concern <- read_csv("data/CrimeConcern.csv")

#for reference the docs say this about the index:
#"The Index score is calculated by transforming each 
#survey question into a binary variable 
#(where 1 indicates concerned/punitive/supportive/prioritising) 
#and then taking the weighted average of all respondents 
#or of the relevant demographic subgroup."

#find example mentioned in the docs: British Election Studies Internet Panel
#group to find the wording for different poll types
poll_names <- crime_concern %>% group_by(Poll) %>% summarise(surveys = n())

#subset of internet panel polls, number of records as expected
#in 2014 58% of adults thought crime was increasing
internet_panel <- filter(crime_concern, Poll == "BES Internet Panel")

#look at datatypes
glimpse(crime_concern)

#change character columns to factors
crime_concern$Varname <- factor(crime_concern$Varname)
crime_concern$Demographic <- factor(crime_concern$Demographic)
crime_concern$Poll <- factor(crime_concern$Poll)
crime_concern$Question <-factor(crime_concern$Question)

#are there any Nulls? No
crime_concern %>% summarize(across(everything(), ~sum(is.na(.x)))) 

#summarize the data except for question
#nothing immediately standing out as an anomaly
summary(crime_concern %>% select(!Question))

#look at each variable (except first id column)
#68 values for Varname column based on poll/specific question
#8 is lowest count
varnames <- crime_concern %>% group_by(Varname) %>% tally(sort=TRUE)

#Look at years, 1965-2023, lowest count is 2
#from 1988 onwards everything is in January
years <- crime_concern %>% group_by(year(Date), month(Date)) %>% 
  tally(sort = TRUE)

#9 demographics, mix of age, gender and ethnicity
demographics <- crime_concern %>% group_by(Demographic)%>% 
  tally(sort = TRUE)

#positive skewed distribution for index
ggplot(data = crime_concern, aes(Index)) +
  geom_histogram(aes(y = after_stat(density)), bins = 10) +
  stat_function(fun = dnorm, args = 
                  list(mean = mean(crime_concern$Index), 
                       sd = sd(crime_concern$Index)), 
                colour = "red") +
  theme_bw()

mean(crime_concern$Index)
median(crime_concern$Index)

#already seen 7 types of poll
#BES Cross Sections and Internet Panel don't have much data

#differing scales of survey size
options(scipen = 10000)
boxplot(crime_concern$n,
        xlab = "Survey Size",
        horizontal = TRUE)

#65 questions, lowest count is 8
#noticed at least one question that's a "tick up to 4" rather than Likert scale
#some questions don't say what the options / scale are
#some questions mention the "bad" result first, others mention the "good"
questions <- crime_concern %>% group_by(Question)%>% tally(sort = TRUE)

#look at interaction of index with other variables

#how does index differ by poll?
#significant variation but also big difference in number of data points
#could this be differing by year as well??
boxplot(Index ~ Poll, data = crime_concern, cex.axis = 0.5)

#how does index differ by demographic
#less variation, roughly equal amount of data points per demographic
#female index is higher than male as we may expect
#might have expected older people to be higher
boxplot(Index ~ Demographic, data = crime_concern, cex.axis = 0.5)

#visualize male/female alone
ggplot(data = crime_concern %>% filter(Demographic %in% c("Female", "Male")),
       aes(x= Index, colour = Demographic)) +
  geom_density() +
  xlim(0,1) +
  theme_bw()

#visualize white/non-white alone
ggplot(data = crime_concern %>% filter(Demographic %in% c("Non-white", "White")),
       aes(x= Index, colour = Demographic)) +
  geom_density() +
  xlim(0,1) +
  theme_bw()

#visualize ages
ggplot(data = crime_concern %>% 
         filter(Demographic %in% c("16-24", "25-49", "50-64", "65+")),
       aes(x= Index, colour = Demographic)) +
  geom_density() +
  xlim(0,1) +
  theme_bw()

#how does index differ by year
#add decade column, bit arbitrary but gives general idea
crime_concern <- crime_concern %>%
  mutate(decade = 10 * (year(crime_concern$Date) %/% 10))

#group by decade and check year to see if results are correct, yes
decade <- crime_concern %>% group_by(decade) %>%
  summarise(data_points = n(), mean_index = round(mean(Index),2)) %>%
  mutate(change_from_previous_decade = mean_index - lag(mean_index))

#show how mean index changes over the decades
barplot(decade$mean_index, 
        names.arg = decade$decade,
        xlab = "Decade",
        ylab = "Mean index",
        main = "Changing attitudes to crime concern")

#how does the shape of index differ by decade
#generally decreasing except in 2020s, interesting (fewer data points in 2020s)
boxplot(Index ~ decade, 
        data = crime_concern,
        xlab = "Decade", 
        main = "Changing attitudes to crime concern")

#which poll covers widest date range?
#Gallup is older data from 60's to 80's, recall index was higher here 
#  and index higher in the earlier decades
#BCS / CSEW has biggest range and lots of data
poll_names <- crime_concern %>% group_by(Poll) %>% 
  summarise(surveys = n(), 
            earliest = min(year(Date)), 
            latest = max(year(Date))
  )

#which polls question different demographics 
#most have all demographics except Gallup/YouGov w/o white/non-white
(poll_demographics <- crime_concern %>% group_by(Poll) %>% 
  select(Poll, Demographic) %>% table())

#Ideas:
#Are there particular areas where females/non-whites are more concerned?
#What are the outliers for index in the 2010s?
#Why is the spread of data for 2020 wider? Specific crimes? Remember fewer data points..

