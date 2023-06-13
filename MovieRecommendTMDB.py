import ast
import re
from pprint import pprint
import tensorflow as tf
from tensorflow.python.keras.layers import embeddings

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

from scipy import stats
from ast import literal_eval

from scipy.sparse import csr_matrix
from sklearn.feature_extraction.text import TfidfVectorizer, CountVectorizer
from sklearn.metrics.pairwise import linear_kernel, cosine_similarity
from nltk.stem.snowball import SnowballStemmer
from nltk.stem.wordnet import WordNetLemmatizer
from nltk.corpus import wordnet
from sklearn.model_selection import train_test_split
from sklearn.neighbors import NearestNeighbors
from sklearn.preprocessing import LabelEncoder
from surprise import Reader, Dataset, SVD
from surprise.model_selection import cross_validate
import requests
import warnings

warnings.simplefilter('ignore')
# api_key = "a4f935f84a9c541b12ffe03282cb7337"
# genres = {
#     'Action': 28, 'Adventure': 12, 'Animation': 16, 'Comedy': 35, 'Crime': 80, 'Documentary': 99, 'Drama': 18,
#     'Family': 10751, 'Fantasy': 14, 'History': 36, 'Horror': 27, 'Music': 10402, 'Mystery': 9648, 'Romance': 10749,
#     'Science Fiction': 878, 'TV Movie': 10770, 'Thriller': 53, 'War': 10752, 'Western': 37}
#
# genreid = {28: 'Action', 12: 'Adventure', 16: 'Animation', 35: 'Comedy', 80: 'Crime', 99: 'Documentary', 18: 'Drama',
#            10751: 'Family', 14: 'Fantasy', 36: 'History', 27: 'Horror', 10402: 'Music', 9648: 'Mystery',
#            10749: 'Romance', 878: 'Science Fiction', 10770: 'TV Movie', 53: 'Thriller', 10752: 'War', 37: 'Western'}
#
# data = pd.read_csv("Data/Dataset-small/movies_dataset.csv", lineterminator="\n")
# vote_counts = data[data['vote_count'].notnull()]['vote_count'].astype('int')
# vote_averages = data[data['vote_average'].notnull()]['vote_average'].astype('int')
#
# C = vote_averages.mean()
# m = vote_counts.quantile(0.95)
# data['year'] = pd.to_datetime(data['release_date'], errors='coerce').apply(
#     lambda x: str(x).split('-')[0] if x != np.nan else np.nan)
#
#
# def weighted_rating(x):
#     global C, m
#     v = x['vote_count']
#     R = x['vote_average']
#     return (v / (v + m) * R) + (m / (m + v) * C)
#
#
# s = data.apply(lambda x: pd.Series(ast.literal_eval(x['genre_ids'])), axis=1).stack().reset_index(level=1, drop=True)
# s.name = 'genre'
# gen_md = data.drop('genre_ids', axis=1).join(s)
# data.rename(columns={'genre_ids': 'genre'}, inplace=True)
#
#
# def build_chart(genre, percentile=0.85):
#     df = gen_md[gen_md['genre'] == float(genre)]
#
#     vote_counts = df[df['vote_count'].notnull()]['vote_count'].astype('int')
#     vote_averages = df[df['vote_average'].notnull()]['vote_average'].astype('int')
#     C = vote_averages.mean()
#     m = vote_counts.quantile(percentile)
#
#     qualified = df[(df['vote_count'] >= m) & (df['vote_count'].notnull()) & (df['vote_average'].notnull())][
#         ['genre_ids', 'id', 'original_language',
#          'overview', 'popularity', 'release_date', 'title', 'vote_average',
#          'vote_count', 'year']]
#     qualified['vote_count'] = qualified['vote_count'].astype('int')
#     qualified['vote_average'] = qualified['vote_average'].astype('int')
#
#     qualified['wr'] = qualified.apply(weighted_rating, axis=1)
#     qualified = qualified.sort_values('wr', ascending=False).head(250)
#
#     return qualified
#
#
# #
# # print(build_chart(genres['Romance']).head(15).to_string())
#
# small = data[data['id'].notnull()]
# small['overview'] = small['overview'].fillna('')
#
# tf = TfidfVectorizer(analyzer='word', ngram_range=(1, 2), min_df=0, stop_words='english')
# tfidf_matrix = tf.fit_transform(small['overview'])
# cosine_sim = linear_kernel(tfidf_matrix, tfidf_matrix)
# small = small.reset_index()
# titles = small['title']
# indices = pd.Series(small.index, index=small['title'])
#
#
# def get_recommendations(title):
#     idx = indices[title]
#     sim_scores = list(enumerate(cosine_sim[idx]))
#     sim_scores = sorted(sim_scores, key=lambda x: x[1], reverse=True)
#     sim_scores = sim_scores[1:31]
#     movie_indices = [i[0] for i in sim_scores]
#     return titles.iloc[movie_indices]
#
#
# cast = pd.read_csv('Data/Dataset-small/cast_dataset.csv')
# crew = pd.read_csv('Data/Dataset-small/crew_dataset.csv')
# keywords = pd.read_csv('Data/Dataset-small/keywords_dataframe.csv')
# data = data.merge(cast)
# data = data.merge(crew)
# data = data.merge(keywords)
# smd = data
# smd['cast'] = smd['cast'].apply(literal_eval)
# smd['crew'] = smd['crew'].apply(literal_eval)
# smd['keywords'] = smd['keywords'].apply(literal_eval)
#
# smd['cast_size'] = smd['cast'].apply(lambda x: len(x))
# smd['crew_size'] = smd['crew'].apply(lambda x: len(x))
# smd['keywords'] = smd['keywords'].apply(lambda x: [i['name'] for i in x] if isinstance(x, list) else [])
#
#
# def get_director(x):
#     for i in x:
#         if i['department'] == 'Directing':
#             return i['name']
#     return np.nan
#
#
# smd['director'] = smd['crew'].apply(get_director)
# smd['cast'] = smd['cast'].apply(lambda x: [i['name'] for i in x] if isinstance(x, list) else [])
# smd['cast'] = smd['cast'].apply(lambda x: x[:3] if len(x) >= 3 else x)
# smd['cast'] = smd['cast'].apply(lambda x: [str.lower(i.replace(" ", "")) for i in x])
# smd['director'] = smd['director'].astype('str').apply(lambda x: str.lower(x.replace(" ", "")))
# smd['director'] = smd['director'].apply(lambda x: [x, x, x])
#
# s = smd.apply(lambda x: pd.Series(x['keywords']), axis=1).stack().reset_index(level=1, drop=True)
# s.name = 'keyword'
# s = s.value_counts()
#
# s = s[s > 1]
# stemmer = SnowballStemmer('english')
#
#
# def filter_keywords(x):
#     words = []
#     for i in x:
#         if i in s:
#             words.append(i)
#     return words
#
#
# smd['keywords'] = smd['keywords'].apply(filter_keywords)
# smd['keywords'] = smd['keywords'].apply(lambda x: [stemmer.stem(i) for i in x])
# smd['keywords'] = smd['keywords'].apply(lambda x: [str.lower(i.replace(" ", "")) for i in x])
# smd['genre'] = smd['genre'].apply(literal_eval)
# smd['genre'] = smd['genre'].apply(lambda x: [genreid[i] for i in x])
#
# # print(type(smd['genre'].head().tolist()[0]))
# # print(type(smd['keywords'].head().tolist()[0]))
# # print((smd['genre'].head().tolist()[0]))
# # print((smd['keywords'].head().tolist()[0]))
#
# smd['soup'] = smd['keywords'] + smd['cast'] + smd['director'] + smd['genre']
# smd['soup'] = smd['soup'].apply(lambda x: ' '.join(x))
#
# # print(smd.head().to_string())
# count = CountVectorizer(analyzer='word', ngram_range=(1, 2), min_df=0, stop_words='english')
# count_matrix = count.fit_transform(smd['soup'])
# cosine_sim2 = cosine_similarity(count_matrix, count_matrix)
# smd = smd.reset_index()
# titles2 = smd['title']
# indices2 = pd.Series(smd.index, index=smd['title'])
#
#
# def improved_recommendations(title):
#     global C, m
#     idx = indices2[title]
#     sim_scores = list(enumerate(cosine_sim2[idx]))
#     sim_scores = sorted(sim_scores, key=lambda x: x[1], reverse=True)
#     sim_scores = sim_scores[1:26]
#     movie_indices = [i[0] for i in sim_scores]
#
#     movies = smd.iloc[movie_indices][['title', 'vote_count', 'vote_average', 'year', 'director', 'cast', 'keywords']]
#     vote_counts = movies[movies['vote_count'].notnull()]['vote_count'].astype('int')
#     vote_averages = movies[movies['vote_average'].notnull()]['vote_average'].astype('int')
#     C = vote_averages.mean()
#     m = vote_counts.quantile(0.60)
#
#     qualified = movies[
#         (movies['vote_count'] >= m) & (movies['vote_count'].notnull()) & (movies['vote_average'].notnull())]
#     qualified['vote_count'] = qualified['vote_count'].astype('int')
#     qualified['vote_average'] = qualified['vote_average'].astype('int')
#     qualified['wr'] = qualified.apply(weighted_rating, axis=1)
#     qualified = qualified.sort_values('wr', ascending=False)
#     return qualified

