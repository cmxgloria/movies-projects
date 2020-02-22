     
require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'httparty'
require 'pg'

def run_sql(sql)
  conn = PG.connect(dbname: 'movies_app')
  result = conn.exec(sql)
  conn.close
  return result 
end

def movies_db(movie)
  sql = "INSERT INTO movies (title, poster, score, runtime, year, actors, director, plot, rating)
  VALUES ('#{movie['Title']}', '#{movie['Poster']}', '#{movie['Metascore']}', '#{movie['Runtime']}',
     '#{movie['Year']}', '#{movie['Actors']}', '#{movie['Director']}', '#{movie['Plot']}'
     , '#{movie['Ratings']}');"
  results = run_sql(sql)
end

get '/movie/:title' do
  # raise 'checking'
  sql = "SELECT * FROM movies WHERE title = '#{params[:title]}';"
  @title = params[:title]
    @url = "http://omdbapi.com/?t=#{@title}&apikey=#{ENV['OMDB_API_KEY'] }"
    @result = HTTParty.get(@url)
    @img = @result['Poster']
    @title = @result['Title']
    @score = @result['Metascore']
    @runtime = @result['Runtime']
    @year = @result['Year']
    @actors = @result['Actors']
    @director = @result['Director']
    @rating = @result['Ratings']
    @plot = @result['Plot']

  search_movie = run_sql(sql)
  if search_movie.count >= 1
    @find_movie = "Exiting in DB"
    @movie = search_movie.first
    
  else
    @find_movie = "request from OMDB"
    @movie = HTTParty.get('http://omdbapi.com/?t=' + params[:title] + '&apikey=' + ENV['OMDB_API_KEY'])
    movies_db(@movie)
  end
  erb :movie
end
 
get '/' do
  erb :index
end

get '/movies' do
  puts params.inspect
  @title = params[:title]
  @url = "http://omdbapi.com/?s=#{@title}&apikey=#{ENV['OMDB_API_KEY'] }"
  @result = HTTParty.get(@url)
  erb :movies
end

# http://localhost:4567/movies?title=jaws find all jaws movies




