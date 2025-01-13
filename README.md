## Summary
Explore the following dataset using R: [Attitude Towards Crime and Punishment in England and Wales 1965-2023](https://beta.ukdataservice.ac.uk/datacatalogue/studies/study?id=857473) (open dataset obtained via the UK Data Service). 

### Steps taken

- Step 1: Import data from csv and explore datatypes
- Step 2: Summarize the dataset and see if there are any nulls
- Step 3: Look at each variable individually to understand what it shows
- Step 4: Look at how the index differs by variable

## Initial Exploration
- Varname is a combination of the poll type and question. It won't provide any different information but will be easier to filter on.
- Years shows when the surveys were performed. Some years have less data than others e.g. 1965 has 4 data points.
- The demographics are a mix of ages, genders and ethnicities. The total for each demographic differs.
- The index is positively skewed with median 0.34 and mean 0.37 (see image below, the red line is what the normal distribution looks like).

![image](https://github.com/user-attachments/assets/a5e5bfaf-f40f-4452-b439-7e1078cac35f)

- There are differing scales of survey size from single digits to 100k (see boxplot below).

![image](https://github.com/user-attachments/assets/e3488eb5-8699-49a3-919e-cdd0eaaf7e78)

- Some questions have few data points. This could be because they weren't asked on multiple years or don't include all demographics.

## Findings
### [1] Crime concern differs by demographic
The boxplot below shows the distribution of index for each demographic. We can see that females are more concerned about crime than males, non-whites are more concerned than whites and there isn't much difference between different ages. 




