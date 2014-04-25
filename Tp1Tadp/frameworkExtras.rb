class Object



  def uses (trait, lista=trait.metodosAgregados)


    lista = lista.select {|elem| trait.metodosAgregados.include? elem }

    lista.each {|nombreMetodo| define_method(nombreMetodo)  {|*args| trait.method(nombreMetodo).call(*args)}}


    trait.estrategia.modificarResolverFinal()

    end


end

