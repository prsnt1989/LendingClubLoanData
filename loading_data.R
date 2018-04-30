
library(dplyr)
library(DBI)
library(RSQLite)
library(tidyr)
library(zoo)

#Load Data 
url = "database.sqlite"
con = dbConnect(SQLite(), dbname=url)
myQuery <- dbSendQuery(con, "SELECT * FROM loan")
my_data <- dbFetch(myQuery, n = -1)
dbClearResult(myQuery)
dbDisconnect(con)

original_data = my_data


loan_data = as_tibble(original_data)
loan_data = loan_data[!is.na(loan_data$member_id),]

loan_data = loan_data %>% replace_na(list(emp_title="unknown",title="unknown",annual_inc=0,delinq_2yrs=median(loan_data$delinq_2yrs,na.rm = TRUE),inq_last_6mths=median(loan_data$inq_last_6mths,na.rm = TRUE),open_acc=median(loan_data$open_acc,na.rm = TRUE),pub_rec=median(loan_data$pub_rec,na.rm = TRUE),total_acc=median(loan_data$total_acc,na.rm = TRUE),collections_12_mths_ex_med=median(loan_data$collections_12_mths_ex_med,na.rm = TRUE),acc_now_delinq=median(loan_data$acc_now_delinq,na.rm = TRUE),tot_coll_amt=median(loan_data$tot_coll_amt,na.rm = TRUE)))

loan_data$earliest_cr_line = loan_data$earliest_cr_line %>% na.locf
loan_data$revol_util = loan_data$revol_util %>% na.locf
loan_data$last_credit_pull_d = loan_data$last_credit_pull_d %>% na.locf



loan_data$id = as.factor(loan_data$id)
loan_data$term = as.factor(loan_data$term)
loan_data$member_id = as.factor(loan_data$member_id)
loan_data$grade = as.factor(loan_data$grade)
loan_data$sub_grade = as.factor(loan_data$sub_grade)
loan_data$emp_length = as.factor(loan_data$emp_length)
loan_data$home_ownership = as.factor(loan_data$home_ownership)
loan_data$verification_status = as.factor(loan_data$verification_status)
loan_data$loan_status = as.factor(loan_data$loan_status)
loan_data$pymnt_plan = as.factor(loan_data$pymnt_plan)
loan_data$purpose = as.factor(loan_data$purpose)
loan_data$id = as.factor(loan_data$id)
loan_data$zip_code = as.factor(loan_data$zip_code)
loan_data$addr_state = as.factor(loan_data$addr_state)
loan_data$initial_list_status = as.factor(loan_data$initial_list_status)
loan_data$application_type = as.factor(loan_data$application_type)
loan_data$verification_status_joint = as.factor(loan_data$verification_status_joint)
loan_data$int_rate = as.numeric(gsub("%", "", loan_data$int_rate))
loan_data$revol_util = as.numeric(gsub("%", "", loan_data$revol_util))
loan_data$issue_d <- as.Date(gsub("^", "01-", loan_data$issue_d), format="%d-%b-%Y")
loan_data$earliest_cr_line <- as.Date(gsub("^", "01-", loan_data$earliest_cr_line), format="%d-%b-%Y")
loan_data$last_pymnt_d <- as.Date(gsub("^", "01-", loan_data$last_pymnt_d), format="%d-%b-%Y")
loan_data$next_pymnt_d <- as.Date(gsub("^", "01-", loan_data$next_pymnt_d), format="%d-%b-%Y")
loan_data$last_credit_pull_d <- as.Date(gsub("^", "01-", loan_data$last_credit_pull_d), format="%d-%b-%Y")
loan_data$next_pymnt_d <- as.Date(gsub("^", "01-", loan_data$next_pymnt_d), format="%d-%b-%Y")

loan_data <- loan_data %>% select(-desc,-url)














                                                 
                                              