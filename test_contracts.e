note
	description: "Summary description for {TEST_CONTRACTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_CONTRACTS

create
	make

feature -- Initialization
	game: GAME_FINAL

	make
			-- Run application.
		do
			create game.make
			rollMany(20, 2)
			io.putint(game.score); io.put_new_line
		end

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
				game.roll(pins)
				i := i+1
			end
		end

end
