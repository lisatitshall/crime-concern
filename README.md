## Summary
Explore the following dataset using R: [Attitude Towards Crime and Punishment in England and Wales 1965-2023](https://beta.ukdataservice.ac.uk/datacatalogue/studies/study?id=857473) (open dataset obtained via the UK Data Service). 

### Steps taken

- Step 1: Import data from csv and explore datatypes
- Step 2: Summarize the dataset and see if there are any nulls
- Step 3: Look at each variable individually to understand what it shows
- Step 4: Look at how the index differs by variable
- Step 5: Deep dive into any major differences between demographics or decades

## Initial Exploration
- Varname is a combination of the poll type and question. It won't provide any different information but will be easier to filter on.
- Years shows when the surveys were performed. Some years have less data than others e.g. 1965 has 4 data points.
- The demographics are a mix of ages, genders and ethnicities. The total for each demographic differs.
- The index is positively skewed with median 0.34 and mean 0.37 (see image below, the red line is what the normal distribution looks like).

![image](https://github.com/user-attachments/assets/a5e5bfaf-f40f-4452-b439-7e1078cac35f)

- There are differing scales of survey size from double digits to 100k (see boxplot below).
![image](https://github.com/user-attachments/assets/e3488eb5-8699-49a3-919e-cdd0eaaf7e78)

- Some questions have few data points. This could be because they weren't asked on multiple years or don't include all demographics.

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




### [2] Crime concern has fallen over the decades
The barplot below shows the average index per decade (note that the 1960's and 1970's have fewer data points). Crime concern has been decreasing except in the 2020's.

![image](https://github.com/user-attachments/assets/fcd99234-5063-4cce-8f5d-f4f6fd2cd10f)

Plotting the index distribution by decade reveals outliers for the 2010's and a greater range of responses for the 2020's.

![image](https://github.com/user-attachments/assets/b59f911b-a889-48c4-b4b8-d26a87a5b6ef)









