
require '../Tp1Tadp/frameworkExtras'
require '../Tp1Tadp/creador_trait'
require '../Tp1Tadp/trait'
require '../Tp1Tadp/estategias'





CreadorTrait.definirTrait('MiTrait',EstrategiaTodosLosMensajes.new()) do

  agregarMethod :saludar do |persona|
        puts 'Hola! '+persona.to_s
  end

  agregarMethod :funcion do |numero1, numero2|
    puts  numero1+numero2
   numero1+numero2
  end


end



CreadorTrait.definirTrait('OtroTrait',EstrategiaTodosLosMensajes.new ) do

  agregarMethod :saltar do
    puts "SALTO!"
  end


  agregarMethod :saludar do |persona|
    puts 'Hola2! '+persona.to_s
  end

  agregarMethod :funcion do |numero1, numero2|
    puts  numero1*numero2
    numero1*numero2
  end


end


CreadorTrait.definirTrait('TercerTrait',EstrategiaTodosLosMensajes.new) do



  agregarMethod :comer do
    puts "Como!"
  end

  agregarMethod :saludar do |persona|
    puts 'Hola3! '+persona.to_s
  end

  agregarMethod :funcion do |numero1, numero2|
    puts  numero1*numero1
    numero1*numero1
  end

end



CreadorTrait.definirTrait('ExpTrait') do



  agregarMethod :comer do
    puts "Como!"
  end

  agregarMethod :saludar do |persona|
    puts 'Hola3! '+persona.to_s
  end

  agregarMethod :funcion do |numero1, numero2|
    puts  numero1*numero1
    numero1*numero1
  end

end


class Persona
  uses MiTrait + OtroTrait

end

p = Persona.new
p.saludar('persona')


