class TraitImplementationError < StandardError; end
class TraitConditionalEval < TraitImplementationError; end

class EstrategiaAbstract

  def resolver metodo
    raise TraitImplementationError 'Se debe definir el metodo resolver para crear una estrategia'
  end

end


class EstrategiaTodosLosMensajes < EstrategiaAbstract

  def resolver metodo

    #Arma un Proc que ejecuta todos los comportamientos y devuelve el ultimo

    comportamientos = metodo[1]

  lambda {  |*args|
    for i in 0..comportamientos.size-2
      comportamientos[i].call(*args)
    end
  return comportamientos.last.call(*args)

  }

  end

end

class EstrategiaExcepcion < EstrategiaAbstract

  def resolver metodo

    nombre = metodo[0]

    raise TraitImplementationError, 'Conflicto con el metodo '+ nombre.to_s.upcase

  end

end

class EstrategiaPorFuncion  < EstrategiaAbstract

  attr_accessor :funcion

  def initialize(&bloque)
    self.funcion = bloque
  end


  def resolver metodo

    comportamientos = metodo[1]
    funcion = self.funcion

    lambda { |*args|

    resultados = comportamientos.map { |comportamiento| comportamiento.call(*args) }

   resultadoFinal =  resultados[1..-1].inject(resultados[0]) { |result, elem| funcion.call(result, elem) }

  resultadoFinal }

  end

end




class EstrategiaPorCorte  < EstrategiaAbstract

  attr_accessor :condicion

  def initialize(&bloque)
    self.condicion = bloque
  end


  def resolver metodo

      comportamientos = metodo[1]
      condicion = self.condicion

      lambda { |*args|

      comportamientos.each {

          |comportamiento|

        resultado = comportamiento.call(*args)

        if condicion.call(resultado)
          return resultado
        end

      }

    raise TraitConditionalEval, "Ninguna implementacion de :#{metodo[0].to_s} cumple con la condicion "

  }

  end


end
