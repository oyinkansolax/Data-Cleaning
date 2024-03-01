#Import relevant libraries
library(dplyr)
library(tidyr)
library(lubridate)

#Initializing the data and storing it in a variable called data
data <- read.delim('Spotify_Messy_210931868 copy.txt', stringsAsFactors = FALSE)

#Checking the shape of the dataset
dim(data)

#Checking the size of the dataset
length(data)

#Checking the structure of the dataset
str(data)

#Checking the summary of the dataset
summary(data)

# Dropping columns
data <- data %>% select(-c(rap, rock, latin, r.b))

# Renaming a column
data <- data %>% rename(track_name = ZZtrack_name89)

# Splitting and expanding a column into two
data <- data %>% separate(danceability.energy, into = c("danceability", "energy"), sep = "_")

#Display the dataset
data

#Check the unique values in the track artist field
print(unique(data$track_artist))

#Remove the unwanted characters in the track_artist field
data <- data %>%
  mutate(track_artist = gsub("\\[", "", track_artist),
         track_artist = gsub("\\]", "", track_artist))

#Check the unique values in the mode field
print(unique(data$mode))

# Replacing 'Q' in 'mode' column
data$mode <- gsub("Q", "", data$mode)

#Converting columns to numeric because they only contain numeric values
cols <- c("danceability", "energy", "mode")
data[cols] <- lapply(data[cols], as.numeric)

# Dropping NA values
data <- na.omit(data)

# Handling 'track_album_release_date' column

#Replacing the 'nan' string with an actual NA value so we can drop it
data$track_album_release_date <- gsub("nan", NA, data$track_album_release_date)

#Replacing the poorly written values with the correct value
data$track_album_release_date <- gsub("20.5", "2020", data$track_album_release_date)
data$track_album_release_date <- gsub("0.5", "2020", data$track_album_release_date)

#Adding day and month to values with only the year so all our values are uniform
data <- data %>% mutate(track_album_release_date = ifelse(!grepl("-", track_album_release_date), paste0(track_album_release_date, "-01-01"), track_album_release_date))

#Adding day to values without it so all our values are uniform
data <- data %>% mutate(track_album_release_date = ifelse(nchar(track_album_release_date) == 7, paste0(track_album_release_date, "-01"), track_album_release_date))

#Checking it all our values are uniform
print(unique(data$track_album_release_date))

#Dropping null columns
data <- na.omit(data)

#Converting the track_album_release_date field to a date field
data$track_album_release_date <- ymd(data$track_album_release_date)

# Writing our cleaned data out and exporting it
write.table(data, "cleaned.txt", row.names = FALSE)


