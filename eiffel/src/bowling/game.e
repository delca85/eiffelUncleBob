note
	description: "Summary description for {GAME}."
	author: "Mattia Monga"
	date: "$Date$"
	revision: "$Revision$"

class
	GAME

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			create rolls.make_filled (0, 1, 21)
			current_roll := 1
		end

	rolls: ARRAY [INTEGER]

	current_roll: INTEGER

	is_spare (frame_index: INTEGER): BOOLEAN
		require
			rolls.valid_index (frame_index) and then rolls.valid_index (frame_index + 1)
		do
			Result := rolls.at (frame_index) + rolls.at (frame_index + 1) = 10
		end

	is_strike (frame_index: INTEGER): BOOLEAN
		require
			rolls.valid_index (frame_index)
		do
			Result := rolls.at (frame_index) = 10
		end

	sum_of_rolls: INTEGER
		do
			across
				rolls as r
			from
				Result := 0
			loop
				Result := Result + r.item
			end
		end

feature

	roll (pins: INTEGER)
		require
			valid_roll: 0 <= pins and pins <= 10
			not ended
		do
			rolls.at (current_roll) := pins
			current_roll := current_roll + 1
		ensure
			current_roll_increment: current_roll = old current_roll + 1
			score_does_not_decrement: score >= old score
		end

	score: INTEGER
		local
			r: INTEGER
			frame: INTEGER
		do
			from
				frame := 1
				r := 1
			invariant
				rolls.valid_index (r)
			until
				frame > 10
			loop
				if is_strike (r) then
					check
						rolls.valid_index (r + 1) and then rolls.valid_index (r + 2)
					end
					Result := Result + 10 + rolls.at (r + 1) + rolls.at (r + 2)
					r := r + 1
				elseif is_spare (r) then
					check
						rolls.valid_index (r + 2)
					end
					Result := Result + 10 + rolls.at (r + 2)
					r := r + 2
				else
					check
						rolls.valid_index (r + 1)
					end
					Result := Result + rolls.at (r) + rolls.at (r + 1)
					r := r + 2
				end
				frame := frame + 1
			variant
				rolls.upper - r
			end
		ensure
			score_is_at_least_sum_of_rolls: score >= sum_of_rolls
		end

	ended: BOOLEAN
		do
			Result := not rolls.valid_index (current_roll)
		end

invariant
	valid_score: 0 <= score and score <= 300
	valid_current: rolls.valid_index (current_roll)
	valid_rolls: across rolls as r all 0 <= r.item and r.item <= 10 end

end
