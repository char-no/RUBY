require 'gosu'

class Goldcoin
    def initialize
        assetsfolder = "D:/ruby_projects/platformer/assets/"
        gold1_loc = assetsfolder+"gold_1.PNG"
        gold2_loc = assetsfolder+"gold_2.PNG"
        gold3_loc = assetsfolder+"gold_3.PNG"
        gold4_loc = assetsfolder+"gold_4.PNG"
        @gold1 = Gosu::Image.new(gold1_loc)
        @gold2 = Gosu::Image.new(gold2_loc)
        @gold3 = Gosu::Image.new(gold3_loc)
        @gold4 = Gosu::Image.new(gold4_loc)
        @x = @y = 0
        @status = 1
    end

    def warp(x,y)
        @x,@y = x,y
    end
    
    def getx
        @x
    end
    def gety
        @y
    end

    def draw
        case @status
            when 1
                @gold1.draw(@x,@y,1,scale_x=0.25, scale_y=0.25)
            when 2
                @gold2.draw(@x,@y,1,scale_x=0.25, scale_y=0.25)
            when 3
                @gold3.draw(@x,@y,1,scale_x=0.25, scale_y=0.25)
            when 4
                @gold4.draw(@x,@y,1,scale_x=0.25, scale_y=0.25)
            else

        end
    end

    def update
        leftoverseconds = Gosu.milliseconds%750
        case (leftoverseconds)
            when 0..124
                @status = 1
            when 125..249
                @status = 2
            when 250..374
                @status = 3
            when 500..624
                @status = 3
            when 625..749
                @status = 2
            else
                @status = 4
        end
    end

    def delete
        @status = 5
    end
end