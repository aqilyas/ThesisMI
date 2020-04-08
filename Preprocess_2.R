

########### Pre-process big_data ########## 

# 'metamovie.csv' is the dataset prepared from the Python notebook Preprocess_1.ipynb
data1 = read.csv('metamovie.csv')
movies = read.csv('tmdb_5000_movies.csv')

# 'movies_metadata.csv', 'rating_small.csv' and 'links_small.csv' 
#  are downloaded from: https://www.kaggle.com/rounakbanik/the-movies-dataset

metadata = read.csv('movies_metadata.csv') 
ratings= read.csv("ratings_small.csv")
links = read.csv("links_small.csv")

id1= metadata[,c(6,7,21)]
#id2 = data1[,c(5,19)]

id1$imdb = gsub("^.{0,3}", "", id1$imdb_id)

#tmdbid is the id

library(dplyr)

merge1 = ratings %>% left_join(links, by='movieId')

colnames(merge1)[6] = "id"  #changing 'tmdbid' to 'id'

data1 = data1[,-c(1, 4, 11, 12, 13, 16, 17, 21 )] #removing unnecessary columns

#data1 has the director and cast, and the 'id'
#links has the movieId, imdbId and tmdbId (which is the 'id') 9125 unique movies
#id1 has 'id', title, and imdbId
#merge1 has userId, movieId, timestamp, id and imdbId

mergetest = merge1

mergetest = mergetest[mergetest$id %in% data1$id,] #because the metadata with cast info is not complete,
                                                    # helaas, pindakaas!

merge2 = mergetest %>% left_join(data1, by = 'id')

data = merge2
data = data[, - c(10, 14, 17, 20)] #removing language, gross, redundant movie title, country.
data = data[, -c(5,6)] #removing ID and imdbid
data = data[, -5] #removing the budget (for high correlation reason, and for non relevance)
rating_post = data[, c(1:8)] #saving rating for unexpected emergency :) , and the overview, to be used in the survey

data = data[, -c(3,8)] #removing rating and overview

#ordering by times
test = data
test$userId = as.factor(test$userId)

test1 = test %>% group_by(userId) %>% arrange(timestamp, .by_group = T)



#user1 = transform(user1, next_id = c(movieId[-1], NA))
#c(NA, Lemonade$UnitSales[1:nrow(Lemonade)-1])

#Creating labels, next movie ID to watch.

data$userId = as.factor(test1$userId)

data = data %>% group_by(userId) %>% mutate(next_id = c(movieId[-1], NA))

#data = na.omit(data)

#This resulting dataset is uploaded to dropbox and used in the next Python notebook "NN_RS_&IG.ipynb" to build the RS







