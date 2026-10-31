import juego.*
import tablero.*

class Baldosa {
    var property color = "neutra"
    var property position
    var property duenioActual = null

    method esPisable() = true

    method image() = "baldosa_" + color + ".png"

    method tePiso(jugador) {
        self.pintarPara(jugador)
    }

    method pintarPara(jugador) {
        if (duenioActual != jugador) {
            self.cambiarDuenio(jugador)
        }
    }

    method cambiarDuenio(nuevoDuenio) {
        self.descontarDuenioAnterior()
        self.asignarNuevoDuenio(nuevoDuenio)
    }

    method descontarDuenioAnterior() {
        if (duenioActual != null) {
            duenioActual.perderCelda()
        }
    }

    method asignarNuevoDuenio(nuevoDuenio) {
        duenioActual = nuevoDuenio
        color = nuevoDuenio.color()
        nuevoDuenio.ganarCelda()
    }

    // Polimorfismo para transformar la baldosa en trampa
    method volverseTrampa() {
        tablero.reemplazarBaldosa(self, new BaldosaTrampa(
            position = position,
            color = color,
            duenioActual = duenioActual
        ))
    }
}

class BaldosaTrampa inherits Baldosa {
    override method image() = "baldosa_troll_" + color + ".png"

    override method tePiso(jugador) {
        // Al pisar una trampa, se beneficia al rival en vez del jugador que pisó
        super(juego.rivalDe(jugador))
        self.desactivar()
    }

    method desactivar() {
        tablero.reemplazarBaldosa(self, new Baldosa(
            position = position,
            color = color,
            duenioActual = duenioActual
        ))
    }

    override method volverseTrampa() {
        // Si ya es trampa, no hace nada (evita if)
    }
}

// Nueva subclase de ejemplo pedida por el docente (paredes / obstáculos)
class BaldosaPared inherits Baldosa {
    override method esPisable() = false
    override method image() = "baldosa_pared.png"
    override method tePiso(jugador) {}
    override method volverseTrampa() {}
}