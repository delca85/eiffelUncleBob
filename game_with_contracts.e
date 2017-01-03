note
	description: "Bowling game with contracts class"
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_WITH_CONTRACTS

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
        require
        	pins >= 0
        do
            rolls.extend(pins)
        ensure
        	rolls_rightly_updated: rolls.last = pins
        	True implies True
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
			ensure
				consistent_score: 0 <= Result and Result <= 300
				test_gutter_game: rollManyScore(20, 0) = 0
				test_all_ones: rollManyScore(20, 1) = 20
				test_one_spare: rollOneSpare = 16
				test_one_strike: rollOneStrike = 24
				test_perfect_game: rollManyScore(12, 10) = 300
				test_last_spare: rollLastSpare = 275
    	end


feature {NONE} --private feature
	isStrike (frameIndex: INTEGER): BOOLEAN
		-- tells if a strike has been done in a specific frame
		require
			consistent_query: frameIndex > 0
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
			consistent_query: frameIndex > 0
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
			consistent_query: frameIndex > 0
		do
			if frameIndex + 2 <= rolls.count then
				Result:= 10 + rolls.at(frameIndex+1) + rolls.at(frameIndex+2)
			else
				Result := 0
			end
			ensure
				consistent_score_on_single_frame: 0 <= Result and Result <= 30
		end

	spareBonus (frameIndex: INTEGER): INTEGER
		-- compute spare bonus in a specific frame
		require
			consistent_query: frameIndex > 0
		do
			if frameIndex + 2 <= rolls.count then
				Result:= 10 + rolls.at(frameIndex+2)
			else
				Result := 0
			end
			ensure
				consistent_score_on_single_frame: 0 <= Result and Result <= 20
		end

	simpleFrame (frameIndex: INTEGER): INTEGER
		-- compute points in a specific frame when neither strike neither spare happened
		require
			consistent_query: frameIndex > 0
		do
			if frameIndex + 1 <= rolls.count then
				Result:= rolls.at(frameIndex) + rolls.at(frameIndex+1)
			else
				Result := 0
			end
			ensure
				consistent_score_on_single_frame: 0 <= Result and Result <= 20
		end

feature {NONE} -- feature for contracts

	rollManyScore(n: INTEGER; pins: INTEGER): INTEGER
		-- roll the same number of pins in sequential frames and compute the final score
		local
			local_game: GAME_WITH_CONTRACTS
		do
			create local_game.make
			rollManyForGame(n, pins, local_game)
			Result := local_game.score
		end

	rollOneSpare: INTEGER
		-- roll one spare at the beginning of the game and compute final score
		local
			i: INTEGER
			local_game: GAME_WITH_CONTRACTS
		do
			create local_game.make
			local_game.roll(5)
			local_game.roll(5)
			local_game.roll(3)
			rollManyForGame(17, 0, local_game)
			Result := local_game.score
		end

	rollOneStrike: INTEGER
		-- roll one strike at the beginning of the game and compute the final score
		local
			i: INTEGER
			local_game: GAME_WITH_CONTRACTS
		do
			create local_game.make
			local_game.roll(10)
			local_game.roll(3)
			local_game.roll(4)
			rollManyForGame(16, 0, local_game)
			Result := local_game.score
		end

	rollLastSpare: INTEGER
		local
			i: INTEGER
			local_game: GAME_WITH_CONTRACTS
		do
			create local_game.make
			rollManyForGame(9, 10, local_game)
			local_game.roll(5)
			local_game.roll(5)
			local_game.roll(10)
			Result := local_game.score
		end

	rollManyForGame(n: INTEGER; pins: INTEGER; game: GAME_WITH_CONTRACTS)
		-- rollMany for the game passed as argument
		local
			i: INTEGER
		do
			from
				i:= 0
			until
				i >= n
			loop
				game.roll(pins)
				i := i+1
			end
		end
end
