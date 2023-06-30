import numpy as np
import pandas as pd
import tensorflow as tf
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
from keras.models import load_model
# import firebase_admin
# from firebase_admin import credentials
# from firebase_admin import firestore
# cred = credentials.Certificate("rmdb-fed2d-firebase-adminsdk-b3idn-5bc8b71d4b.json")
# firebase_admin.initialize_app(cred)
# firestore_client = firestore.client()



movies = pd.read_csv("Data/ml-latest-small/movies.csv")
ratings = pd.read_csv("Data/ml-latest-small/ratings.csv")
links = pd.read_csv("Data/ml-latest-small/links.csv")
# doc = firestore_client.collection('users').document("Q2lTkA7IQhTOiFPoSjjou3YckHK2").get().to_dict()
#
# moviesWatched = doc['MoviesWatched'][1:]
#
# dict={}
# userid=100000
# dict['userId']=[]
# dict['movieId']=[]
# dict['rating']=[]
# for i in moviesWatched:
#     for k,v in i.items():
#        # print(k,v)
#         id=(links.loc[links['tmdbId']==int(k)]['movieId'])
#         idl=id.to_list()
#         dict['userId'].append(userid)
#         dict['movieId'].append(idl[0])
#         dict['rating'].append(v)
# v=pd.DataFrame.from_dict(dict)
# links.append(v)
merged_dataset = pd.merge(ratings, movies, how='inner', on='movieId')
refined_dataset = merged_dataset.groupby(by=['userId', 'title'], as_index=False).agg({"rating": "mean"})
user_enc = LabelEncoder()
refined_dataset['user'] = user_enc.fit_transform(refined_dataset['userId'].values)
n_users = refined_dataset['user'].nunique()
item_enc = LabelEncoder()
refined_dataset['movie'] = item_enc.fit_transform(refined_dataset['title'].values)
n_movies = refined_dataset['movie'].nunique()
refined_dataset['rating'] = refined_dataset['rating'].values.astype(np.float32)
min_rating = min(refined_dataset['rating'])
max_rating = max(refined_dataset['rating'])

X = refined_dataset[['user', 'movie']].values
y = refined_dataset['rating'].values
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.1, random_state=50)
X_train_array = [X_train[:, 0], X_train[:, 1]]
X_test_array = [X_test[:, 0], X_test[:, 1]]

y_train = (y_train - min_rating) / (max_rating - min_rating)
y_test = (y_test - min_rating) / (max_rating - min_rating)
user = tf.keras.layers.Input(shape=(1,))
n_factors = 150




def recommender_systemknn(user_id, model, n_movies):
    encoded_user_id = user_enc.transform([user_id])
    data=refined_dataset[refined_dataset['userId'] == user_id]
    seen_movies = list(data['movie'])
    unseen_movies = [i for i in range(min(refined_dataset['movie']), max(refined_dataset['movie']) + 1) if
                     i not in seen_movies]
    model_input = [np.asarray(list(encoded_user_id) * len(unseen_movies)), np.asarray(unseen_movies)]
    predicted_ratings = model.predict(model_input)
    predicted_ratings = np.max(predicted_ratings, axis=1)
    sorted_index = np.argsort(predicted_ratings)[::-1]
    recommended_movies = item_enc.inverse_transform(sorted_index)
    dataset=pd.DataFrame()
    dataset["title"]=list(recommended_movies[:n_movies])
    dataset=dataset.merge(movies,on="title")
    dataset=dataset.merge(links,on="movieId")
    dataset['tmdbId']=dataset['tmdbId'].apply(lambda x:int(x))
    return dataset


#recommender_systemknn(100000,load_model("Moviemodel.model"),15)

# u = tf.keras.layers.Embedding(n_users, n_factors, embeddings_initializer='he_normal',
#                               embeddings_regularizer=tf.keras.regularizers.l2(1e-6))(user)
# u = tf.keras.layers.Reshape((n_factors,))(u)
# movie = tf.keras.layers.Input(shape=(1,))
# m = tf.keras.layers.Embedding(n_movies, n_factors, embeddings_initializer='he_normal',
#                               embeddings_regularizer=tf.keras.regularizers.l2(1e-6))(movie)
# m = tf.keras.layers.Reshape((n_factors,))(m)
# x = tf.keras.layers.Concatenate()([u, m])
# x = tf.keras.layers.Dropout(0.05)(x)
# x = tf.keras.layers.Dense(32, kernel_initializer='he_normal')(x)
# x = tf.keras.layers.Activation(activation='relu')(x)
# x = tf.keras.layers.Dropout(0.05)(x)
# x = tf.keras.layers.Dense(16, kernel_initializer='he_normal')(x)
# x = tf.keras.layers.Activation(activation='relu')(x)
# x = tf.keras.layers.Dropout(0.05)(x)
# x = tf.keras.layers.Dense(9)(x)
# x = tf.keras.layers.Activation(activation='softmax')(x)
# model = tf.keras.models.Model(inputs=[user, movie], outputs=x)
# #
# model.compile(optimizer='sgd', loss=tf.keras.losses.SparseCategoricalCrossentropy(), metrics=['accuracy'])
# print(model.summary())
# reduce_lr = tf.keras.callbacks.ReduceLROnPlateau(monitor='val_loss', factor=0.75, patience=3, min_lr=0.000001,
#                                                  verbose=1)
#
# history = model.fit(x=X_train_array, y=y_train, batch_size=128, epochs=70, verbose=1,
#                     validation_data=(X_test_array, y_test)
#                     , shuffle=True, callbacks=[reduce_lr])
# #
# model.save("Moviemodel.model",history)
# plt.plot(history.history["loss"][5:])
# plt.plot(history.history["val_loss"][5:])
# plt.title("model loss")
# plt.ylabel("loss")
# plt.xlabel("epoch")
# plt.legend(["train", "test"], loc="upper left")
# plt.show()