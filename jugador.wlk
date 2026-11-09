import tablero.*
import juego.*
import wollok.game.*



class Controles {
    const teclaArriba
    const teclaAbajo
    const teclaIzquierda
    const teclaDerecha
    method configurarPara(jugador) {
        teclaArriba.onPressDo({ jugador.moverHacia(arriba) })
        teclaAbajo.onPressDo({ jugador.moverHacia(abajo) })
        teclaIzquierda.onPressDo({ jugador.moverHacia(izquierda) })
        teclaDerecha.onPressDo({ jugador.moverHacia(derecha) })
    }
}

object sinControles {
    method configurarPara(jugador) {}
}



class Jugador {
    var property position
    const posicionInicial = position
    const property color
    var property celdasGanadas = 0
    const property controles = sinControles 

    method reiniciar() {
        position = posicionInicial
        celdasGanadas = 0
    } 

    method configurarControles() {
        controles.configurarPara(self)
    }

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
    color = "verde",
    controles = new Controles(
        teclaArriba = keyboard.w(),
        teclaAbajo = keyboard.s(),
        teclaIzquierda = keyboard.a(),
        teclaDerecha = keyboard.d()
    )
)

const jugadorAzul = new Jugador(
    celdasGanadas = 0,
    position = game.at(9, 9),
    color = "azul",
    controles = new Controles(
        teclaArriba = keyboard.up(),
        teclaAbajo = keyboard.down(),
        teclaIzquierda = keyboard.left(),
        teclaDerecha = keyboard.right()
    )
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
