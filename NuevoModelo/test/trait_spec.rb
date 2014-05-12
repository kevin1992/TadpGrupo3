require 'rspec'

# Les muestro un par de cosas de ruby
describe 'Ruby' do

  it 'puedo definir una clase para hacer test sin tener efecto de lado entre cada uno' do
    # Cuando creo una clase de esta forma (en vez de usar class Constante ... end)
    # cuando ejecute el siguiente test, los cambios que haga en esta clase no van a ser visibles en ningún lado
    # ya que la clase no se "guardó" en una constante, sino en una variable local al test
    # (si no se entiendo esto me avisan)

    mi_clase = Class.new {

      def hola
        'hola'
      end

    }

    mi_clase.new.hola.should == 'hola'
  end

  it 'cuando uso instance_eval, cambia el self por el objeto al que le mando el "instance_eval" ' do
    mi_lista = []

    mi_lista.push(5)
    mi_lista.should == [5]

    mi_lista.instance_eval {
      push(6)
      self.push(7)
    }
    mi_lista.should == [5, 6, 7]

    resultado_del_instance_eval = mi_lista.instance_eval {
      self
    }

    resultado_del_instance_eval.should == mi_lista
  end

  it 'define_method agrega un método a una clase' do
    mi_clase = Class.new {}

    # define_method es "private" entonces tengo que hacer la llamada con "send"
    # miClase.define_method :m do
    #    'esto es m'
    # end

    mi_clase.send(:define_method, :m) do
      'esto es m'
    end

    mi_clase.new.m.should == 'esto es m'
  end

  it 'define_singleton_method agrega un método a la singleton class de una instancia' do
    mi_clase = Class.new {}
    una_instancia = mi_clase.new

    una_instancia.define_singleton_method :m do
       'solo existo en "una_instancia"'
    end

    una_instancia.m.should == 'solo existo en "una_instancia"'

    # no existe para otras instancias de la misma clase
    expect {
      mi_clase.new.m
    }.to raise_error NoMethodError
  end

end

describe 'Trait' do

  # Comento el siguiente código porque sino no van a correr los test, igualmente es
  # uno de los traits que les puede servir para testear

  # trait :UnTrait do
  #
  #   metodo :m do
  #     'soy m del trait'
  #   end
  #
  # end

  it 'puede ser usado en una clase' do

    # miClase = Class.new {
    #
    #   uses UnTrait
    #
    # }
    #
    # miClase.new.m.should == 'soy m del trait'
  end

end