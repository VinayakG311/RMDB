import pandas as pd
import requests



api_key = "a4f935f84a9c541b12ffe03282cb7337"


def get_movies(lang, freq):
    url = 'https://api.themoviedb.org/3/movie/popular?api_key={api_key}'.format(
        api_key=api_key)
    # print(url)
    movies = []
    page = 0
    progress = 0
    while movies.__len__() < freq:
        try:
            res = requests.get(url + "&page=" + str(page))
        except:
            raise 'not connected to internet or movidb issue'

        if res.status_code != 200:
            print(res.status_code)
            print('error')
            return []

        res = res.json()

        if 'errors' in res.keys():
            print('api error !!!')
            return movies

        movies = movies + res['results']

        if progress != round(len(movies) / freq * 100):
            progress = round(len(movies) / freq * 100)
            if progress % 5 == 0:
                print(progress, end="%, ")

        page = page + 1
        # break
        # print(res)
    return movies



def get_credits(ids):
    credits = []
    url = 'https://api.themoviedb.org/3/movie/{movie_id}/credits?api_key={api_key}'.format(api_key=api_key,
                                                                                           movie_id=ids)
    try:
        res = requests.get(url)
    except:
        print("hi")
        raise 'not connected to internet or movidb issue'
    if res.status_code != 200:
        print('error')
        return []
    res = res.json()
    if 'errors' in res.keys():
        print('api error !!!')
        return credits
        # print(res)
    credits.append(res)

    return credits


def get_keywords(id):
    keywords = []
    url = 'https://api.themoviedb.org/3/movie/{movie_id}/keywords?api_key={api_key}'.format(api_key=api_key,
                                                                                            movie_id=id)
    try:
        res = requests.get(url)
    except:
        raise 'not connected to internet or movidb issue'

    if res.status_code != 200:
        print('error')
        return []

    res = res.json()

    if 'errors' in res.keys():
        print('api error !!!')
        return keywords
        # print(res)
    keywords.append(res)
    return keywords


def CreateMoviesCsvpk():
    movies =[]
    for i in range(5):
        movies.append(get_movies("en", 10))
    print(movies)
    # df = pd.DataFrame(movies, columns=['genre_ids', 'id', 'original_language',
    #                                    'overview', 'popularity', 'release_date', 'title', 'vote_average',
    #                                    'vote_count'])
    # df.to_csv('movies_dataset.csv', index=False)
    # df.to_pickle('movies_dataset.pk', )

CreateMoviesCsvpk()


def CreateCastCrewcsv():
    id = data['id'].tolist()
    cast = []
    for i in id:
        casts = get_credits(i)
        cast.append(casts)

    new_movie_credits = {'cast': [], 'crew': []}
    for movie_credit in cast:

        new_movie_credits['cast'].append({'id': movie_credit[0]['id'], 'cast': []})
        for credit in movie_credit[0]['cast']:
            new_movie_credits['cast'][-1]['cast'].append({
                'cast_id': credit['id'],
                'name': credit['name'],
                'character': credit['character'],
            })
            # break

        new_movie_credits['crew'].append({'id': movie_credit[0]['id'], 'crew': []})
        for crew in movie_credit[0]['crew']:
            new_movie_credits['crew'][-1]['crew'].append({
                'crew_id': crew['id'],
                'name': crew['name'],
                'department': crew['department'],
            })
        # break

    cast_df = pd.DataFrame(new_movie_credits['cast'])
    crew_df = pd.DataFrame(new_movie_credits['crew'])

    cast_df.to_csv('cast_dataset.csv', index=False)
    crew_df.to_csv('crew_dataset.csv', index=False)


def CreateKeywordscsv():
    id = data['id'].tolist()
    movie_keywords = []
    for i in id:
        movie = get_keywords(i)
        movie_keywords.append(movie[0])

    keywords_df = pd.DataFrame(movie_keywords)
    keywords_df.to_csv('keywords_dataframe.csv')

'''
MOVIES
Action          28
Adventure       12
Animation       16
Comedy          35
Crime           80
Documentary     99
Drama           18
Family          10751
Fantasy         14
History         36
Horror          27
Music           10402
Mystery         9648
Romance         10749
Science Fiction 878
TV Movie        10770
Thriller        53
War             10752
Western         37'''

'''
TV SHOW
Action & Adventure  10759
Animation           16
Comedy              35
Crime               80
Documentary         99
Drama               18
Family              10751
Kids                10762
Mystery             9648
News                10763
Reality             10764
Sci-Fi & Fantasy    10765
Soap                10766
Talk                10767
War & Politics      10768
Western             37'''


# movies=pd.read_csv("Data/ml-latest-small/movies.csv")
# ratings=pd.read_csv("Data/ml-latest-small/ratings.csv")
# tags=pd.read_csv("Data/ml-latest-small/tags.csv")
#
# data=ratings.merge(movies,on="movieId",how="left")
#
#
# data=data.drop(['timestamp'],axis=1)
#
# Average_ratings = pd.DataFrame(data.groupby('title')['rating','movieId'].mean())
# Average_ratings['Total Ratings'] = pd.DataFrame(data.groupby('title')['rating'].count())
# #Average_ratings=Average_ratings.sort_values(by="rating",ascending=False)
# # print(Average_ratings.head())
# movie_user = data.pivot_table(index='userId',columns='title',values='rating')
# # print(movie_user.head())
# correlations = movie_user.corrwith(movie_user['Toy Story (1995)'])
# print(correlations.head())


# genres = {
#     'Action': 28, 'Adventure': 12, 'Animation': 16, 'Comedy': 35, 'Crime': 80, 'Documentary': 99, 'Drama': 18,
#     'Family': 10751, 'Fantasy': 14, 'History': 36, 'Horror': 27, 'Music': 10402, 'Mystery': 9648, 'Romance': 10749,
#     'Science Fiction': 878, 'TV Movie': 10770, 'Thriller': 53, 'War': 10752, 'Western': 37}
# d={}
# for k,v in genres.items():
#     d[v]=k
# print(d)