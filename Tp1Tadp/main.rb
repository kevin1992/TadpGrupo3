require_relative 'framework'


Trait.definirTrait('MiTrait') do

  agregarMethod :saludar do

    'Hola! ' + self.nombre
  end


  agregarMethod :chau do |num|
   5+ num
  end



end

Trait.definirTrait('MiOtroTrait') do

  agregarMethod :saltar do |num|
   puts 'Salto ' + num.to_s + ' Metros'
  end

  agregarMethod :chau do |num|
    7+ num
  end


end


Trait.definirTrait('TraitFacu') do

  agregarMethod :saludarFacu do
    puts 'Hola Facu'
  end
end


class PersonaSuma2Traits
  uses MiTrait + MiOtroTrait + TraitFacu, EstrategiaTodosLosMensajes.new()

  attr_accessor :nombre
  def initialize(nombre)
    self.nombre = nombre
  end

end

p= PersonaSuma2Traits.new("kevin")
p.saltar(5)
puts p.saludar()
puts p.chau(2)
p.saludarFacu

