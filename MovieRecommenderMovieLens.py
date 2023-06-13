import ast
import re
from pprint import pprint
import tensorflow as tf
from tensorflow.python.keras.layers import embeddings

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from scipy.sparse import csr_matrix
from sklearn.neighbors import NearestNeighbors
import warnings

warnings.simplefilter('ignore')

movies = pd.read_csv("Data/ml-25m/movies.csv")
links = pd.read_csv("Data/ml-25m/links.csv")
ratings = pd.read_csv("Data/ml-25m/ratings.csv")
tags = pd.read_csv("Data/ml-25m/tags.csv")
genscore = pd.read_csv("Data/ml-25m/genome-scores.csv")
gentags = pd.read_csv("Data/ml-25m/genome-tags.csv")

movies['genres'] = movies['genres'].apply(lambda x: x.split("|"))

columns = ['Action', 'Adventure', 'Animation', "Children", 'Comedy', 'Crime', 'Documentary', 'Drama', 'Fantasy',
           'Film-Noir', 'Horror', 'Musical', 'Mystery', 'Romance', 'Sci-Fi', 'Thriller', 'War', 'Western',
           '(no genres listed)']
d = {}
for i in columns:
    d[i] = []
x = movies[movies['genres'].notnull()]['genres'].tolist()

for i in x:
    for j in columns:
        if j in i:
            d[j].append(1)
        else:
            d[j].append(0)
for k, v in d.items():
    movies[k] = v
merged = ratings.merge(movies, on="movieId", how="inner")


def get_highly_rated_popular_movies():
    avg_highly_rated_movies = merged.groupby(['title']).agg({"rating": "mean"})['rating'].sort_values(ascending=False)
    avg_highly_rated_movies = avg_highly_rated_movies.to_frame()
    avg_highly_rated_movies.reset_index(level=0, inplace=True)
    avg_highly_rated_movies.columns = ['title', 'avg_rating']
    popular_movies = merged.groupby(['title']).agg({"rating": "count"})['rating'].sort_values(ascending=False)
    popular_movies = popular_movies.to_frame()
    popular_movies.reset_index(level=0, inplace=True)
    popular_movies.columns = ['title', 'Views']

    highly_rated_popular_movies = pd.merge(avg_highly_rated_movies, popular_movies, how='inner', on='title')
    highly_rated_popular_movies=highly_rated_popular_movies.merge(movies,on="title")
    highly_rated_popular_movies = highly_rated_popular_movies.merge(links, on="movieId")
    highly_rated_popular_movies=highly_rated_popular_movies[highly_rated_popular_movies['tmdbId']>0]

    highly_rated_popular_movies['tmdbId'] = highly_rated_popular_movies['tmdbId'].apply(lambda x: int(x))


    return (highly_rated_popular_movies[
              (highly_rated_popular_movies['Views'] > 300) & (highly_rated_popular_movies['avg_rating'] >= 4)])



def recommendations_genre(genre):
    x = genre
    genre_based_movies = movies[['movieId', 'title', x]]
    genre_based_movies = genre_based_movies[genre_based_movies[x] == 1]
    merged_genre_movies = pd.merge(ratings, genre_based_movies, how='inner', on='movieId')
    # merged_genre_movies.head()
    high_rated_movies = merged_genre_movies.groupby(['title','movieId']).agg({"rating": "mean"})['rating'].sort_values(
        ascending=False)
    high_rated_movies = high_rated_movies.to_frame()
    popular_movies_ingenre = merged_genre_movies.groupby(['title','movieId']).agg({"rating": "count"})['rating'].sort_values(
        ascending=False)
    popular_movies_ingenre = popular_movies_ingenre.to_frame()
    popular_movies_ingenre.reset_index(level=0, inplace=True)
    popular_movies_ingenre.columns = ['title', 'Views']
    highly_rated_popular_movies = pd.merge(high_rated_movies, popular_movies_ingenre, how='inner', on='title')
    highly_rated_popular_movies=highly_rated_popular_movies.merge(movies,on="title")
    highly_rated_popular_movies = highly_rated_popular_movies.merge(links, on="movieId")
    highly_rated_popular_movies=highly_rated_popular_movies[highly_rated_popular_movies['tmdbId']>0]

    highly_rated_popular_movies['tmdbId'] = highly_rated_popular_movies['tmdbId'].apply(lambda x: int(x))

    return highly_rated_popular_movies.sort_values('Views', ascending=False).head(10)

refined_dataset = merged.groupby(by=['userId', 'title'], as_index=False).agg({"rating": "mean"})

user_to_movie_df = refined_dataset.pivot(
    index='userId',
    columns='title',
    values='rating').fillna(0)

user_to_movie_sparse_df = csr_matrix(user_to_movie_df.values)
knn_model = NearestNeighbors(metric='cosine', algorithm='brute')
knn_model.fit(user_to_movie_sparse_df)


