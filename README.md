## Summary
Explore the following dataset using R: [Attitude Towards Crime and Punishment in England and Wales 1965-2023](https://beta.ukdataservice.ac.uk/datacatalogue/studies/study?id=857473) (open dataset obtained via the UK Data Service). 

### Steps taken

- Step 1: Import data from csv and explore datatypes
- Step 2: Explore data [(see Data Notes)](#data-notes)  
- Step 3: Deep dive into any major differences between demographics or decades

## Findings
### [1] Crime concern differs by demographic
The boxplot below shows the distribution of index for each demographic. We can see that females are more concerned about crime than males, non-whites are more concerned than whites and there isn't much difference between different ages. 

![image](https://github.com/user-attachments/assets/c555c9d8-5087-428f-8cff-83e7e94c385d)

The following density plot compares the index distribution for females and males.

![image](https://github.com/user-attachments/assets/5d455e92-5ba7-48ae-8e25-892f6748e6ba)

To establish what was causing higher concern for females, an inner join was undertaken to compare female and male responses for the same poll, year and question. A few questions only posed to women were removed at this stage. The following scatter plot shows many instances where females were more concerned about the same issue than males (anything below the red line). 

![image](https://github.com/user-attachments/assets/04f57f9d-f326-49c6-9145-bc3622c9b099)

Grouping by theme showed which issues females are more concerned about (see scatter chart below). Note: only themes that appear in multiple polls have been included and careful work was done to ensure only matching questions were grouped together. 

![image](https://github.com/user-attachments/assets/5da887e0-04a9-4121-9f14-c63edfe078fb)

The following themes stand out as being of more concern to females: rape/molest, safety at night, mugging and fear of crime.

A similar analysis was undertaken for ethnicity. The following scatter plot shows that non-white people were often more concerned about the same issue than white people (anything above the red line). 

![image](https://github.com/user-attachments/assets/de31f389-5038-4487-8891-30942fe270b1)

One theory was the higher concern could have been in earlier decades. A scatterplot including decade showed no clear trend. 

![image](https://github.com/user-attachments/assets/41042a4d-22f4-403a-a33e-f56686f86007)

Grouping by themes showed one clear issue that non-white people are more concerned about (race attacks) but otherwise the trends were not as clear as the female / male split. 

![image](https://github.com/user-attachments/assets/972f2683-b6db-405c-be4e-e945f3ed06f0)

Finally, a lollipop chart shows how worry about race attacks has decreased between 1994 and 2019. However, a large gap remains between white people (orange dots) and non-white people (blue dots). 

![image](https://github.com/user-attachments/assets/92c7d4f4-80fc-4a64-b51a-8e0d4dcf87f3)

### [2] Crime concern has fallen over the decades
The barplot below shows the average index per decade (note that the 1960's and 1970's have fewer data points). Crime concern has been decreasing except in the 2020's.

![image](https://github.com/user-attachments/assets/fcd99234-5063-4cce-8f5d-f4f6fd2cd10f)

Plotting the index distribution by decade reveals outliers for the 2010's and a greater range of responses for the 2020's.

![image](https://github.com/user-attachments/assets/b59f911b-a889-48c4-b4b8-d26a87a5b6ef)

Using the same themes as above the boxplots below shows the level of concern by theme in the 2010's (outliers are above 0.7).

![image](https://github.com/user-attachments/assets/1b6a248a-75f7-44a8-9ebd-e25869e2b392)


The boxplots suggest that the overall crime concern was high but concern for specific crimes weren't. For example, the only outliers were in the following themes: Local or National Crime Increase, Fear of Crime and NA. On inspection the NA data points were questioning whether it was less safe for children to play outside than 10 years ago. The density chart below plots the distributions for these categories.

![image](https://github.com/user-attachments/assets/7c35fc2a-73bb-44f5-9fdf-49f3f84c8b36)

When the same analysis was repeated for the 2020's it became clear that only broader questions about overall crime concern were asked. The exception was whether people felt safe walking during the day and night. This could help explain why the overall crime concern seemed higher for the 2020's. An alternative theory could have been new categories of crime e.g. cyber crime.

It's possible this trend holds across the decades i.e. people feel crime is getting worse but aren't personally concerned about anything in particular. Revisiting the boxplots we can see that each decade has values close to 1 but in earlier decades they're not shown as outliers because concern for specific crimes was higher.  

It would also be interesting to see what crime data the Office for National Statistics provide and whether it could be compared to the survey data. In general, I suspect crime has decreased over the decades but it would be interesting to see if there are exceptions and how that fits it with this survey data.

## Data Notes
- Varname is a combination of the poll type and question.
- Years shows when the surveys were performed. Some years have less data than others e.g. 1965 has 4 data points.
- The demographics are a mix of ages, genders and ethnicities. The total for each demographic differs.
- The index is positively skewed with median 0.34 and mean 0.37 (see image below, the red line is what the normal distribution looks like).

![image](https://github.com/user-attachments/assets/a5e5bfaf-f40f-4452-b439-7e1078cac35f)

- There are differing scales of survey size from double digits to 100k (see boxplot below).
![image](https://github.com/user-attachments/assets/e3488eb5-8699-49a3-919e-cdd0eaaf7e78)

- Some questions have few data points. This could be because they weren't asked on multiple years or don't include all demographics.
