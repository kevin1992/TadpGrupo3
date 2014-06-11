require_relative 'framework'

TraitImplem.definirTrait('MiTrait') do

  method :saludar do
    'Hola! ' + self.nombre
  end


  method :chau do |num|
   self.valorEsperado + num
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
  attr_accessor :nombre, :valorEsperado

  uses  MiTrait + MiOtroTrait;
 # uses MiTrait + MiOtroTrait , EstrategiaPorCorte.new() {|resultado| resultado > self.valorEsperado}

  def initialize(nombre,estrategia)

    self.nombre = nombre
    self.valorEsperado =11;
    definirMetodos estrategia

  end

end

p= PersonaSuma2Traits.new("kevin", EstrategiaTodosLosMensajes.new())
p.saltar(5)
puts p.saludar()
puts p.chau(2)


