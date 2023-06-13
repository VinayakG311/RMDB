import ast
import re

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from scipy import stats
from ast import literal_eval
from sklearn.feature_extraction.text import TfidfVectorizer, CountVectorizer
from sklearn.metrics.pairwise import linear_kernel, cosine_similarity
from nltk.stem.snowball import SnowballStemmer
from nltk.stem.wordnet import WordNetLemmatizer
from nltk.corpus import wordnet
from surprise import Reader, Dataset, SVD
from surprise.model_selection import cross_validate
import requests
import warnings
warnings.simplefilter('ignore')

ratings = pd.read_csv("Data/ml-25m/ratings.csv")
movies = pd.read_csv("Data/ml-25m/movies.csv")
links=pd.read_csv("Data/ml-25m/links.csv")

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
    rec_percentages=rec_percentages.merge(movies, left_index=True, right_on="movieId")
    data=pd.DataFrame()
    data['movieId']=rec_percentages['movieId']
    data['title']=rec_percentages['title']
    data['genres']=rec_percentages['genres']

    data=data.merge(links,on="movieId")
    data['tmdbId']=data['tmdbId'].apply(lambda x: int(x))
    print(data.head().to_string())

    return data.head(10)



def getsimilarmovie(title):
    val = search(title)

    return(find_similar_movies(val.iloc[0]['movieId']))

