require_relative 'framework'






CreadorTrait.definirTrait('MiTrait',EstrategiaTodosLosMensajes.new()) do

  agregarMethod :saludar do

    'Hola!' + self.nombre
  end


  agregarMethod :chau do
     'chau! '+nombre.to_s
  end

end

CreadorTrait.definirTrait('MiOtroTrait',EstrategiaTodosLosMensajes.new()) do

  agregarMethod :saludar do
    'conflicto mi otro trait'
  end
  agregarMethod :hablar do ||
   'blabla '+nombre.to_s
  end


end

estrategia = EstrategiaPorCorte.new() {|elem| elem>0 }

=begin
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
=end


class Persona
  uses MiTrait+MiOtroTrait
  attr_accessor :nombre
  def initialize(nombre)
    self.nombre = nombre
    end

end    #tira TraitException por :saludar

p= Persona.new("kevin")

puts p.saludar
puts p.chau

# class Persona
#   uses (MiTrait+MiOtroTrait){
#     resolver_con(EstrategiaTodosLosMensajes.new, :saludar, :mitrait_saludar)
#   }
#   attr_accessor :nombre
#   def initialize(nombre)
#     self.nombre = nombre
#   end
#
# end    #sintaxis para resolver conflictos
#
#
#
#
