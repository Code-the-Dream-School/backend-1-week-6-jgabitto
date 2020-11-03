require "sinatra"

enable :sessions

def number_generator
    rand(1..100)
end

NUMBER = number_generator

GUESS_MESSAGES = {
    1 => "This is your 1st guess",
    2 =>  "This is your 2nd guess",
    3 =>  "This is your 3rd guess",
    4 =>  "This is your 4th guess",
    5 =>  "This is your 5th guess",
    6 =>  "This is your 6th guess",
    7 =>  "This is your last guess"    
}

HINT_MESSAGES = {
    :too_low => "Too low",
    :low =>  "Close, but low",
    :correct =>  "You guessed correctly!",
    :high =>  "Close, but high",
    :too_high =>  "Too high"  
}

get "/" do
    session[:guess_number] = 1
    erb :index
end

get "/start" do
    @guess_message = GUESS_MESSAGES[guess_number]
    erb :start
end

post "/start" do
    guess = params["guess"]

    if guess == NUMBER
        @hint_message = HINT_MESSAGES[:correct]
    elsif guess.between?(NUMBER - 10, Number + 10)
        @hint_message = HINT_MESSAGES[:correct]
    session[:guess_number] = guess_number + 1
    redirect "/start"
end