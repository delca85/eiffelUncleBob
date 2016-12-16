note
	description: "UncleBob application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	GAME

inherit
	ARGUMENTS

create
	make

feature -- Initialization

	make
			-- Run application.
		do
			create rolls.make
		end

feature {NONE} -- Fields

    rolls: LINKED_LIST[INTEGER]
            -- rolls in a game

    current_roll: INTEGER
            -- number of roll playing at this moment

feature -- Basic Operations

    roll (pins: INTEGER)
            -- pins gone down at this roll
        do
            current_roll := current_roll + 1
            rolls.put_i_th(pins, current_roll)
        end

    score: INTEGER
    		-- compute points earned
    	local
    		scoreValue: INTEGER
    		frameIndex: INTEGER
    		frame: INTEGER
    	do
    		from
                frame := 0
            until
                frame >= 10
            loop
                if isStrike(frameIndex) then
                	scoreValue := scoreValue + strikeBonus(frameIndex)
                	frameIndex := frameIndex + 1
                elseif isSpare(frameIndex) then
                	scoreValue := scoreValue + spareBonus(frameIndex)
                	frameIndex := frameIndex + 2
                else
                	scoreValue := scoreValue + simpleFrame(frameIndex)
                	frameIndex := frameIndex + 2
                end
            end
			Result := scoreValue
    	end


feature {NONE} --private feature
	isStrike (frameIndex: INTEGER): BOOLEAN
		-- tells if a strike has been done in a specific frame
		local
			strike: BOOLEAN
		do
			strike := rolls.i_th(frameIndex) = 10
			Result:= strike
		end

	isSpare (frameIndex: INTEGER): BOOLEAN
		-- tells if a spare has been done in two sequential frames
		local
			spare: BOOLEAN
		do
			spare := rolls.i_th(frameIndex) + rolls.i_th(frameIndex+1) = 10
			Result:= spare
		end

	strikeBonus (frameIndex: INTEGER): INTEGER
		-- compute strike bonus in a specific frame
		do
			Result:= 10 + rolls.i_th(frameIndex+1) + rolls.i_th(frameIndex+2)
		end

	spareBonus (frameIndex: INTEGER): INTEGER
		-- compute spare bonus in a specific frame
		do
			Result:= 10 + rolls.i_th(frameIndex+2)
		end

	simpleFrame (frameIndex: INTEGER): INTEGER
		-- compute points in a specific frame when neither strike neither spare happened
		do
			Result:= rolls.i_th(frameIndex) + rolls.i_th(frameIndex+1)
		end

end
