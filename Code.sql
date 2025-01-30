-- Advance SQL Project __ Spotify Dataset

-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

-- EDA
SELECT COUNT(*) FROM spotify;

SELECT COUNT(DISTINCT artist) FROM spotify;

SELECT COUNT(DISTINCT album) FROM spotify;

SELECT album_type,COUNT(album_type)
FROM spotify
GROUP BY album_type;

SELECT MAX(duration_min) FROM spotify;
SELECT MIN(duration_min) FROM spotify;

SELECT * FROM spotify
WHERE duration_min = 0;

DELETE FROM spotify
WHERE duration_min = 0;

SELECT DISTINCT channel FROM spotify;

------------------------------------------------------
------------------------------------------------------
-- DATA ANALYSIS -- DATA ANALYSIS -- DATA ANYALISIS --
------------------------------------------------------
------------------------------------------------------


--1st Task : Retrieve the names of all tracks that have more than 1 billion streams.

SELECT stream 
FROM spotify
where stream > 1E9;

--2nd Task : List all albums along with their respective artists.

SELECT Album,Artist
FROM spotify
GROUP BY Album,Artist;

--3rd Task : Get the total number of comments for tracks where licensed = TRUE

SELECT Sum(Comments) as Total_Comments 
FROM spotify
WHERE licensed = TRUE;

--4th Task : Find all tracks that belong to the album type

SELECT *
FROM spotify
WHERE Album_type = 'single'

--5th Task : Count the total number of tracks by each artist.

SELECT Artist , COUNT(Track) as Total_no_Tracks FROM spotify
GROUP BY Artist

--6th Task : Calculate the average danceability of tracks in each album.

SELECT Album, AVG(Danceability) FROM SPOTIFY
GROUP BY Album

--7th Task : Find the top 5 tracks with the highest energy values.

SELECT Track, MAX(Energy) FROM spotify
GROUP BY Track
ORDER BY 2 DESC
LIMIT 5

--8th Task : List all tracks along with their views and likes where official_video = TRUE.

SELECT Track, SUM(views) as total_views, SUM(likes) as total_likes FROM spotify
WHERE official_video = 'TRUE'
GROUP BY 1
ORDER BY 2 DESC 

--9th Task : For each album, calculate the total views of all associated Tracks

SELECT Album ,Track,SUM(views)
FROM spotify
GROUP BY 1,2
ORDER BY 3 DESC

--10th Task : Retrieve the track names that have been streamed on Spotify more than YouTube.


SELECT * FROM
(
SELECT 
    track,
	COALESCE(SUM(CASE WHEN most_played_on = 'Youtube' Then stream END),0) AS streamed_on_youtube,
	COALESCE(SUM(CASE WHEN most_played_on = 'Spotify' Then stream END),0) AS streamed_on_spotify
FROM spotify	
GROUP BY 1
) AS t1
WHERE streamed_on_spotify > streamed_on_youtube
    AND 
	streamed_on_youtube <> 0;



-- 11th Task : Find the top 3 most-viewed tracks for each artist using window functions.

WITH ranking_artist AS (
    SELECT 
        artist,
        track,
        SUM(views) AS total_view,
        DENSE_RANK() OVER (PARTITION BY artist ORDER BY SUM(views) DESC) AS rank
    FROM spotify
    GROUP BY artist, track 
	ORDER BY 1, 3 DESC
)



-- 12TH Task : Write a query to find tracks where the liveness score is above the average.

SELECT 
    track,
    artist,
    liveness
FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify);


-- 13th Task : Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

WITH cte
AS
(SELECT 
	album,
	MAX(energy) as highest_energy,
	MIN(energy) as lowest_energery
FROM spotify
GROUP BY 1
)
SELECT 
	album,
	highest_energy - lowest_energery as energy_diff
FROM cte
ORDER BY 2 DESC

--14th Task : Find tracks where the energy-to-liveness ratio is greater than 1.2.


SELECT 
    track, 
    artist, 
    energy, 
    liveness, 
    (energy / NULLIF(liveness, 0)) AS energy_liveness_ratio
FROM spotify
WHERE (energy / NULLIF(liveness, 0)) > 1.2;




