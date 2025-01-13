#load required packages
library(tidyverse)
library(RColorBrewer)

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

#look at female data to see if any areas are of more concern
#firstly see whether females and males are asked the same questions
#There are 6 questions that females have been asked more than men
#Shouldn't be enough to change the distribution 
#    but would be better to compare like for like
(questions_by_gender <- crime_concern %>%
    filter(Demographic %in% c("Female", "Male")) %>%
    select(Varname, Demographic) %>%
    droplevels() %>%
    table())

#create a new dataset where we match by varname, year and poll and remove any
# which don't have female and male response
female <- filter(crime_concern,
                 Demographic == "Female")

male <- filter(crime_concern,
               Demographic == "Male")

gender <- inner_join(female, male %>% select(Varname, Date, Poll, Index), 
                     by = c("Varname", "Date", "Poll"), 
                     keep = FALSE) %>%
  rename(female_index = Index.x, male_index = Index.y)
  

#plot female vs male with a straight line 
plot(gender$female_index, gender$male_index,
     xlab = "Female index", 
     ylab = "Male index",
     main = "Female / male comparison",
     cex = .5,
     pch = 16)
abline(a=0, b=1, col = "red")

#ideally we would combine themes across polls (only if clear they're the same)
themes <- crime_concern %>% group_by(Varname, Question) %>% 
  summarise(count = n())

#add a column to gender for the most common themes
#probably an easier way to do this!
gender$theme <- case_when(grepl("Emotion", gender$Varname) ~ "FearOfCrime",
                          grepl("qual", gender$Varname) ~ "FearOfCrime",
                          grepl("insult", gender$Varname) ~ "FearOfCrime",
                          grepl("vmworry", gender$Varname) ~ "FearOfCrime",
                          grepl("incr", gender$Varname) ~ "LocalOrNationalCrimeIncrease",
                          grepl("Local", gender$Varname) ~ "LocalOrNationalCrimeIncrease",
                          grepl("Nat", gender$Varname) ~ "LocalOrNationalCrimeIncrease",
                          grepl("burg", gender$Varname) ~ "Burglary",
                          grepl("mug", gender$Varname) ~ "Mugging",
                          grepl("teen", gender$Varname) ~ "TeenagersOnStreets",
                          grepl("Juvenile", gender$Varname) ~ "TeenagersOnStreets",
                          grepl("dark", gender$Varname) ~ "SafetyAtNight",
                          grepl("night", ignore.case = TRUE, gender$Varname) ~ "SafetyAtNight",
                          grepl("vand", gender$Varname) ~ "VandalismOrGraffiti",
                          grepl("graff", gender$Varname) ~ "VandalismOrGraffiti",
                          grepl("theft", gender$Varname) ~ "CarCrime",
                          grepl("stolen", gender$Varname) ~ "CarCrime",
                          grepl("molest", gender$Varname) ~ "RapeOrMolest",
                          grepl("rape", gender$Varname) ~ "RapeOrMolest"
                          )

#double check the results are as expected
#one question was removed because it was about whether rape is 
# a social issue rather than whether people are personally worried about rape
#all else as expected
View(test_themes <- gender %>% 
    group_by(theme, Varname) %>% summarise(count = n()))

#change theme to factor for plotting
gender$theme <- factor(gender$theme)

#plot female/male again but by theme
ggplot(gender %>% filter(!is.na(theme)), 
       aes(female_index, male_index, col = theme )) +
  geom_point() +
  scale_color_brewer(palette = "Paired") +
  geom_abline(intercept = 0, slope = 1, linewidth = 1) +
  theme_bw() + 
  labs(
    x = "Female index", 
    y = "Male index", 
    title = "Female / male comparison"
  )


#now investigate where white/non-white concerns differ
white <- filter(crime_concern,
                 Demographic == "White")

non_white <- filter(crime_concern,
               Demographic == "Non-white")

ethnicity <- inner_join(white, non_white %>% select(Varname, Date, Poll, Index), 
                     by = c("Varname", "Date", "Poll"), 
                     keep = FALSE) %>%
  rename(white_index = Index.x, non_white_index = Index.y)

#plot white vs non-white with a straight line 
plot(ethnicity$white_index, ethnicity$non_white_index,
     xlab = "White index", 
     ylab = "Non white index",
     main = "White / non-white comparison",
     cex = .5,
     pch = 16)
