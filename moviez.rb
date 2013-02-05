require 'pg'
require 'pry'
require 'httparty'
require 'json'



def fetch_movie(title)
   HTTParty.get("http://www.omdbapi.com/?t=#{title}")
end

def menu
  puts `clear`
  puts 'Welcome to Moviez'
  puts '(A)dd, (V)iew, (Q)uit? '
  gets.chomp.downcase
end


def add_movie
  print 'Movie name: '
  title = gets.chomp.split.join('+')
  a = JSON(fetch_movie(title))

  title = a["Title"].gsub("'","")
  rated =  a["Rated"]
  year = a["Year"].to_i
  director = a["Director"].gsub("'","")
  plot = a["Plot"].gsub("'","")

  sql = "insert into movies (title, rated, year, director, plot) values ('#{title}', '#{rated}', #{year}, '#{director}', '#{plot}')"

  @conn.exec(sql)
  puts "#{title}, #{year}, directed by #{director} added to database."
end


def view_movies
  sql = ("select title, year, director from movies order by title;")
  @conn.exec(sql) do |result|
    result.each do |row|
      puts row['title'] + " -- "+ row['year'] + " -- " + row['director']
    end
  end
end

@conn = PG.connect(:dbname => 'moviez', :host => 'localhost')

response = menu
while response != 'q'
  case response
  when 'a' then add_movie; gets
  when 'v' then view_movies;gets
  end

  response = menu
end

@conn.close
