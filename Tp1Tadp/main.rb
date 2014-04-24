
require '../Tp1Tadp/frameworkExtras'
require '../Tp1Tadp/creador_trait'
require '../Tp1Tadp/trait'

CreadorTrait.definirTrait('MiTrait') do

  agregarMethod :saludar do |persona|
        puts 'Hola! '+persona.to_s
  end

  agregarMethod :sumar do |numero1, numero2|
    puts numero1+numero2
  end


end



CreadorTrait.definirTrait('OtroTrait') do

  agregarMethod :saltar do
    puts "SALTO!"
  end


  agregarMethod :saludar do
    puts "sdfsdfdsdsfdsfsd!"
  end

  agregarMethod :sumar do
    puts "sdfsdfdsdsfdsfsd!"
  end


end


CreadorTrait.definirTrait('TercerTrait') do

  agregarMethod :comer do
    puts "Como!"
  end

  agregarMethod :saludar do
    puts "aosoapskdoo!"
  end



end



class Persona
  uses MiTrait
end

p = Persona.new

p.saludar()

