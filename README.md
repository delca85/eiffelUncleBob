# Riferimenti

- [Setup di Eiffel Studio in ambiente Linux](https://www.eiffel.org/doc/eiffelstudio/Linux)
- [Manuale compilatore](https://www.eiffel.org/doc/eiffelstudio/Command%20line)
- [Standard ECMA-367 "Eiffel: Analysis, Design and Programming Language"](http://www.ecma-international.org/publications/files/ECMA-ST/ECMA-367.pdf) Si
  tratta di un documento molto leggibile per... gli standard degli standard: il
  capitolo 7 è un'ottima introduzione a Eiffel e la progettazione
  *Object-Oriented*
- [Differenze fra ECMA-367 e Eiffel Studio](https://www.eiffel.org/doc/eiffelstudio/Differences%20between%20standard%20ECMA-367%20and%20Eiffel%20Software%20implementation)
- Per chi non usa le macchine del laboratorio può essere utile il `Dockerfile`. Con Docker:
```sh
docker build -t eiffel .
docker run -ti --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -u eiffel -v $(pwd)/eiffel:/home/eiffel  eiffel
```
  
# Esercizio 1

(tempo stimato 45')

Reimplementare in Eiffel il Bowling, partendo dai test di Uncle Bob, per comodità riportati anche qui:

```java
public class BowlingGameTest extends TestCase {
    private Game g;

    protected void setUp() throws Exception {
        g = new Game();
    }

    @Test
    public void testGutterGame() throws Exception {
        rollMany(20, 0);
        assertEquals(0, g.score());
    }

    @Test
    public void testAllOnes() throws Exception {
        rollMany(20,1);
        assertEquals(20, g.score());
    }

    @Test
    public void testOneSpare() throws Exception {
        rollSpare();
        g.roll(3);
        rollMany(17,0);
        assertEquals(16,g.score());
    }

    @Test
    public void testOneStrike() throws Exception {
        rollStrike();
        g.roll(3);
        g.roll(4);
        rollMany(16, 0);
        assertEquals(24, g.score());
    }

    @Test
    public void testPerfectGame() throws Exception {
        rollMany(12,10);
        assertEquals(300, g.score());
    }

    @Test
    public void testLastSpare() throws Exception {
        rollMany(9,10);
        rollSpare();
        g.roll(10);
        assertEquals(275, g.score());
    }


    private void rollSpare() {
        g.rollMany(2, 5);
    }

    private void rollStrike() {
        g.roll(10);
    }

    private void rollMany(int n, int pins) {
        for (int i = 0; i < n; i++)
            g.roll(pins);
    }
}
```

Per i test, usare il *framework* `EQA_TEST_SET` (analogo a `junit`) e creare un
nuovo *cluster* di test (Tools -> Add Cluster).

```eiffel
class
	GAME_TEST_SET

inherit
    
    EQA_TEST_SET

-- ....
```


# Esercizio 2

(tempo stimato 45')

Trasformare i test di Uncle Bob in opportuni contratti per le *feature*  della classe `Game`

```eiffel
	roll (pins: INTEGER)

	score: INTEGER
```
