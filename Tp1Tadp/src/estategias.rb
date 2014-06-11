class TraitImplementationError < StandardError; end
class TraitConditionalEval < TraitImplementationError; end

class EstrategiaTodosLosMensajes

  def resolver(nombre, bloques)

    #Arma un Proc que ejecuta todos los comportamientos y devuelve el ultimo

    comportamientos = bloques

    lambda do |*args|
      for i in 0..comportamientos.size-2
        instance_exec *args,&comportamientos[i]

      end
      return instance_exec *args,&comportamientos.last

    end

  end

end

class EstrategiaExcepcion

  def resolver(nombre,bloques)

    lambda { raise TraitImplementationError, 'Conflicto con el metodo '+ nombre.to_s.upcase }

  end

end

class EstrategiaPorFuncion

  attr_accessor :funcion

  def initialize(&bloque)
    self.funcion = bloque
  end


  def resolver(nombre, bloques)

    comportamientos = bloques
    funcion = self.funcion

    lambda { |*args|

      resultados = comportamientos.map { |comportamiento| instance_exec *args,&comportamiento }

      resultado_final = resultados[1..-1].inject(resultados[0]) { |result, elem| funcion.call(result, elem) }

      resultado_final }

  end

end




class EstrategiaPorCorte

  attr_accessor :condicion

  def initialize(&bloque)
    self.condicion = bloque
  end


  def resolver(nombre, bloques)

    comportamientos = bloques
    condicion = self.condicion

    lambda { |*args|

      comportamientos.each {

          |comportamiento|

       # resultado = instance_eval { comportamiento.call(*args) }
        resultado = instance_exec *args,&comportamiento

        if instance_exec resultado,&condicion
          return resultado
        end

      }

      raise TraitConditionalEval, "Ninguna implementacion de :#{nombre.to_s} cumple con la condicion "

    }

  end


end
