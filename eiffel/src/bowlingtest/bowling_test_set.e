note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	BOWLING_TEST_SET

inherit

	EQA_TEST_SET
		redefine
			on_prepare
		end

feature {NONE} -- Events

	g: GAME

	on_prepare
			-- <Precursor>
		do
			create g.make
		end

	roll_many (times: INTEGER; pins: INTEGER)
		require
			valid_roll: 0 <= pins and pins <= 10
			valid_times: times > 0
			not g.ended
		do
			across
				1 |..| times as r
			loop
				g.roll (pins)
			end
		end

	roll_spare
		require
			not g.ended
		do
			g.roll (5)
			g.roll (5)
		end

	roll_strike
		require
			not g.ended
		do
			g.roll (10)
		end

feature -- Test routines

	test_gutter_game
		do
			roll_many (20, 0)
			assert ("Score is not zero: " + g.score.out, g.score = 0)
		end

	test_all_ones
		do
			roll_many (20, 1)
			assert ("Score is not twenty: " + g.score.out, g.score = 20)
		end

	test_one_spare
		do
			roll_spare
			g.roll (3)
			roll_many (17, 0)
			assert ("Score is not sixteen: " + g.score.out, g.score = 16)
		end

	test_one_strike
		do
			roll_strike
			g.roll (3)
			g.roll (4)
			roll_many (16, 0)
			assert ("Score is not twentyfour: " + g.score.out, g.score = 24)
		end

	test_perfect_game
		do
			roll_many (12, 10)
			assert ("Score is not three hundreds: " + g.score.out, g.score = 300)
		end

end
