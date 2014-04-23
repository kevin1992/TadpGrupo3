#TODO hacer que se banque metodos con parametros

class Trait

  def self.define(nombre,&bloqueMetodos)

    nuevoTrait = Object.const_set(nombre,TraitOperador.new)




    nuevoTrait.instance_eval(&bloqueMetodos)


  end

end



class TraitOperador

  attr_accessor :metodosAgregados

  def initialize()
    self.metodosAgregados = []
  end

  def agregarMethod(nombre, &bloque)
   define_singleton_method nombre , lambda {bloque.yield}
   self.metodosAgregados.push(nombre)
  end


  def - (*metodos)

    nuevoTrait = self.clone

    metodos.each {|metodo| nuevoTrait.singleton_class.send(:remove_method, metodo)
    nuevoTrait.metodosAgregados.delete(metodo)
    }

    nuevoTrait


  end

  def + (otroTrait)

    nuevoTrait = TraitOperador.new;

    this = self

   self.metodosAgregados.each {|nombreMetodo|
     nuevoTrait.define_singleton_method(nombreMetodo)  {this.method(nombreMetodo).call}
   nuevoTrait.metodosAgregados.push(nombreMetodo)
   }

    otroTrait.metodosAgregados.each {|nombreMetodo|

      if (nuevoTrait.metodosAgregados.include? nombreMetodo)
        nuevoTrait.define_singleton_method(nombreMetodo)  {throw Exception.new("Conflicto del metodo #{nombreMetodo} ") }
      else
        nuevoTrait.define_singleton_method(nombreMetodo)  {otroTrait.method(nombreMetodo).call}
      nuevoTrait.metodosAgregados.push(nombreMetodo)
      end

    }

    nuevoTrait

  end



end



class Object

  def uses trait, lista=trait.metodosAgregados


    lista = lista.select {|elem| trait.metodosAgregados.include? elem }

    lista.each {|nombreMetodo| define_method(nombreMetodo)  {trait.method(nombreMetodo).call}}

  end


end




Trait.define('MiTrait') do

  agregarMethod :saludar do
        puts "Hola!"
  end

  agregarMethod :sumar do
    puts "5"
  end


end


Trait.define('OtroTrait') do

  agregarMethod :saltar do
    puts "SALTO!"
  end


  agregarMethod :saludar do
    puts "sdfsdfdsdsfdsfsd!"
  end


end


Trait.define('TercerTrait') do

  agregarMethod :comer do
    puts "Como!"
  end

  agregarMethod :saludar do
    puts "aosoapskdoo!"
  end



end


class Persona

  uses (MiTrait + (OtroTrait- :saludar))

end

p = Persona.new



p.sumar()
p.saludar()
p.saltar()