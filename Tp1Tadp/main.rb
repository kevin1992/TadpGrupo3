require '../Tp1Tadp/framework'






CreadorTrait.definirTrait('MiTrait',EstrategiaTodosLosMensajes.new()) do

  agregarMethod :saludar do

    'Hola!' + self.nombre
  end


  agregarMethod :chau do |persona|
     'chau! '+persona.to_s
  end

end

CreadorTrait.definirTrait('MiOtroTrait',EstrategiaTodosLosMensajes.new()) do

  agregarMethod :saludar do |persona|
   'Hola2! '+persona.to_s
  end


end

estrategia = EstrategiaPorCorte.new() {|elem| elem>0 }


CreadorTrait.definirTrait('Trait1',estrategia  ) do

  agregarMethod :saltar do
   1
  end
end
CreadorTrait.definirTrait('Trait2',estrategia  ) do

  agregarMethod :saltar do
  -2
  end
end
CreadorTrait.definirTrait('Trait3',estrategia ) do

  agregarMethod :saltar do
  -3
  end
end

CreadorTrait.definirTrait('Trait4',estrategia ) do

  agregarMethod :saltar do
   -5
  end
end



class Persona
  uses MiTrait
  attr_accessor :nombre
  def initialize
    self.nombre = "kvdgdfevin"
  end
  
end



p= Persona.new

puts p.saludar()





