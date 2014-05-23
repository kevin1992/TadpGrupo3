class TraitImplementationError < StandardError; end
class TraitConditionalEval < TraitImplementationError; end

class EstrategiaTodosLosMensajes

  def resolver(metodo)

    #Arma un Proc que ejecuta todos los comportamientos y devuelve el ultimo

    comportamientos = metodo[1]

    lambda do |*args|
      for i in 0..comportamientos.size-2
        instance_eval  { comportamientos[i].call(*args)}

      end
      return instance_eval { comportamientos.last.call(*args) }

    end

  end

end

class EstrategiaExcepcion

  def resolver(metodo)

    nombre = metodo[0]

    lambda { raise TraitImplementationError, 'Conflicto con el metodo '+ nombre.to_s.upcase }

  end

end

class EstrategiaPorFuncion

  attr_accessor :funcion

  def initialize(&bloque)
    self.funcion = bloque
  end


  def resolver(metodo)

    comportamientos = metodo[1]
    funcion = self.funcion

    lambda { |*args|

      resultados = comportamientos.map { |comportamiento| instance_eval { comportamiento.call(*args) } }

      resultado_final = resultados[1..-1].inject(resultados[0]) { |result, elem| funcion.call(result, elem) }

      resultado_final }

  end

end




class EstrategiaPorCorte

  attr_accessor :condicion

  def initialize(&bloque)
    self.condicion = bloque
  end


  def resolver(metodo)

    comportamientos = metodo[1]
    condicion = self.condicion

    lambda { |*args|

      comportamientos.each {

          |comportamiento|

        resultado = instance_eval { comportamiento.call(*args) }

        if condicion.call(resultado)
          return resultado
        end

      }

      raise TraitConditionalEval, "Ninguna implementacion de :#{metodo[0].to_s} cumple con la condicion "

    }

  end


end
