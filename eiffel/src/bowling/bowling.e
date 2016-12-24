note
	description: "bowling application root class"
	author: "Mattia Monga"
	date: "$Date$"
	revision: "$Revision$"

class
	BOWLING

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
	local
		g: GAME
			-- Run application.
		do
			--| Add your code here
			create g.make
			print ("Score is: " + g.score.out + "%N")
			g.roll (3)
			print ("Score is: " + g.score.out + "%N")
		end

end
