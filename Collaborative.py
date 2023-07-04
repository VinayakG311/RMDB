import re

from scipy.sparse import csr_matrix
from sklearn.neighbors import NearestNeighbors
import warnings

import numpy as np
import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity

warnings.simplefilter('ignore')

ratings = pd.read_csv("Data/ml-25m/ratings.csv")
movies = pd.read_csv("Data/ml-25m/movies.csv")
links = pd.read_csv("Data/ml-25m/links.csv")
movies2 = pd.read_csv("Data/ml-25m/movies.csv")

def clean_title(title):
    title = re.sub("[^a-zA-Z0-9 ]", "", title)
    return title


movies["clean_title"] = movies["title"].apply(clean_title)
vectorizer = TfidfVectorizer(ngram_range=(1, 2))
tfidf = vectorizer.fit_transform(movies["title"])


def search(title):
    query_vec = vectorizer.transform([title])
    similarity = cosine_similarity(query_vec, tfidf).flatten()
    indices = np.argpartition(similarity, -5)[-5:]

    results = movies.iloc[indices].iloc[::-1]

    return results


def find_similar_movies(movie_id):
    similar_users = ratings[(ratings["movieId"] == movie_id) & (ratings["rating"] > 4)]["userId"].unique()
    similar_user_recs = ratings[(ratings["userId"].isin(similar_users)) & (ratings["rating"] > 4)]["movieId"]
    similar_user_recs = similar_user_recs.value_counts() / len(similar_users)
    similar_user_recs = similar_user_recs[similar_user_recs > .10]
    all_users = ratings[(ratings["movieId"].isin(similar_user_recs.index)) & (ratings["rating"] > 4)]
    all_user_recs = all_users["movieId"].value_counts() / len(all_users["userId"].unique())
    rec_percentages = pd.concat([similar_user_recs, all_user_recs], axis=1)
    rec_percentages.columns = ["similar", "all"]

    rec_percentages["score"] = rec_percentages["similar"] / rec_percentages["all"]
    rec_percentages = rec_percentages.sort_values("score", ascending=False)
    rec_percentages = rec_percentages.merge(movies, left_index=True, right_on="movieId")
    data = pd.DataFrame()
    data['movieId'] = rec_percentages['movieId']
    data['title'] = rec_percentages['title']
    data['genres'] = rec_percentages['genres']

    data = data.merge(links, on="movieId")
    data['tmdbId'] = data['tmdbId'].apply(lambda x: int(x))
    print(data.head().to_string())

    return data.head(10)


def getsimilarmovie(title):
    val = search(title)

    return find_similar_movies(val.iloc[0]['movieId'])


def GetSimilarMovies(title):
    merged_dataset = pd.merge(ratings, movies2, how='inner', on='movieId')
    combine_movie_rating = merged_dataset.dropna(axis=0, subset=['title'])
    movie_features_df = combine_movie_rating.pivot_table(index='title', columns='userId', values='rating').fillna(0)
    movie_features_df_matrix = csr_matrix(movie_features_df.values)

    model_knn = NearestNeighbors(metric='cosine', algorithm='brute')
    model_knn.fit(movie_features_df_matrix)
    # print(movie_features_df)
    name = movie_features_df[movie_features_df.index.get_level_values('title') == title]
  #  name2 = movie_features_df[movie_features_df.index == 'Colonia (2016)']
   # print(merged_dataset[merged_dataset['title']=='Colonia (2016)'])
   # print(name2)
    query_index = np.random.choice(movie_features_df.shape[0])
    distances, indices = model_knn.kneighbors(name.values.reshape(1, -1), n_neighbors=15)

    for i in range(0, len(distances.flatten())):
        print(movie_features_df.index[indices.flatten()[i]])


#GetSimilarMovies('Colonia (2016)')
#getsimilarmovie('Colonia (2016)')
