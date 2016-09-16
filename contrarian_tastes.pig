

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

movie_ratings_filtered = FILTER movie_ratings BY customers_count >= $R;

movie_ratings_enhanced = JOIN movie_ratings_filtered BY movie_id, movie_titles BY movie_id;

movie_ratings_enhanced = FOREACH movie_ratings_enhanced
	GENERATE
	movie_ratings::movie_id as movie_id,
	movie_ratings::average_rating as average_rating,
	movie_titles:: year as year,
	movie_titles::title as title;


movie_ratings_ordered = ORDER movie_ratings_enhanced BY average_rating DESC, year DESC, title ASC;

-- SELECT Top M rated movies

movie_ratings_top_m = LIMIT movie_ratings_ordered $M;








