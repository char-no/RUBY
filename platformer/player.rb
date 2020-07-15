class Player
    def initialize

        #src image filepaths and initialization
        assetsfolder = "D:/ruby_projects/platformer/assets/"
        default_src = assetsfolder + "bunny2_stand.PNG"
        idle_src = assetsfolder + "bunny2_ready.PNG"
        step1R_src = assetsfolder + "bunny2_walk1.PNG"
        step2R_src = assetsfolder + "bunny2_walk2.PNG"
        step1L_src = assetsfolder + "bunny2_walk1_left.PNG"
        step2L_src = assetsfolder + "bunny2_walk2_left.PNG"
        jump_src = assetsfolder + "bunny2_jump.PNG"
        dmg_src = assetsfolder + "bunny2_hurt.PNG"

        @default = Gosu::Image.new(default_src)
        @idle = Gosu::Image.new(idle_src)
        @step1R = Gosu::Image.new(step1R_src)
        @step2R = Gosu::Image.new(step2R_src)
        @step1L = Gosu::Image.new(step1L_src)
        @step2L = Gosu::Image.new(step2L_src)

        @jump = Gosu::Image.new(jump_src)
        @dmg = Gosu::Image.new(dmg_src)

        @x = @y = 0
    end

    def getx
        @x
    end

    def gety
        @y
    end

    def warp(x,y)
        @x, @y = x, y
    end

    def walk_left
        @x -=3
    end

    def walk_right
        @x +=3
    end

    def jump
        @y -=5
    end
    
    def gravity
        @y +=5
    end

    def draw(status)
        case status
        when "walk_left1" 
            @step1L.draw(@x,@y,2,scale_x=0.25, scale_y=0.25)
        when "walk_left2" 
            @step2L.draw(@x,@y,2,scale_x=0.25, scale_y=0.25)
        when "walk_right1"
            @step1R.draw(@x,@y,2,scale_x=0.25, scale_y=0.25)
        when "walk_right2"
            @step2R.draw(@x,@y,2,scale_x=0.25, scale_y=0.25)
        when "idle"
            @idle.draw(@x,@y,2,scale_x=0.25, scale_y=0.25)
        when "jump"
            @jump.draw(@x,@y,2,scale_x=0.25, scale_y=0.25)
        else
            @default.draw(@x,@y,2,scale_x=0.25, scale_y=0.25)
        end
    end
end
