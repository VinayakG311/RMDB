import re

import numpy as np
import pandas as pd
from keras.losses import cosine_similarity
from surprise import Reader, Dataset, SVD
from surprise.model_selection import cross_validate

movies = pd.read_csv("Data/ml-latest-small/movies.csv")
ratings = pd.read_csv("Data/ml-latest-small/ratings.csv")
merged_dataset = pd.merge(ratings, movies, how='inner', on='movieId')
refined_dataset = merged_dataset.groupby(by=['userId', 'title'], as_index=False).agg({"rating": "mean"})

unique_users = refined_dataset['userId'].unique()



unique_movies = refined_dataset['title'].unique()
users_list = refined_dataset['userId'].tolist()
movie_list = refined_dataset['title'].tolist()
ratings_list = refined_dataset['rating'].tolist()
#
movies_dict = {unique_movies[i]: i for i in range(len(unique_movies))}
utility_matrix = np.asarray([[np.nan for j in range(len(unique_users))] for i in range(len(unique_movies))])
for i in range(len(ratings_list)):
    utility_matrix[movies_dict[movie_list[i]]][users_list[i] - 1] = ratings_list[i]

mask = np.isnan(utility_matrix)
masked_arr = np.ma.masked_array(utility_matrix, mask)
temp_mask = masked_arr.T
rating_means = np.mean(temp_mask, axis=0)
filled_matrix = temp_mask.filled(rating_means)
filled_matrix = filled_matrix.T
filled_matrix = filled_matrix - rating_means.data[:, np.newaxis]
filled_matrix = filled_matrix.T / np.sqrt(len(movies_dict) - 1)
U, S, V = np.linalg.svd(filled_matrix)
case_insensitive_movies_list = [i.lower() for i in unique_movies]


# print("hi")
def top_cosine_similarity(data, movie_id, top_n=10):
    index = movie_id
    movie_row = data[index, :]
    magnitude = np.sqrt(np.einsum('ij, ij -> i', data, data))
    similarity = np.dot(movie_row, data.T) / (magnitude[index] * magnitude)
    sort_indexes = np.argsort(-similarity)
    return sort_indexes[:top_n]


#
#
def get_similar_movies(movie_name, top_n, k=50):
    # k = 50
    # movie_id = 1
    # top_n = 10

    sliced = V.T[:, :k]  # representative data
    movie_id = movies_dict[movie_name]
    indexes = top_cosine_similarity(sliced, movie_id, top_n)
    print(" ")
    print("Top", top_n, "movies which are very much similar to the Movie-", movie_name, "are: ")
    print(" ")
    for i in indexes[1:]:
        print(unique_movies[i])


def get_possible_movies(movie):
    temp = ''
    possible_movies = case_insensitive_movies_list.copy()
    for i in movie:
        out = []
        temp += i
        for j in possible_movies:
            if temp in j:
                out.append(j)
        if len(out) == 0:
            return possible_movies
        out.sort()
        possible_movies = out.copy()

    return possible_movies


#
#
class invalid(Exception):
    pass


#
def recommender(movie_name, num_recom):
    try:
        movie_name_lower = movie_name.lower()
        if movie_name_lower not in case_insensitive_movies_list:
            raise invalid
        else:
            # movies_list[case_insensitive_country_names.index(movie_name_lower)]
            get_similar_movies(unique_movies[case_insensitive_movies_list.index(movie_name_lower)], num_recom)

    except invalid:

        possible_movies = get_possible_movies(movie_name_lower)

        if len(possible_movies) == len(unique_movies):
            print("Movie name entered is does not exist in the list ")
        else:
            indices = [case_insensitive_movies_list.index(i) for i in possible_movies]
            get_similar_movies(unique_movies[indices[0]], num_recom)




# reader = Reader()
# data = Dataset.load_from_df(ratings[['userId', 'movieId', 'rating']], reader)
#
# svd = SVD()
# cross_validate(svd, data, measures=['RMSE', 'MAE'],cv=5,verbose=True)
# trainset = data.build_full_trainset()
# svd.fit(trainset)
#
# print(svd.predict(1, 302, 3))
