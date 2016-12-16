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

	make
			-- Run application.
		local
			game: GAME_WITH_CONTRACTS
		do
			create game.make
			game.roll(-1)
		end

end
