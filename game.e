note
	description: "Bowling game class"
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

feature -- Basic Operations

    roll (pins: INTEGER)
            -- pins gone down at this roll
        do
            rolls.extend(pins)
        end

    score: INTEGER
    		-- compute points earned
    	local
    		scoreValue: INTEGER
    		frameIndex: INTEGER
    		frame: INTEGER
    	do
    		frameIndex := 1
    		from
                frame := 0
            until
                frame > 10
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
                frame := frame + 1
            end
			Result := scoreValue
    	end


feature {NONE} --private feature
	isStrike (frameIndex: INTEGER): BOOLEAN
		-- tells if a strike has been done in a specific frame
		local
			strike: BOOLEAN
		do
			if frameIndex <= rolls.count   then
				strike := rolls.at(frameIndex) = 10
			end
			Result:= strike
		end

	isSpare (frameIndex: INTEGER): BOOLEAN
		-- tells if a spare has been done in two sequential frames
		local
			spare: BOOLEAN
		do
			if frameIndex + 1 <= rolls.count then
				spare := rolls.at(frameIndex) + rolls.at(frameIndex+1) = 10
			end
			Result:= spare
		end

	strikeBonus (frameIndex: INTEGER): INTEGER
		-- compute strike bonus in a specific frame
		do
			if frameIndex + 2 <= rolls.count then
				Result:= 10 + rolls.at(frameIndex+1) + rolls.at(frameIndex+2)
			else
				Result := 0
			end
		end

	spareBonus (frameIndex: INTEGER): INTEGER
		-- compute spare bonus in a specific frame
		do
			if frameIndex + 2 <= rolls.count then
				Result:= 10 + rolls.at(frameIndex+2)
			else
				Result := 0
			end

		end

	simpleFrame (frameIndex: INTEGER): INTEGER
		-- compute points in a specific frame when neither strike neither spare happened
		do
			if frameIndex + 1 <= rolls.count then
				Result:= rolls.at(frameIndex) + rolls.at(frameIndex+1)
			else
				Result := 0
			end

		end

end
