import juego.*
import tablero.*

object vacio{
    method perderCelda(){}
}


class Baldosa {
    var property color = "neutra"
    var property position
    var property duenioActual = vacio
    var property tipo = new TipoNormal() // Colaborador polimórfico

    method cambiarDuenio(nuevoDuenio) {
        self.descontarDuenioAnterior()
        self.asignarNuevoDuenio(nuevoDuenio)
    }

    method quitarDuenio() {
        self.descontarDuenioAnterior()
        duenioActual = vacio
        color = "neutra"
    }

    method descontarDuenioAnterior() {
        duenioActual.perderCelda()
    }

    method asignarNuevoDuenio(nuevoDuenio) {
        duenioActual = nuevoDuenio
        color = nuevoDuenio.color()
        nuevoDuenio.ganarCelda()
    }

    method esPisable() = tipo.esPisable()
    method admiteEfecto() = tipo.admiteEfecto()
    method estaDisponible() = self.admiteEfecto() and game.getObjectsIn(position).all({ obj => obj.esPisable() })
    method image() = tipo.imagePara(color)

    method tePiso(jugador) {
        tipo.tePiso(self, jugador)
    }

    method cambiarTipo(nuevoTipo) {
        tipo = nuevoTipo
        nuevoTipo.alAplicarseEn(self)
    }

    method aplicarEfectoSorpresa(nuevoTipo) {
        tipo.aplicarEfectoSorpresa(self, nuevoTipo)
    }

    // Métodos propios de pintado de la baldosa
    method pintarPara(jugador) {
        if (duenioActual != jugador) {
            self.cambiarDuenio(jugador)
        }
    }
}

class TipoNormal {
    method esPisable() = true
    method admiteEfecto() = true
    method imagePara(color) = "baldosa_" + color + ".png"

    method tePiso(baldosa, jugador) {
        baldosa.pintarPara(jugador)
    }

    method aplicarEfectoSorpresa(baldosa, nuevoTipo) {
        baldosa.cambiarTipo(nuevoTipo)
    }

    method alAplicarseEn(baldosa) {}
}

class TipoTrampa inherits TipoNormal {
    override method admiteEfecto() = false
    override method imagePara(color) = "baldosa_troll_" + color + ".png"

    override method tePiso(baldosa, jugador) {
        super(baldosa, juego.rivalDe(jugador))
        baldosa.cambiarTipo(new TipoNormal()) // Al pisarla vuelve a ser normal sin addVisual
    }

    override method aplicarEfectoSorpresa(baldosa, nuevoTipo) {
        // Si ya tiene un efecto especial, no se pisa con otro (sin usar if)
    }
}

class TipoPared {
    method esPisable() = false
    method admiteEfecto() = false
    method imagePara(color) = "baldosa_pared.png"
    method tePiso(baldosa, jugador) {}
    method aplicarEfectoSorpresa(baldosa, nuevoTipo) {}
    method alAplicarseEn(baldosa) {
        baldosa.quitarDuenio()
    }
}
