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

	is_spare(frame_index: INTEGER): BOOLEAN
	do
		Result := rolls.at (frame_index) + rolls.at (frame_index + 1) = 10
	end

	is_strike(frame_index: INTEGER): BOOLEAN
	do
		Result := rolls.at (frame_index) = 10
	end


feature

	roll (pins: INTEGER)
		do
			rolls.at (current_roll) := pins
			current_roll := current_roll + 1
		end

	score: INTEGER
		local
			r: INTEGER
			frame: INTEGER
		do
			from
				frame := 1
				r := 1
			until
				frame > 10
			loop
				if is_strike(r) then
					Result := Result + 10 + rolls.at (r + 1) + rolls.at (r + 2)
					r := r + 1
				elseif is_spare(r) then
					Result := Result + 10 + rolls.at (r + 2)
					r := r + 2
				else
					Result := Result + rolls.at (r) + rolls.at (r + 1)
					r := r + 2
				end
				frame := frame + 1
			end
		end

end
