require '../Tp1Tadp/framework'






CreadorTrait.definirTrait('MiTrait',EstrategiaTodosLosMensajes.new()) do

  agregarMethod :saludar do |persona|
        puts 'Hola! '+persona.to_s
  end

  agregarMethod :funcion do |numero1, numero2|
    puts  numero1+numero2
   numero1+numero2
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
  uses Trait1

end



p= Persona.new

puts p.saltar()

