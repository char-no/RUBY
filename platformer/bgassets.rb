require 'gosu'
require 'fastimage'
load 'player.rb'
load 'pickups.rb'

class BGScreen < Gosu::Window
    def initialize
        @bgx = 800
        @bgy = 640
        super @bgx, @bgy

        assetsfolder = "D:/ruby_projects/platformer/assets/"
        bgloc = assetsfolder + "bg.PNG"
        castleL= assetsfolder + "castleHalfLeft.PNG"
        castleM= assetsfolder + "castleHalfMid.PNG"
        castleR = assetsfolder + "castleHalfRight.PNG"
        grassloc = assetsfolder + "grassMid.png"        

        @bg_img = Gosu::Image.new(bgloc, :tileable => true)
        @castL = Gosu::Image.new(castleL, :tileable => true)
        @castM = Gosu::Image.new(castleM, :tileable => true)
        @castR = Gosu::Image.new(castleR, :tileable => true)
        @width, @height = FastImage.size(grassloc)
        @w, @h = FastImage.size(castleL)
        @movx = 0
        @movy = rand(10..@bgy-@height-60)
        @grassbase = Gosu::Image.new(grassloc, :tileable => true)
        @tileset = []
        @hoverblocks = []
        @hoverblocks[0] = 0, rand(10..@bgy-@height-2*@h)
        newnum = rand(10..@bgy-@height-2*@h)
        while(newnum <= @hoverblocks[0][1]+@h + 25 && newnum >= @hoverblocks[0][1] )
            newnum = rand(10..@bgy-@height-2*@h)
        end
        @hoverblocks[1] = (-3)*@w - 50, newnum
        @hoverblocks[2] = @hoverblocks[1][0] + (-3)*@w - 50, rand(10..@bgy-@height-2*@h)
        @hoverblocks[3] = @hoverblocks[2][0] + (-3)*@w - 50, rand(10..@bgy-@height-2*@h)
        limit = 70
        index = 0
        while limit <= @bgx+@width do
            @tileset[index] = limit
            index+=1
            limit+=@width
        end
        @player = Player.new
        @player.warp(@bgx/2, @bgy-1.5*@height)
        @pstatus = "default"
        @landx = @bgx/2
        @landy = @bgy-1.5*@height

        @coins = []

        @score = 0
        @font = Gosu::Font.new(self, Gosu::default_font_name, 50)
        @time = 60
    end

    def draw
        @bg_img.draw(0,0,0, scale_x = 4, scale_y = 4)
        @tileset.each do |n|
            @grassbase.draw(@bgx-n, @bgy-@height, 1)
        end
        @hoverblocks.each do |n|
            @castL.draw(n[0], n[1], 1)
            @castM.draw(n[0]+@w, n[1], 1)
            @castR.draw(n[0]+2*@w, n[1], 1)
        end
        @player.draw(@pstatus)
        @coins.each do |g|
            g.draw
        end

        @font.draw("Score: #{@score}", 10, 1, 3.0, scale_x = 1, scale_y = 1, 0x22222222)
        @font.draw("Time left: #{@time}", @bgx-300, 1, 3.0, scale_x = 1, scale_y = 1, 0x22222222)
    end

    def onsurface?
        #ruby ends the method once the "return" statement is called
        if @player.gety >= @bgy-1.5*@height
            return true
        end
        @hoverblocks.each do |hb| 
            if hb[1]+50 >= @player.gety && hb[0]+2.5*@w >=@player.getx && hb[0] < @player.getx && hb[1] < @player.gety
                return true
            end
        end
        #if none is true, it is false.
        return false
    end

    def allowjump?
        if Gosu.distance(@landx, @landy, @player.getx, @player.gety) <= 200
            return true
        else
            return false
        end
    end

    def pickupcollision?
        x = @player.getx
        y = @player.gety
        @coins.each do |c|
            if x >= c.getx-10 && x <= c.getx+20 && y >= c.gety-10 && y <= c.gety+20
                @coins.delete(c)
                return true
            end
        end
        return false
    end

    def overlap?(x,y)
        proposedx = rand(0..@bgx)
        proposedy = rand(10..@bgy-@height-2*@h)
        if x == proposedx
            return true
        end
        if y == proposedy
            return true
        end
        return false
    end
        
    def update

        if Gosu.button_down? Gosu::KB_UP or Gosu::button_down? Gosu::GP_UP
            if allowjump?
                @player.jump
                @pstatus = "jump"
            end
        else
            if @pstatus = "jump" && !onsurface? && @player.gety < @bgy-50 || !allowjump? && @player.gety < @bgy-50
                @player.gravity
            else
                    if Gosu.milliseconds%1000 < 500
                        @pstatus = "default"
                    else
                    @pstatus = "idle"
                    end
                    @landy = @player.gety
                    @landx = @player.getx
            end
        end
        if Gosu.button_down? Gosu::KB_LEFT or Gosu::button_down? Gosu::GP_LEFT
            @player.walk_left
            if @pstatus !="jump"
                if Gosu.milliseconds%250 < 125
                    @pstatus = "walk_left1"
                else
                    @pstatus = "walk_left2"
                end
                @landx = @player.getx
            end
        elsif Gosu.button_down? Gosu::KB_RIGHT or Gosu::button_down? Gosu::GP_RIGHT
            @player.walk_right
            if @pstatus !="jump"
                if Gosu.milliseconds%250 < 125
                    @pstatus = "walk_right1"
                else
                    @pstatus = "walk_right2"
                end
                @landx = @player.getx
            end
        end

        @hoverblocks.each do |hb|
            if hb[0] <= @bgx
                hb[0] +=3
            else
                hb[1] = rand(10..@bgy-@height-2*@h)
                hb[0] = (-3)*@w
            end
        end
        if (@coins.length < 12)
            @coins[@coins.length] = Goldcoin.new
            @coins[@coins.length-1].warp(rand(0..@bgx), rand(10..@bgy-@height-2*@h))
            @coins.each do |g|
                while overlap?(g.getx, g.gety) do
                g.warp(rand(0..@bgx), rand(10..@bgy-@height-2*@h))
                end
            end
        end
        @coins.each do |g|
            g.update
        end

        if pickupcollision?
            @score +=10
        end

        if @time > 0
            if Gosu.milliseconds%500 < 10
                @time -= 1
            end
        else
            close
        end

    end
end

BGScreen.new.show
