ratings = LOAD '/user/admin/ml-100k/u.data' AS (userID:int, movieID:int, rating:int,
												ratingTime:int);

metadata = LOAD '/user/admin/ml-100k/u.item' USING PigStorage('|')
	AS (movieID:int, movieTitle:chararray, releaseDate:chararray, videoRelease:chararray,
    	imdbLink:chararray);

nameLookup = FOREACH metadata GENERATE movieID, movieTitle,
	ToUnixTime(ToDate(releaseDate, 'dd-MMM-yyyy')) AS releaseTime;

ratingsByMovie = GROUP ratings BY movieID;

avgRatings = FOREACH ratingsByMovie GENERATE group AS movieID, AVG(ratings.rating) AS avgRating, 
	COUNT(ratings.rating) AS countRatings;

oneStarMovies = FILTER avgRatings BY avgRating < 2.0;

oneStarsWithData = JOIN oneStarMovies BY movieID, nameLookup BY movieID;
DESCRIBE oneStarsWithData;

mostReviewedOneStarMovies = ORDER oneStarsWithData BY oneStarMovies::countRatings DESC;
DESCRIBE mostReviewedOneStarMovies;

DUMP mostReviewedOneStarMovies;

