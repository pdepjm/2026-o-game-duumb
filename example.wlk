class Jugador {
    var property position
    const property color
    var property celdasGanadas = 0

    method image() = "slime_" + color + ".png"

    method ganarCelda() {
        celdasGanadas += 1
    }
    method perderCelda() {
        celdasGanadas -= 1
    }

    method esPisable() = false

    method tePiso(otro) {
    }

    method pintarBaldosaActual() {
        game.getObjectsIn(position).forEach({ elemento => elemento.tePiso(self)})
    }


    method moverHacia(direccion) {
        const nuevaPos = direccion.proximaPosicion(position)
        
        if (self.puedoIrA(nuevaPos)) {
            position = nuevaPos
            self.pintarBaldosaActual()
        }
    }

    method puedoIrA(nuevaPos) {
        if (not juego.estaEnCurso()) return false 
        
        return tablero.validarPosicion(nuevaPos) and self.lugarLibre(nuevaPos)
    }

    method lugarLibre(nuevaPos) {
        return game.getObjectsIn(nuevaPos).all({ objeto => objeto.esPisable() })
    }



}

const jugadorVerde = new Jugador(
    celdasGanadas = 0,
    position = game.at(0,0),
    color = "verde"
)

const jugadorAzul = new Jugador(
    celdasGanadas = 0,
    position = game.at(9, 9),
    color = "azul"
)

object arriba {
    method proximaPosicion(posicion) {
        return posicion.up(1)
    }
}
object abajo {
    method proximaPosicion(posicion) {
        return posicion.down(1)
    }
}
object izquierda {
    method proximaPosicion(posicion) {
        return posicion.left(1)
    }
}
object derecha {
    method proximaPosicion(posicion) {
        return posicion.right(1)
    }
}

object tablero{

    method crearBaldosas() {

        (0 .. game.width() - 1).forEach({ x =>
            (0 .. game.height() - 2).forEach({ y =>
                game.addVisual(new Baldosa(position = game.at(x, y)))
            })
        })
    }

    method validarPosicion(posicion) {
        return posicion.x().between(0, game.width() - 1) and posicion.y().between(0, game.height() - 2)  
    }
}

object cartelFinal {
    var property image = null
    var property position = game.at(4,4)
}

object juego {
    const jugadores = [jugadorVerde, jugadorAzul]

    method iniciar() {

        tablero.crearBaldosas()
        game.addVisual(jugadorVerde)
        game.addVisual(jugadorAzul)

        game.addVisual(reloj)
        reloj.iniciar()
    }

    method terminarJuego() {
        reloj.detener()
        self.darGanador()

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
    }

    method estaEnCurso() {
        return reloj.tiempo() > 0
    }


}
object reloj {
    var property tiempo = 30
    var property position = game.at(4, 10)

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


class Baldosa {
    var property color = "neutra"
    var property position
    var duenioActual = null

    method esPisable() = true

    method image() = "baldosa_" + color + ".png"

    method tePiso(jugador){
        if(duenioActual != jugador){
            if(duenioActual != null){
                duenioActual.perderCelda()
            }

            duenioActual = jugador
            color = jugador.color()
            jugador.ganarCelda()
        }
    }
}
