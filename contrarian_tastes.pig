

%default M 5;
%default U 25;
%default R 50;

movie_titles = LOAD '/user/imtiaz/netflix/data/movies/m.txt' USING PigStorage(',') AS (
	movie_id: int, 
	year: int, 
	title: chararray);

ratings = LOAD '/user/imtiaz/netflix/data/ratings/mv_*.txt' USING PigStorage(',') AS (
	movie_id: int, 
	customer_id: long, 
	rating: int, 
	rating_date: chararray);

ratings_grp = GROUP ratings BY movie_id;

movie_ratings = FOREACH ratings_grp {
	unique_customers = DISTINCT ratings.customer_id
	GENERATE 
	FLATTEN(group) as movie_id,
	AVG(ratings.rating) as average_rating,
	COUNT(unique_customers) customers_count,
};

-- Keeping only records where number of customers who rated is greater than equal to R as we don't need others

movie_ratings_filtered = FILTER movie_ratings BY customers_count >= $R;

-- Replicated Join will increase performance by loading movie titles in memory as the size of the data is small

movie_ratings_enhanced = JOIN movie_ratings_filtered BY movie_id, movie_titles BY movie_id USING 'replicated';

movie_ratings_enhanced = FOREACH movie_ratings_enhanced
	GENERATE
	movie_ratings::movie_id as movie_id,
	movie_ratings::average_rating as average_rating,
	movie_titles:: year as year,
	movie_titles::title as title;


movie_ratings_ordered = ORDER movie_ratings_enhanced BY average_rating DESC, year DESC, title ASC;

-- Selecting Top M rated movies only

top_m_movies = LIMIT movie_ratings_ordered $M;

top_m_movies = FOREACH top_m_movies
	GENERATE
	movie_id;

ratings_slimmed = FOREACH ratings
	GENERATE
	movie_id,
	customer_id,
	rating;

top_m_ratings_joined = JOIN ratings_slimmed BY movie_id, top_m_movies BY movie_id USING 'replicated';

user_ratings = FOREACH top_m_ratings_joined
	GENERATE
	ratings_slimmed::movie_id as movie_id,
	ratings_slimmed::customer_id as customer_id,
	ratings_slimmed::rating as rating;

user_ratings_grouped = GROUP user_ratings BY customer_id;

average_user_ratings = FOREACH user_ratings_grouped {
	GENERATE 
	FLATTEN(group) as customer_id,
	AVG(user_ratings.rating) as average_rating,
};

average_user_ratings_ordered = ORDER average_user_ratings BY average_rating DESC, customer_id ASC;

u_users = LIMIT average_user_ratings_ordered $U;

users = FOREACH u_users
	GENERATE
	customer_id;










