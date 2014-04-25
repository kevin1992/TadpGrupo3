
class EstrategiaAbstract

  def resolver

  end


  def resolverFinal resultados
    resultados
  end

  def modificarResolverFinal

  end

end



class EstrategiaTodosLosMensajes < EstrategiaAbstract

  def resolver trait1, trait2,metodoConflictivo,*args
    trait1.method(metodoConflictivo).call(*args)
    trait2.method(metodoConflictivo).call(*args)
  end

end

class EstrategiaExcepcion
  def resolver trait1, trait2,metodoConflictivo,*args
    throw Exception.new("Error, conflicto con el metodo "+metodoConflictivo.to_s)
  end
end

class EstrategiaPorFuncion  < EstrategiaAbstract

  attr_accessor :funcion

  def initialize(&bloque)
    self.funcion = bloque
  end


  def resolver trait1, trait2,metodoConflictivo,*args
    resultados = []
    resultados.push(trait1.method(metodoConflictivo).call(*args))
    resultados.push(trait2.method(metodoConflictivo).call(*args))

    resultados = resultados.flatten

    resultados[1..-1].inject(resultados[0]) {|result,elem| funcion.call(result,elem) }

  end

end


class EstrategiaNoHacerNada  < EstrategiaAbstract

  def resolver trait1, trait2,metodoConflictivo,*args

  end

end




class EstrategiaPorCorte  < EstrategiaAbstract

  attr_accessor :condicion

  def initialize(&bloque)
    self.condicion = bloque
  end


  def resolver trait1, trait2,metodoConflictivo,*args

    resultados = []
    resultados.push(trait1.method(metodoConflictivo).call(*args))
    resultados.push(trait2.method(metodoConflictivo).call(*args))

    resultados = resultados.flatten


    resultados = resultados.select {|*args| condicion.call(*args)}

    self.resolverFinal(resultados)

  end

  def modificarResolverFinal

    define_singleton_method(:resolverFinal) {
        |resultados|
      if (resultados[0])
        return resultados[0]
      else
        throw Exception.new("Ninguno satisface")
      end
    }

  end


end


