note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	BOWLING_GAME_TEST

inherit
	EQA_TEST_SET
	 redefine on_prepare end

feature {NONE} -- Events and private methods
	game: GAME
		-- game instance

	on_prepare
			-- new game instance is created at the beginning of every test
		do
			create game.make
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

	rollSpare
		-- make a spare happens
		do
			game.roll(5)
			game.roll(5)
		end

	rollStrike
		-- make a strike happens
		do
			game.roll(10)
		end

feature -- Test routines

	testGutterGame
			-- test score works rightly when 0 happens in each frame
		note
			testing:  "covers/{GAME}.score"
		do
			rollMany(20, 0)
			assert("Score is not zero", game.score = 0)
		end

	testAllOnes
			-- test score works rightly when 1 happens in each frame
		note
			testing:  "covers/{GAME}.score"
		do
			rollMany(20, 1)
			assert("Score is not 20, but is " + game.score.out , game.score = 20)
		end

	testOneSpare
			-- Test score works rightly when spare happens
		note
			testing:  "covers/{GAME}.score"
		do
			rollSpare
			game.roll(3)
			rollMany(17, 0)
			assert("Score is not 16", game.score = 16)
		end

	testOneStrike
			-- Test score works rightly when strike happens
		note
			testing:  "covers/{GAME}.score"
		do
			rollStrike
			game.roll(3)
			game.roll(4)
			rollMany(16, 0)
			assert("Score is not 24", game.score = 24)
		end

	testPerfectGame
			-- Test score works rightly when perfect game happens
		note
			testing:  "covers/{GAME}.score"
		do
			rollMany(12, 10)
			assert("Score is not 300", game.score = 300)
		end

	testLastSpare
			-- Test score works rightly when a spare happens at the last frame
		note
			testing:  "covers/{GAME}.score"
		do
			rollMany(9, 10)
			rollSpare
			game.roll(10)
			ensure
				game.score = 275
		end
end


