note
	description: "Summary description for {GAME_WITH_CONTRACTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_WITH_CONTRACTS

create
	make

feature -- Initialization

	make
			-- Run application.
		do
			--| Add your code here
			create rolls.make
		end

feature {NONE} -- Fields

    rolls: LINKED_LIST[INTEGER]
            -- rolls in a game

    current_roll: INTEGER
            -- number of roll playing at this moment

    score_field: INTEGER
    		-- final score

feature {NONE} -- Private methods

	rollMany(n: INTEGER; pins: INTEGER)
		-- roll the same number of pins in sequential frame
		local
			i: INTEGER
		do
			from
				i:= 0
			until
				i >= n
			loop
				roll(pins)
			end
		end

	rollSpare
		-- make a spare happens
		do
			roll(5)
			roll(5)
		end

	rollStrike
		-- make a strike happens
		do
			roll(10)
		end


feature -- Basic Operations

    roll (pins: INTEGER)
            -- pins gone down at this roll
    require
    	pins >= 0

	do
            current_roll := current_roll + 1
            rolls.extend(pins)

    ensure
    	updated_roll_series: rolls.at(current_roll) = pins
    	updated_current_roll: current_roll = old current_roll + 1
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
            score_field := score_field
			Result := scoreValue
		ensure

    	end


feature {NONE} --private feature
	isStrike (frameIndex: INTEGER): BOOLEAN
		-- tells if a strike has been done in a specific frame
		local
			strike: BOOLEAN
		do
			strike := rolls.at(frameIndex) = 10
			Result:= strike
		end

	isSpare (frameIndex: INTEGER): BOOLEAN
		-- tells if a spare has been done in two sequential frames
		local
			spare: BOOLEAN
		do
			spare := rolls.at(frameIndex) + rolls.at(frameIndex+1) = 10
			Result:= spare
		end

	strikeBonus (frameIndex: INTEGER): INTEGER
		-- compute strike bonus in a specific frame
		do
			Result:= 10 + rolls.at(frameIndex+1) + rolls.at(frameIndex+2)
		end

	spareBonus (frameIndex: INTEGER): INTEGER
		-- compute spare bonus in a specific frame
		do
			Result:= 10 + rolls.at(frameIndex+2)
		end

	simpleFrame (frameIndex: INTEGER): INTEGER
		-- compute points in a specific frame when neither strike neither spare happened
		do
			Result:= rolls.at(frameIndex) + rolls.at(frameIndex+1)
		end

	invariant
		consistent_current_roll: current_roll < 22
end

