# == Schema Information
#
# Table name: actors
#
#  id          :integer      not null, primary key
#  name        :string
#
# Table name: movies
#
#  id          :integer      not null, primary key
#  title       :string
#  yr          :integer
#  score       :float
#  votes       :integer
#  director_id :integer
#
# Table name: castings
#
#  movie_id    :integer      not null, primary key
#  actor_id    :integer      not null, primary key
#  ord         :integer

require_relative './sqlzoo.rb'

def example_join
  execute(<<-SQL)
    SELECT
      *
    FROM
      movies
    JOIN
      castings ON movies.id = castings.movie_id
    JOIN
      actors ON castings.actor_id = actors.id
    WHERE
      actors.name = 'Sean Connery'
  SQL
end

def ford_films
  # List the films in which 'Harrison Ford' has appeared.
  execute(<<-SQL)
  SELECT
    movies.title
  FROM
    movies
  JOIN
    castings ON movies.id = castings.movie_id
  JOIN
    actors ON castings.actor_id = actors.id
  WHERE
    actors.name = 'Harrison Ford'
  SQL
end

def ford_supporting_films
  # List the films where 'Harrison Ford' has appeared - but not in the star
  # role. [Note: the ord field of casting gives the position of the actor. If
  # ord=1 then this actor is in the starring role]
  execute(<<-SQL)
  SELECT
    movies.title
  FROM
    movies
  JOIN
    castings ON movies.id = castings.movie_id
  JOIN
    actors ON castings.actor_id = actors.id
  WHERE
    actors.name = 'Harrison Ford'
    AND
      castings.ord != 1
  SQL
end

def films_and_stars_from_sixty_two
  # List the title and leading star of every 1962 film.
  execute(<<-SQL)
  SELECT
    movies.title,
    actors.name
  FROM
    movies
  JOIN
    castings ON movies.id = castings.movie_id
  JOIN
    actors ON castings.actor_id = actors.id
  WHERE
    movies.yr = 1962
    AND
      castings.ord = 1
  SQL
end

def travoltas_busiest_years
  # Which were the busiest years for 'John Travolta'? Show the year and the
  # number of movies he made for any year in which he made at least 2 movies.
  execute(<<-SQL)
  SELECT
    movies.yr,
    count(movies.title)
  FROM
    movies
  JOIN
    castings ON movies.id = castings.movie_id
  JOIN
    actors ON castings.actor_id = actors.id
  WHERE
    actors.name = 'John Travolta'
  GROUP BY
    movies.yr
  HAVING
    count(movies.title) > 1
  SQL
end

def andrews_films_and_leads
  # List the film title and the leading actor for all of the films 'Julie
  # Andrews' played in.
  execute(<<-SQL)
  SELECT
    m.title,
    a.name
  FROM
    castings ja_castings
  JOIN
    actors ja on ja.id = ja_castings.actor_id
  JOIN
    castings c ON c.movie_id = ja_castings.movie_id
  JOIN
    actors a ON a.id = c.actor_id
  JOIN
    movies m ON m.id = ja_castings.movie_id
  WHERE
    ja.name = 'Julie Andrews'
    AND c.ord = 1
  SQL
end

def prolific_actors
  # Obtain a list in alphabetical order of actors who've had at least 15
  # starring roles.
  execute(<<-SQL)
    SELECT
      a.name
    FROM
      actors a
    JOIN
      castings c ON c.actor_id = a.id
    WHERE
      c.ord = 1
    GROUP BY
      a.name
    HAVING
      count(1) > 14
    ORDER BY
      a.name asc
  SQL
end

def films_by_cast_size
  # List the films released in the year 1978 ordered by the number of actors
  # in the cast (descending), then by title (ascending).
  execute(<<-SQL)
  SELECT
    title,
    count(castings.actor_id)
  FROM
    movies
  JOIN
    castings ON movies.id = castings.movie_id
  WHERE
    yr = 1978
  GROUP BY
    title
  ORDER BY
    count(castings.actor_id) DESC,
    title
  SQL
end

def colleagues_of_garfunkel
  # List all the people who have played alongside 'Art Garfunkel'.
  execute(<<-SQL)
  SELECT
    a.name
  FROM
    actors a
  JOIN
    castings c on a.id = c.actor_id
  JOIN
    castings ag_castings on c.movie_id = ag_castings.movie_id
  JOIN
    actors ag on ag_castings.actor_id = ag.id
  WHERE
    ag.name = 'Art Garfunkel'
    AND a.name != 'Art Garfunkel'
  -- SELECT
  --   actors.name
  -- FROM
  --   castings
  -- JOIN
  --   actors on castings.actor_id = actors.id
  -- WHERE
  --   castings.movie_id in (
  --     SELECT
  --       ag_castings.movie_id
  --     FROM
  --       castings ag_castings
  --     JOIN
  --       actors ag on ag_castings.actor_id = ag.id
  --     WHERE
  --       ag.name = 'Art Garfunkel'
  --   )
  --   AND
  --     actors.name != 'Art Garfunkel'
  SQL

end
