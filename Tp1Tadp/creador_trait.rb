class CreadorTrait

  def self.definirTrait(nombre,&bloqueMetodos)

    nuevoTrait = Object.const_set(nombre,Trait.new)
    #   nuevoTrait.instance_eval(&bloqueMetodos)
    nuevoTrait.agregarMetodos &bloqueMetodos


  end

end
