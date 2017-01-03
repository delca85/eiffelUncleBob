note
	description: "Bowling game class with contracts, final release"
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_FINAL

inherit
	ARGUMENTS

create
	make

feature -- Initialization

	make
			-- Run application.
		do
			create rolls.make
			current_roll := 1
		end

feature {NONE} -- Fields

    rolls: LINKED_LIST[INTEGER]
            -- rolls in a game
   	current_roll: INTEGER
   			-- current roll

feature -- Basic Operations

    roll (pins: INTEGER)
            -- pins gone down at this roll
        require
        	valid_pins_number: pins >= 0 and pins <= 10
        do
            rolls.extend(pins)
            current_roll := current_roll + 1
        ensure
        	rolls_rightly_updated: rolls.last = pins
        	current_roll_updated: old current_roll = current_roll - 1
        	score_has_not_been_decremented: score >= old score
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
                	check
                		rolls.valid_index (frameIndex+1) and then rolls.valid_index (frameIndex+2)
                	end
                	Result := Result + strikeBonus(frameIndex)
                	frameIndex := frameIndex + 1
                elseif isSpare(frameIndex) then
                	check
                		rolls.valid_index (frameIndex+2)
                	end
                	Result := Result + spareBonus(frameIndex)
                	frameIndex := frameIndex + 2
                else
                	check
                		rolls.valid_index (frameIndex+1)
                	end
                	Result := Result + simpleFrame(frameIndex)
                	frameIndex := frameIndex + 2
                end
                frame := frame + 1
            end
    	end


feature {NONE} --private feature
	isStrike (frameIndex: INTEGER): BOOLEAN
		-- tells if a strike has been done in a specific frame
		require
			consistent_query: rolls.valid_index (frameIndex)
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
		require
			consistent_query: rolls.valid_index (frameIndex)
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
		require
			consistent_query: rolls.valid_index (frameIndex)
		do
			Result:= 10 + rolls.at(frameIndex+1) + rolls.at(frameIndex+2)
			ensure
				consistent_score_on_single_frame: 0 <= Result and Result <= 30
		end

	spareBonus (frameIndex: INTEGER): INTEGER
		-- compute spare bonus in a specific frame
		require
			consistent_query: rolls.valid_index (frameIndex)
		do
			Result:= 10 + rolls.at(frameIndex+2)
			ensure
				consistent_score_on_single_frame: 0 <= Result and Result <= 20
		end

	simpleFrame (frameIndex: INTEGER): INTEGER
		-- compute points in a specific frame when neither strike neither spare happened
		require
			consistent_query: rolls.valid_index (frameIndex)
		do
			Result:= rolls.at(frameIndex) + rolls.at(frameIndex+1)
			ensure
				consistent_score_on_single_frame: 0 <= Result and Result <= 20
		end


	invariant
		consistent_score: score >= 0 and score <= 300
		consistent_current_roll: current_roll >= 0 and current_roll <= 21 and rolls.valid_index (current_roll)
		consistent_roll: across rolls as r all 0 <= r.item and 10 >= r.item end
end
