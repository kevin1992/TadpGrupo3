class TraitImplementationError < StandardError; end
class TraitConditionalEval < TraitImplementationError; end

class EstrategiaTodosLosMensajes

  def resolver(nombre, bloques)
    #Arma un Proc que ejecuta todos los comportamientos y devuelve el ultimo
    lambda do |*args|
      for i in 0..bloques.size-2
        instance_eval { bloques[i].call(*args) }
      end

      return instance_eval { bloques.last.call(*args) }
    end
  end

end

class EstrategiaExcepcion

  def resolver(nombre, bloques)
    lambda { raise TraitImplementationError, 'Conflicto con el metodo ' + nombre.to_s.upcase }
  end

end

class EstrategiaPorFuncion

  attr_accessor :funcion

  def initialize(&bloque)
    self.funcion = bloque
  end

  def resolver(nombre, bloques)
    funcion = self.funcion

    lambda { |*args|
      resultados = bloques.map { |comportamiento| instance_eval { comportamiento.call(*args) } }
      resultado_final = resultados[1..-1].inject(resultados[0]) { |result, elem| funcion.call(result, elem) }
      resultado_final
    }
  end

end


class EstrategiaPorCorte

  attr_accessor :condicion

  def initialize(&bloque)
    self.condicion = bloque
  end

  def resolver(nombre, bloques)
    condicion = self.condicion

    lambda { |*args|
      bloques.each { |comportamiento|

        resultado = instance_eval { comportamiento.call(*args) }

        if condicion.call(resultado)
          return resultado
        end
      }

      raise TraitConditionalEval, "Ninguna implementacion de :#{nombre.to_s} cumple con la condicion "
    }
  end

end
