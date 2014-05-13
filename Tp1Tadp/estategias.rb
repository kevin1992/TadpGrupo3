
class EstrategiaAbstract

  attr_accessor :metodos

  def initilize
    self.metodos=[]
  end

  def agrega (m)
    puts m
    puts self.metodos.class   #para prueba
    self.metodos << m.to_s
  end

=begin
  def resolver(*metodos_conflictivos)
    throw Exception.new('Error. Metodos conflictivos: ' + metodos_conflictivos.to_s)
  end

  def resolver_final(resultados)
    resultados
  end

  def modificar_resolver_final
  end
=end
end


class EstrategiaTodosLosMensajes < EstrategiaAbstract

  def resolver(clase)
    clase.define_method (metodos[0]) {clase.ejecutar(metodos)}
  end

end

class EstrategiaExcepcion < EstrategiaAbstract
  def resolver(trait1, trait2, metodo_conflictivo, *args)
    throw Exception.new("Error, conflicto con el metodo " + metodo_conflictivo.to_s)
  end
end

class EstrategiaPorFuncion  < EstrategiaAbstract

  attr_accessor :funcion

  def initialize(&bloque)
    self.funcion = bloque
  end


  def resolver(trait1, trait2, metodo_conflictivo, *args)
    resultados = []
    resultados.push(trait1.method(metodo_conflictivo).call(*args))
    resultados.push(trait2.method(metodo_conflictivo).call(*args))

    resultados = resultados.flatten

    resultados[1..-1].inject(resultados[0]) { |result, elem| funcion.call(result, elem) }

  end

end


class EstrategiaNoHacerNada  < EstrategiaAbstract

  def resolver(trait1, trait2, metodo_conflictivo, *args)

  end

end




class EstrategiaPorCorte  < EstrategiaAbstract

  attr_accessor :condicion

  def initialize(&bloque)
    self.condicion = bloque
  end


  def resolver(trait1, trait2, metodo_conflictivo, *args)

    resultados = []
    resultados.push(trait1.method(metodo_conflictivo).call(*args))
    resultados.push(trait2.method(metodo_conflictivo).call(*args))

    resultados = resultados.flatten


    resultados = resultados.select { |*args| condicion.call(*args) }

    self.resolver_final(resultados)

  end

  def modificar_resolver_final

    define_singleton_method(:resolverFinal) {
        |resultados|
      if resultados[0]
        return resultados[0]
      else
        throw Exception.new("Ninguno satisface la condicion dada")
      end
    }

  end


end



