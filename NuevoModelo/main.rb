

class M_trait

  attr_accessor :hashBloques

  def initialize
   # @hashBloques=[]
    @hashBloques= lambda {
        ||
      puts self
    }

  end


end

class Object
  def uses(unTrait)

    #instance_eval(unTrait.hashBloques.call)

  puts 'Dentro del uses soy: ' + self.to_s

  #self.define_singleton_method ('prueba1') do  |*args| unTrait.hashBloques.call(*args) end

  self.define_singleton_method('prueba1') {unTrait.hashBloques.call}

  define_method('prueba2')  {|*args| unTrait.hashBloques.call(*args)}

  self.instance_eval(){unTrait.hashBloques.call}


  end
end

class Persona

    uses M_trait.new


end


p = Persona.new
p.class.prueba1
p.prueba2