abline(a=0, b=1, col = "red")



#plot white vs non-white again with decade as colour
ethnicity$decade <- factor(ethnicity$decade)

#no clear trend
ggplot(ethnicity, aes(white_index, non_white_index, col = decade )) +
  geom_point() +
  scale_color_brewer(palette = "Paired") +
  geom_abline(intercept = 0, slope = 1, linewidth = 1) +
  theme_bw() + 
  labs(
    x = "White index", 
    y = "Non-white index", 
    title = "White / non-white comparison"
  )

#try same themes we looked at for gender
ethnicity$theme <- case_when(grepl("Emotion", ethnicity$Varname) ~ "FearOfCrime",
                          grepl("qual", ethnicity$Varname) ~ "FearOfCrime",
                          grepl("insult", ethnicity$Varname) ~ "FearOfCrime",
                          grepl("vmworry", ethnicity$Varname) ~ "FearOfCrime",
                          grepl("incr", ethnicity$Varname) ~ "LocalOrNationalCrimeIncrease",
                          grepl("Local", ethnicity$Varname) ~ "LocalOrNationalCrimeIncrease",
                          grepl("Nat", ethnicity$Varname) ~ "LocalOrNationalCrimeIncrease",
                          grepl("burg", ethnicity$Varname) ~ "Burglary",
                          grepl("mug", ethnicity$Varname) ~ "Mugging",
                          grepl("teen", ethnicity$Varname) ~ "TeenagersOnStreets",
                          grepl("Juvenile", ethnicity$Varname) ~ "TeenagersOnStreets",
                          grepl("dark", ethnicity$Varname) ~ "SafetyAtNight",
                          grepl("night", ignore.case = TRUE, ethnicity$Varname) ~ "SafetyAtNight",
                          grepl("vand", ethnicity$Varname) ~ "VandalismOrGraffiti",
                          grepl("graff", ethnicity$Varname) ~ "VandalismOrGraffiti",
                          grepl("theft", ethnicity$Varname) ~ "CarCrime",
                          grepl("stolen", ethnicity$Varname) ~ "CarCrime",
                          grepl("molest", ethnicity$Varname) ~ "RapeOrMolest",
                          grepl("rape", ethnicity$Varname) ~ "RapeOrMolest",
                          grepl("race", ethnicity$Varname) ~ "RaceAttacks"
)

View(test_themes_2 <- ethnicity %>% 
       group_by(theme, Varname) %>% summarise(count = n()))

#try plotting by theme
#race attacks is only very clear trend
ggplot(ethnicity %>% filter(!is.na(theme)), 
       aes(white_index, non_white_index, col = theme )) +
  geom_point() +
  scale_color_brewer(palette = "Paired") +
  geom_abline(intercept = 0, slope = 1, linewidth = 1) +
  theme_bw() + 
  labs(
    x = "White index", 
    y = "Non-white index", 
    title = "White / non-white comparison"
  )

#plot worry about race attacks over time
ggplot(ethnicity %>% filter(Varname == "CSEW_worryraceattacks")) +
  geom_segment(aes(x=year(Date), xend=year(Date), y=non_white_index, yend=white_index), color="grey") +
  geom_point( aes(x=year(Date), y=non_white_index), col = "blue") +
  geom_point( aes(x=year(Date), y=white_index), col = "orange" ) +
  coord_flip() +
  scale_x_reverse() +
  labs (
    x = "Year",
    y = "Index",
    title = "Race Attack Worry 1994-2019"
  ) +
  theme_bw() 


#what were the outliers for the 2010's?
#anything above 0.7 was an outlier
decade_2010s <- crime_concern %>% filter(decade == "2010")

