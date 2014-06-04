require_relative 'framework'

TraitImplem.definirTrait('MiTrait') do

  method :saludar do

    'Hola! ' + self.nombre
  end


  method :chau do |num|
    5+ num
  end

end

TraitImplem.definirTrait('MiOtroTrait') do

  method :saltar do |num|
    puts 'Salto ' + num.to_s + ' Metros'
  end

  method :chau do |num|
    7+ num
  end


end


class PersonaSuma2Traits
  uses MiTrait + MiOtroTrait, EstrategiaPorCorte.new() { |resultado| resultado>11 }

  attr_accessor :nombre

  def initialize(nombre)
    self.nombre = nombre
  end

end

p= PersonaSuma2Traits.new("kevin")
p.saltar(5)
puts p.saludar()
puts p.chau(2)


