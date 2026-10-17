import tablero.*
import juego.*

class Jugador {
    var property position
    const property color
    var property celdasGanadas = 0
    method esBaldosa() = false

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
