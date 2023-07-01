import os

import pandas

from MovieRecommenderMovieLens import spell_correction, recommender_system, recommendations_genre, \
    get_highly_rated_popular_movies
import requests

from Collaborative import getsimilarmovie
from CollaborativeKNN import recommender_systemknn
from CollaborativeSVD import recommender
from flask import Flask, request, jsonify
from keras.models import load_model

app = Flask(__name__)
api_key = "a4f935f84a9c541b12ffe03282cb7337"


# genres = {
#     'Action': 28, 'Adventure': 12, 'Animation': 16, 'Comedy': 35, 'Crime': 80, 'Documentary': 99, 'Drama': 18,
#     'Family': 10751, 'Fantasy': 14, 'History': 36, 'Horror': 27, 'Music': 10402, 'Mystery': 9648, 'Romance': 10749,
#     'Science Fiction': 878, 'TV Movie': 10770, 'Thriller': 53, 'War': 10752, 'Western': 37}

@app.route('/api/collaborative', methods=['GET'])
def returncollab():
    d = {}
    inputchr = str(request.args['query'])
    l = getsimilarmovie(inputchr)


    movies = l['tmdbId'].tolist()

    m = []
    for i in movies:
        url = 'https://api.themoviedb.org/3/movie/{id}?api_key={api_key}'.format(
            api_key=api_key, id=i)
        res = requests.get(url)

        res = res.json()
        m.append(res)

    k=[]
    for i in m:

        if('success' not in i):
            k.append(i)

    d['output'] = k
    return d


@app.route('/api/collabKNN', methods=['GET'])
def returncollabKNN():
    d = {}
    inputchr = str(request.args['query'])
    l = recommender_systemknn(int(inputchr), load_model("Moviemodel.model"), 15)
    movies = l['tmdbId'].head(25).tolist()
    m = []
    for i in movies:
        url = 'https://api.themoviedb.org/3/movie/{id}?api_key={api_key}'.format(
            api_key=api_key, id=i)
        res = requests.get(url)
        res = res.json()
        m.append(res)
    d['output'] = m
    return d


@app.route('/api/collabSVD', methods=['GET'])
def returncollabSVD():
    d = {}
    inputchr = str(request.args['query'])
    l = recommender(inputchr,15)
    movies = l['tmdbId'].tolist()

    m = []
    for i in movies:
        url = 'https://api.themoviedb.org/3/movie/{id}?api_key={api_key}'.format(
            api_key=api_key, id=i)
        res = requests.get(url)

        res = res.json()
        m.append(res)

    k=[]
    for i in m:

        if('success' not in i):
            k.append(i)

    d['output'] = k
    return d


@app.route('/api/popularmovie', methods=['GET'])
def returnpopularmovie():
    d = {}
    l = get_highly_rated_popular_movies()
    movies = l['tmdbId'].head(25).tolist()
    m = []
    for i in movies:
        url = 'https://api.themoviedb.org/3/movie/{id}?api_key={api_key}'.format(
            api_key=api_key, id=i)
        res = requests.get(url)
        res = res.json()
        m.append(res)
    d['output'] = m
    return d


@app.route('/api/genre', methods=['GET'])
def returngenre():
    d = {}
    inputchr = str(request.args['query'])
    #  k=int(request.args.get("number"))

    # print(inputchr)
    l = recommendations_genre(inputchr)
    #  print(l)
    movies = l['tmdbId'].tolist()
    m = []
    for i in movies:
        url = 'https://api.themoviedb.org/3/movie/{id}?api_key={api_key}'.format(
            api_key=api_key, id=i)
        res = requests.get(url)
        res = res.json()

        m.append(res)
    d['output'] = m
    return d


app.run(debug=False,host="0.0.0.0",port=int(os.getenv('PORT', 4444)))