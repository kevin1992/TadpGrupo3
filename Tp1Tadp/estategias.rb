
class EstrategiaTodosLosMensajes

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

class EstrategiaPorFuncion




  def resolver trait1, trait2,metodoConflictivo,*args
    resultados = []
    resultados.push(  trait1.method(metodoConflictivo).call(*args))
    resultados.push( trait2.method(metodoConflictivo).call(*args))

    #resultados.each { |r| funcion r}

    resultados = resultados.flatten

   resultados[1..-1].inject(resultados[0]) {|result,elem| result+elem }

  end

end