decade_2010s$theme <- case_when(grepl("Emotion", decade_2010s$Varname) ~ "FearOfCrime",
                               grepl("qual", decade_2010s$Varname) ~ "FearOfCrime",
                               grepl("insult", decade_2010s$Varname) ~ "FearOfCrime",
                               grepl("vmworry", decade_2010s$Varname) ~ "FearOfCrime",
                               grepl("incr", decade_2010s$Varname) ~ "LocalOrNationalCrimeIncrease",
                               grepl("Local", decade_2010s$Varname) ~ "LocalOrNationalCrimeIncrease",
                               grepl("Nat", decade_2010s$Varname) ~ "LocalOrNationalCrimeIncrease",
                               grepl("burg", decade_2010s$Varname) ~ "Burglary",
                               grepl("mug", decade_2010s$Varname) ~ "Mugging",
                               grepl("teen", decade_2010s$Varname) ~ "TeenagersOnStreets",
                               grepl("Juvenile", decade_2010s$Varname) ~ "TeenagersOnStreets",
                               grepl("dark", decade_2010s$Varname) ~ "SafetyAtNight",
                               grepl("night", ignore.case = TRUE, decade_2010s$Varname) ~ "SafetyAtNight",
                               grepl("vand", decade_2010s$Varname) ~ "VandalismOrGraffiti",
                               grepl("graff", decade_2010s$Varname) ~ "VandalismOrGraffiti",
                               grepl("theft", decade_2010s$Varname) ~ "CarCrime",
                               grepl("stolen", decade_2010s$Varname) ~ "CarCrime",
                               grepl("molest", decade_2010s$Varname) ~ "RapeOrMolest",
                               grepl("rape", decade_2010s$Varname) ~ "RapeOrMolest",
                               grepl("race", decade_2010s$Varname) ~ "RaceAttacks"
)

#boxplots by theme for the 2010's
ggplot(data = decade_2010s, 
       aes(x = reorder(theme, Index, FUN = median),  y = Index)) +
  geom_boxplot() +
  labs (
    x = "Theme"
  ) +
  theme(axis.text.x = element_text(size = 6)) 
  

#plot distribution of selected themes
#a general feeling crime is rising rather than specific fears
ggplot(data = decade_2010s %>% 
         filter(theme %in% c("LocalOrNationalCrimeIncrease",
                                                   "FearOfCrime",
                                                   NA)),
       aes(x= Index, colour = theme)) +
  geom_density() +
  xlim(0,1) +
  theme_bw() +
  labs (
    title = "2010 concern by selected theme"
  )

#was it similar for 2020s?
decade_2020s <- crime_concern %>% filter(decade == "2020")

decade_2020s$theme <- case_when(grepl("Emotion", decade_2020s$Varname) ~ "FearOfCrime",
                                grepl("qual", decade_2020s$Varname) ~ "FearOfCrime",
                                grepl("insult", decade_2020s$Varname) ~ "FearOfCrime",
                                grepl("vmworry", decade_2020s$Varname) ~ "FearOfCrime",
                                grepl("incr", decade_2020s$Varname) ~ "LocalOrNationalCrimeIncrease",
                                grepl("Local", decade_2020s$Varname) ~ "LocalOrNationalCrimeIncrease",
                                grepl("Nat", decade_2020s$Varname) ~ "LocalOrNationalCrimeIncrease",
                                grepl("burg", decade_2020s$Varname) ~ "Burglary",
                                grepl("mug", decade_2020s$Varname) ~ "Mugging",
                                grepl("teen", decade_2020s$Varname) ~ "TeenagersOnStreets",
                                grepl("Juvenile", decade_2020s$Varname) ~ "TeenagersOnStreets",
                                grepl("dark", decade_2020s$Varname) ~ "SafetyAtNight",
                                grepl("night", ignore.case = TRUE, decade_2020s$Varname) ~ "SafetyAtNight",
                                grepl("vand", decade_2020s$Varname) ~ "VandalismOrGraffiti",
                                grepl("graff", decade_2020s$Varname) ~ "VandalismOrGraffiti",
                                grepl("theft", decade_2020s$Varname) ~ "CarCrime",
                                grepl("stolen", decade_2020s$Varname) ~ "CarCrime",
                                grepl("molest", decade_2020s$Varname) ~ "RapeOrMolest",
                                grepl("rape", decade_2020s$Varname) ~ "RapeOrMolest",
                                grepl("race", decade_2020s$Varname) ~ "RaceAttacks"
)

#boxplots by theme for the 2020's
#only general questions / safety walking during day/night
ggplot(data = decade_2020s, 
       aes(x = reorder(theme, Index, FUN = median),  y = Index)) +
  geom_boxplot() +
  labs (
    x = "Theme"
  ) +
  theme(axis.text.x = element_text(size = 6)) 

