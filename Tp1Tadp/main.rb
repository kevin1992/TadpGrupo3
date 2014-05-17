require_relative 'framework'






CreadorTrait.definirTrait('MiTrait') do

  agregarMethod :saludar do

    'Hola! ' + self.nombre
  end


  agregarMethod :chau do |num|
   5+ num
  end



end

CreadorTrait.definirTrait('MiOtroTrait') do

  agregarMethod :saltar do |num|
   puts 'Salto ' + num.to_s + ' Metros'
  end

  agregarMethod :chau do |num|
    7+ num
  end


end


class PersonaSuma2Traits
  uses MiTrait + MiOtroTrait , EstrategiaPorCorte.new() {|resultado| resultado>11}

  attr_accessor :nombre
  def initialize(nombre)
    self.nombre = nombre
  end

end

p= PersonaSuma2Traits.new("kevin")
p.saltar(5)
puts p.saludar()
puts p.chau(2)