def get_similar_users(user, n=5):
    ## input to this function is the user and number of top similar users you want.

    knn_input = np.asarray([user_to_movie_df.values[user - 1]])  # .reshape(1,-1)
    # knn_input = user_to_movie_df.iloc[0,:].values.reshape(1,-1)
    distances, indices = knn_model.kneighbors(knn_input, n_neighbors=n + 1)

    print("Top", n, "users who are very much similar to the User-", user, "are: ")
    print(" ")
    for i in range(1, len(distances[0])):
        print(i, ". User:", indices[0][i] + 1, "separated by distance of", distances[0][i])
    return indices.flatten()[1:] + 1, distances.flatten()[1:]


def recommender_system(user_id, n_similar_users, n_movies):  # , user_to_movie_df, knn_model):

    print("Movie seen by the User:")
    pprint(list(refined_dataset[refined_dataset['userId'] == user_id]['title']))
    print("")

    def get_similar_users(user, n=5):
        knn_input = np.asarray([user_to_movie_df.values[user - 1]])
        distances, indices = knn_model.kneighbors(knn_input, n_neighbors=n + 1)
        print("Top", n, "users who are very much similar to the User-", user, "are: ")
        print(" ")

        for i in range(1, len(distances[0])):
            print(i, ". User:", indices[0][i] + 1, "separated by distance of", distances[0][i])
        print("")
        return indices.flatten()[1:] + 1, distances.flatten()[1:]

    def filtered_movie_recommendations(n=10):

        first_zero_index = np.where(mean_rating_list == 0)[0][-1]
        sortd_index = np.argsort(mean_rating_list)[::-1]
        sortd_index = sortd_index[:list(sortd_index).index(first_zero_index)]
        n = min(len(sortd_index), n)
        movies_watched = list(refined_dataset[refined_dataset['userId'] == user_id]['title'])
        filtered_movie_list = list(movies_list[sortd_index])
        count = 0
        final_movie_list = []
        for i in filtered_movie_list:
            if i not in movies_watched:
                count += 1
                final_movie_list.append(i)
            if count == n:
                break
        if count == 0:
            print(
                "There are no movies left which are not seen by the input users and seen by similar users. May be increasing the number of similar users who are to be considered may give a chance of suggesting an unseen good movie.")
        else:
            pprint(final_movie_list)

    similar_user_list, distance_list = get_similar_users(user_id, n_similar_users)
    weightage_list = distance_list / np.sum(distance_list)
    mov_rtngs_sim_users = user_to_movie_df.values[similar_user_list]
    movies_list = user_to_movie_df.columns
    weightage_list = weightage_list[:, np.newaxis] + np.zeros(len(movies_list))
    new_rating_matrix = weightage_list * mov_rtngs_sim_users
    mean_rating_list = new_rating_matrix.sum(axis=0)
    print("")
    print("Movies recommended based on similar users are: ")
    print("")
    filtered_movie_recommendations(n_movies)


movie_to_user_df = refined_dataset.pivot(
    index='title',
    columns='userId',
    values='rating').fillna(0)
movie_to_user_sparse_df = csr_matrix(movie_to_user_df.values)
movies_list = list(movie_to_user_df.index)
movie_dict = {movie: index for index, movie in enumerate(movies_list)}
case_insensitive_movies_list = [i.lower() for i in movies_list]

knn_movie_model = NearestNeighbors(metric='cosine', algorithm='brute')
knn_movie_model.fit(movie_to_user_sparse_df)


class invalid(Exception):
    pass


def get_similar_movies(movie, n=10):
    ## input to this function is the movie and number of top similar movies you want.
    index = movie_dict[movie]
    knn_input = np.asarray([movie_to_user_df.values[index]])
    n = min(len(movies_list) - 1, n)
    distances, indices = knn_movie_model.kneighbors(knn_input, n_neighbors=n + 1)

    print("Top", n, "movies which are very much similar to the Movie-", movie, "are: ")
    print(" ")
    for i in range(1, len(distances[0])):
        print(movies_list[indices[0][i]])


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


def spell_correction(movie_name, num_recom=10):
    try:
        movie_name_lower = movie_name.lower()
        if movie_name_lower not in case_insensitive_movies_list:
            raise invalid
        else:
            # movies_list[case_insensitive_country_names.index(movie_name_lower)]
            return get_similar_movies(movies_list[case_insensitive_movies_list.index(movie_name_lower)], num_recom)

    except invalid:

        possible_movies = get_possible_movies(movie_name_lower)

        if len(possible_movies) == len(movies_list):
            print("Movie name entered is does not exist in the list ")
        else:
            indices = [case_insensitive_movies_list.index(i) for i in possible_movies]
            print(
                "Entered Movie name is not matching with any movie from the dataset . Please check the below suggestions :\n",
                [movies_list[i] for i in indices])




