import juego.*

class Baldosa {
    var property color = "neutra"
    var property position
    var property duenioActual = null
    var property esTroll = false

    method esBaldosa() = true

    method esPisable() = true

    method volverseTroll() {
        esTroll = true
    }

    method image() = if (esTroll) "baldosa_troll_" + color + ".png" else "baldosa_" + color + ".png"

    method tePiso(jugador) {
        const jugadorQuePinta = if (esTroll) juego.rivalDe(jugador) else jugador
        esTroll = false
        self.pintarPara(jugadorQuePinta)
    }

    method pintarPara(jugador) {
        if (duenioActual != jugador) {
            if (duenioActual != null) {
                duenioActual.perderCelda()
            }

            duenioActual = jugador
            color = jugador.color()
            jugador.ganarCelda()
        }
    }
}
