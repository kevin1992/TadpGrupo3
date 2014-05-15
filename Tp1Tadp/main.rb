require_relative 'framework'






CreadorTrait.definirTrait('MiTrait') do

  agregarMethod :saludar do

    'Hola! ' + self.nombre
  end


  agregarMethod :chau do  |nombre|
     'chau! '+nombre.to_s
  end

end



class Persona

  uses MiTrait
  attr_accessor :nombre
  def initialize(nombre)
    self.nombre = nombre
    end

end

p= Persona.new("kevin")

puts p.saludar
puts p.chau('kevin')
