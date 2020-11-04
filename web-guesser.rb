require "sinatra"

enable :sessions

def number_generator
    rand(1..100)
end

GUESS_MESSAGES = {
    1 => "This is your 1st guess",
    2 =>  "This is your 2nd guess",
    3 =>  "This is your 3rd guess",
    4 =>  "This is your 4th guess",
    5 =>  "This is your 5th guess",
    6 =>  "This is your 6th guess",
    7 =>  "This is your last guess",
    8 => "Game Over"    
}

HINT_MESSAGES = {
    :too_low => "Too low",
    :low =>  "Close, but low",
    :correct =>  "You guessed correctly!",
    :high =>  "Close, but high",
    :too_high =>  "Too high",
    :game_over => "Sorry you suck!"  
}

get "/" do
    number = number_generator
    session[:number] = number

    session[:guess_number] = 1
    
    session[:hint_message] = nil
    
    erb :index
end

get "/start" do
    @number = session[:number]
    @guess_number = session[:guess_number]
    @guess_message = GUESS_MESSAGES[@guess_number]
    @hint_message = session[:hint_message]
    p @guess_message
    
    erb :start
end

post "/start" do
    guess = Integer(params["guess"])
    number = session[:number]
    @guess_number = session[:guess_number]

    if guess == number
        session[:hint_message] = HINT_MESSAGES[:correct]
    elsif guess.between?(number - 10, number)
        session[:hint_message] = HINT_MESSAGES[:low]
    elsif guess.between?(number, number + 10)
        session[:hint_message] = HINT_MESSAGES[:high]
    elsif guess < number && !guess.between?(number - 10, number)
        session[:hint_message] = HINT_MESSAGES[:too_low]
    else
        session[:hint_message] = HINT_MESSAGES[:too_high]
    end

    if @guess_number != 7
        session[:guess_number] = @guess_number + 1
    else
        session[:guess_number] = 8
        session[:hint_message] = HINT_MESSAGES[:game_over]
    end
    
    redirect "/start"
end