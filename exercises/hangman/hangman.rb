require 'io/console'
require 'yaml'

class SaveProgress
    def initialize(word, guessed, strikes)
        @wd= word
        @gu = guessed
        @strk = strikes.to_i
    end

    #get methods
    def word
        @wd
    end
    def guessed
        @gu
    end
    def strikes
        @strk
    end

    def _dump level
        [@wd, @gu, @strk].join ':'
    end

    def self._load args
       new(*args.split(':'))
    end

end

filelocation = "D:/ruby_projects/exercises/hangman/5desk.txt"
savefile = "D:/ruby_projects/exercises/hangman/save.yml"
svtxt = "D:/ruby_projects/exercises/hangman/sv.txt"

choice = 0

puts "Press 1 to begin a new game, or 2 to load your last save."

while (choice == 0)
    n = gets.to_i
    if n == 1 || 2
        choice = n
    end
end

if choice == 2
    dt = (File.read(svtxt))
    p dt
    lastsave = SaveProgress._load(dt)
    guessthis = lastsave.word.chomp
    progress = lastsave.guessed.chomp
    strike = lastsave.strikes

    puts "Word: #{guessthis}"
    puts "Progress: #{progress}"
    puts "Strikes: #{strike}"

    outstanding = 0;
    for i in 0..progress.length
        if progress[i] == '-'
            outstanding+=1;
        end
    end
end

if choice == 1
    dictionary = File.open(filelocation, "r")
    words = dictionary.readlines
    dictionary.close

    guessthis = 'nop'

    while (guessthis.length < 5) || (guessthis.length > 12) do 
    #chomp gets rid of the newline character at the end of the word
    guessthis = words.sample.chomp
    end

    puts "This is the word selected: #{guessthis} and its length: #{guessthis.length}."

    charsecret = guessthis.scan /\w/

    strike = 0
    progress = ''
    outstanding = guessthis.length
    for i in 0..guessthis.length-1
        progress[i] = '-'
    end
end


while (outstanding > 0 && guessthis.casecmp(progress)!=0) do
        puts "Enter a letter to guess the word: "
        chinp = gets.chomp

        puts "This is the inputted character: #{chinp}."

        index = 0

        for i in 0..guessthis.length
        check = guessthis[i].to_s.casecmp(chinp) 
            break if check == 0 
        end
        

        if check < 0 || check > 0
            strike +=1
        else
            for i in 0..guessthis.length
                if (guessthis[i].to_s.casecmp(chinp) == 0)
                    progress[i] = guessthis[i]
                    outstanding -= 1
                end
            end
        end

        case strike
        when 0
            puts "Your human is not yet on the chopping block."
        when 1
            puts ' ('
        when 2
            puts ' ()'
        when 3
            puts ' ()
 |'
        when 4
            puts ' ()
 ||'
        when 5
            puts ' ()
=||'
        when 6
            puts ' ()
=||='
        when 7
            puts ' ()
=||=
 / '
        when 8..99
            puts '__
  |
 ()
=||=
 /\ '
    puts "Your human is dead. Game over. Your word was: #{guessthis}"
        break
        else
        puts "Invalid outcome."
        end

        puts "This is your progress: #{progress}."

    puts "Do you wish to save your progress and quit or continue?
    Enter 1 to save and quit.
    Enter 2 to continue."

    choix = gets.to_i

    if (choix == 1)
        sprogress = SaveProgress.new(guessthis, progress, strike)
        data = sprogress._dump(sprogress)
        File.open(svtxt, "w"){|f| f.write(data)}
        puts "Progress saved as: "
        p data
        exit
    end
end


    if (strike < 8)
    puts "Congrats! You guessed it: your word was #{progress}."
    end
