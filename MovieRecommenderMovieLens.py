import warnings
import pandas as pd
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

    return highly_rated_popular_movies.sort_values('Views', ascending=False).head(50)




