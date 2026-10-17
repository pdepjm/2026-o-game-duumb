import jugador.*
import tablero.*

object juego {
    const jugadores = [jugadorVerde, jugadorAzul]

    method iniciar() {

        tablero.crearBaldosas()
        game.addVisual(jugadorVerde)
        game.addVisual(jugadorAzul)

        game.addVisual(reloj)
        reloj.iniciar()

        spawnerDeBaldosas.iniciar()
    }

    method terminarJuego() {
        reloj.detener()
        self.darGanador()
        spawnerDeBaldosas.detener()

        game.schedule(4000, { game.stop() })
    }

    method darGanador() {
        if (jugadorVerde.celdasGanadas() == jugadorAzul.celdasGanadas()){
            game.sound("empate.mp3").play()
            cartelFinal.image("cartel_empate.png")
        }else{
            const ganador = jugadores.max({ jugador => jugador.celdasGanadas() })
            game.sound("win.mp3").play()
            cartelFinal.image("cartel_" + ganador.color() + ".png")
        }
        game.addVisual(cartelFinal)
        game.addVisual(puntajeVerde)
        game.addVisual(puntajeAzul)
    }

    method estaEnCurso() {
        return reloj.tiempo() > 0
    }

    method rivalDe(unJugador) {
        // Busca en la lista el jugador que NO sea el que le pasaste
        return jugadores.find({ j => j != unJugador })
    }


}
object reloj {
    var property tiempo = 30
    var property position = game.at(4, 10)
    method esBaldosa() = false

    method text() = if (tiempo > 0) "Tiempo: " + tiempo.toString() else " "

    method textColor() = "FFFFFF"

    method restarSegundo() {
    if (tiempo > 0) {
        tiempo -= 1
    } else {
        juego.terminarJuego()
    }
}

    method iniciar() {
        game.onTick(1000, "cronometro", { self.restarSegundo() })
    }

    method detener() {
        game.removeTickEvent("cronometro")
    }
}

class Puntaje {
    var property position
    const jugador
    const property textColor

    method esBaldosa() = false

    method text() = "puntos" + jugador.color().capitalize() + ": " + jugador.celdasGanadas().toString()
}

const puntajeVerde = new Puntaje(
    position = game.at(1, 10),
    jugador = jugadorVerde,
    textColor = "32CD32FF"
)

const puntajeAzul = new Puntaje(
    position = game.at(7, 10),
    jugador = jugadorAzul,
    textColor = "1E90FFFF"
)
