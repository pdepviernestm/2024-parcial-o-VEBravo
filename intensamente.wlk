const intensidadElevada = 50

class Persona {
  var property edad
  const property emociones = [] 
  
  method agregarEmocion(emocion) = emociones.add(emocion)
  method esAdolescente() = edad.between(12, 19)
  method estaPorExplotar() = emociones.all({e => e.puedeLiberarse()})
  method vivirUnEvento(evento){
    emociones.forEach({e => if(e.puedeLiberarse()) {e.liberarse(evento)} e.agregarEventoVivido(evento)})
  }
}

class Emocion {
  const eventosVividos = []
  var property intensidad

  method puedeLiberarseProxEvento() = true // No se explica en el enunciado de qué depende esta condición
                                          // dice que muchas veces pasa, podría representarse como un random pero no sería adecuado para hacer los tests
  method agregarEventoVivido(evento) {eventosVividos.add(evento)}
  method cantidadEventosVividos() = eventosVividos.size()
  method estaElevada() = intensidad > intensidadElevada
  method puedeLiberarse() = self.estaElevada() && self.puedeLiberarseProxEvento()
  method liberarse(evento){intensidad -= evento.impacto()}
  method vivioElEvento(evento) = eventosVividos.contains(evento)
}

class Furia inherits Emocion(intensidad = 100){
  const property palabrotas = []

  method agregarPalabrota(palabrota) = palabrotas.add(palabrota)
  method conocePalabrotaConMasDeNLetras(n) = palabrotas.any({p => p.size()>n})
  override method puedeLiberarse() = super() && self.conocePalabrotaConMasDeNLetras(7)
  override method liberarse(evento){
    super(evento) 
    palabrotas.remove(palabrotas.first())
  }
}

class Alegria inherits Emocion{
  override method puedeLiberarse() = super() && self.cantidadEventosVividos().even()
  override method liberarse(evento){
    intensidad = (intensidad - evento.impacto()).abs()
  }
}

class Tristeza inherits Emocion{
  var property causa = "melancolia"                                      
  override method puedeLiberarse() = super() && causa.equalsIgnoreCase("melancolia")
  override method liberarse(evento){
    super(evento)
    causa = evento.descripcion()
  }
}

class Desagrado inherits Emocion{
  override method puedeLiberarse() = self.estaElevada() && self.cantidadEventosVividos() > intensidad
}
class Temor inherits Desagrado{}

class Ansiedad inherits Temor{
  var property motivo
  override method puedeLiberarse() = super() && motivo.fueSolucionado()


}

class Motivo {
    method fueSolucionado() = false
}

const recibirse = new Motivo()
object rendirParadigmas inherits Motivo{
  override method fueSolucionado() = new Date() > new Date(day = 22, month = 11, year = 2024)
}

/*
La ansiedad siempre tiene un motivo y de este motivo conocemos si ya fue solucionado o no.
La ansiedad solo puede liberarse si cumple las condiciones del temor y si ademas el motivo fue
solucionado. Por ahora, conocemos unicamente los siguientes motivos comunes.
 - Rendir el parcial de paradigmas (fue solucionado si la fecha es posterior al 22/11)
 - Recibirse, no fue solucionado
Al liberarse, se libera igual que el temor

Se utilizo herencia ya que la ansiedad reutiliza y extiende el comportamiento definido en la clase
superior Temor. 
Luego, se utilizó polimorfismo ya que, aunque las condiciones mediante las cuales la ansiedad puede liberarse
son diferentes a las demas, la ansiedad entiende el mensaje puede liberarse de la misma forma que las demas
emociones
*/


class Evento {
  const property impacto
  const property descripcion = "" 
}

class Grupo {
  const integrantes = []
  method agregarIntegrante(integrante) = integrantes.add(integrante)
  method vivirUnEvento(evento){
    integrantes.forEach({persona => persona.vivirUnEvento(evento)})
  }
  method seRegistroElEvento(evento) = integrantes.all({i => i.emociones().all({e => e.vivioElEvento(evento)})})
}