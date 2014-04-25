require '../Tp1Tadp/framework'






CreadorTrait.definirTrait('MiTrait',EstrategiaExcepcion.new()) do

  agregarMethod :saludar do |persona|
        'Hola! '+persona.to_s
  end


  agregarMethod :chau do |persona|
     'chau! '+persona.to_s
  end

end

CreadorTrait.definirTrait('MiOtroTrait',EstrategiaExcepcion.new()) do

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

end



p= Persona.new

puts p.saludar("kevin")




