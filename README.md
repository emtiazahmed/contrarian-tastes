# Contrarian Tastes 

Using Hadoop MapReduce, Apache Spark, or another distributed computing technology, analyze the [Netflix Prize Dataset](http://academictorrents.com/details/9b13183dc4d60676b773c9e2cd6de5e5542cee9a). (Click the "Download" link in the upper right corner, not the "uci.edu" URL near the bottom of the page.) The README in that file describes the format of the data.

We're looking for movies that are well-loved by users who dislike movies most users like.

Find the _M_ movies which have been rated the highest across all users (of movies which have been rated by at least _R_ users). (If there's a tie for the _Mth_ spot, prefer most recent publication then alphabetical order of title.) These are the "top movies."

Of users who have rated all top _M_ movies, find the _U_ users which have given the lowest average rating of the _M_ movies. (If there's a tie for the _Uth_ spot, prefer users with the lower ID.) These are the "contrarian users."

For the _U_ contrarian users, find each user's highest ranked movie. (If there's a tie for each user's top spot, prefer most recent publication then alphabetical order of title.)

Prepare a CSV report with the following columns:

- User ID of contrarian user
- Title of highest rated movie by contrarian user
- Year of release of that movie
- Date of rating of that movie

Note: You will be graded on:
- Correctness
- Completeness of solution
- Unit tests
- Documentation
- Clarity of code

Note: _M_, _U_, and _R_ should be configurable. The recommended default values for the parameters are _M_ = 5, _U_ = 25, and _R_ = 50.

Note: The dataset that you see is a subset of the production data. The number of movies in in the hundreds of thousands and the number of users is in tens of millions. Design accordingly.

Note: If you are unable to complete the full requirements in time, please document what work remains.


# File Formats

mv_xxxxx.txt

MovieID,CustomerID,Rating,Date

- MovieIDs range from 1 to 17770 sequentially.
- CustomerIDs range from 1 to 2649429, with gaps. There are 480189 users.
- Ratings are on a five star (integral) scale from 1 to 5.
- Dates have the format YYYY-MM-DD.
- 

movie_titles.txt

MovieID,Year,Title

