require 'rspec'

describe 'Estrategias Todos Los mensajes' do

  class A
    attr_accessor :uno, :dos

    def initialize
      @uno = 1
      @dos = 2
    end

    def mas_uno(valor)
      valor + 1
    end
  end

  it 'puede usar métodos con parámetros' do
    m1 = lambda { |un_parametro, otro_parametro|
      "algo"
    }
    m2 = lambda { |un_parametro, otro_parametro|
      un_parametro + otro_parametro
    }

    metodos = [m1, m2]
    resultado = EstrategiaTodosLosMensajes.new.resolver("metodo", metodos)
    A.send(:define_method, :metodo, resultado)

    A.new.metodo(1, 2).should == 3
  end

  it 'ejecuta todos los métodos en orden' do
    orden = []

    m1 = lambda {
      orden << "m1"
    }
    m2 = lambda {
      orden << "m2"
    }
    metodos = [m1, m2]
    resultado = EstrategiaTodosLosMensajes.new.resolver("metodo", metodos)
    A.send(:define_method, :metodo, resultado)

    A.new.metodo

    orden.should == ["m1", "m2"]
  end

  it 'retorna el resultado del último método' do
    m1 = lambda {
      "m1"
    }
    m2 = lambda {
      "m2"
    }
    metodos = [m1, m2]
    estrategia = EstrategiaTodosLosMensajes.new

    resultado = estrategia.resolver("metodo", metodos)
    A.send(:define_method, :metodo, resultado)

    A.new.metodo.should == "m2"
  end

  it 'puede usar variables de instancia y métodos' do
    m1 = lambda {
      @uno = 123
    }
    m2 = lambda {
      @dos = mas_uno(@dos)
    }
    metodos = [m1, m2]
    estrategia = EstrategiaTodosLosMensajes.new

    resultado = estrategia.resolver("metodo", metodos)
    A.send(:define_method, :metodo, resultado)

    instancia = A.new

    instancia.uno.should == 1
    instancia.uno.should == 2
    instancia.metodo
    instancia.uno.should == 123
    instancia.uno.should == 3
  end

end

describe 'Estrategias XXXXX' do

  it 'should do something' do
    true.should == false
  end

end
