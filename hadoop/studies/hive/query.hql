create or replace view topMovieIDs AS
  select
	  movieID, count(movieID) as ratingCount, avg(rating) as ratingAVG
  from
	  ratings
  group by
	  movieID
  order by ratingCount DESC;

select 
	names.movienames, topMovieIDs.ratingCount, topMovieIDs.ratingAVG
from
	topMovieIDs
	join names on topMovieIDs.movieID = names.movieID
where
	topMovieIDs.ratingCount > 10
order by
	topMovieIDs.ratingAVG desc;
