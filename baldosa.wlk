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

    method desvanecer() {
        tipo.desvanecer(self)
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
    method desvanecer(baldosa) {}
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

class TipoBomba inherits TipoNormal {
    override method admiteEfecto() = false
    override method imagePara(color) = "baldosa_bomba_" + color + ".png"

    override method tePiso(baldosa, jugador) {
        self.pintarCruz(baldosa, jugador)
        baldosa.cambiarTipo(new TipoNormal())
    }

    method posicionesAdyacentes(posicion) = [
        posicion.up(1),
        posicion.down(1),
        posicion.left(1),
        posicion.right(1)].filter({ pos => tablero.validarPosicion(pos) })

    method pintarBaldosaEn(posicion, jugador) {
        game.getObjectsIn(posicion)
            .filter({ obj => obj.esPisable() })
            .forEach({ obj => obj.pintarPara(jugador) })
    }

    method pintarCruz(baldosa, jugador) {
        baldosa.pintarPara(jugador)
        self.posicionesAdyacentes(baldosa.position()).forEach({ pos =>
            self.pintarBaldosaEn(pos, jugador)
        })
    }

    method pintarEnCruz(baldosa, jugador) {
        self.pintarCruz(baldosa, jugador)
    }
    
    override method aplicarEfectoSorpresa(baldosa, nuevoTipo) {}
}

class TipoMuerte inherits TipoNormal {
    override method admiteEfecto() = false
    override method imagePara(color) = "baldosa_muerte.png"

    override method alAplicarseEn(baldosa) {
        game.schedule(2000, { baldosa.desvanecer() })
    }

    override method tePiso(baldosa, jugador) {
        tablero.neutralizarBaldosasDe(juego.rivalDe(jugador))
        baldosa.pintarPara(jugador)
        baldosa.cambiarTipo(new TipoNormal())
    }

    override method desvanecer(baldosa) {
        baldosa.cambiarTipo(new TipoNormal())
    }

    override method aplicarEfectoSorpresa(baldosa, nuevoTipo) {}
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
