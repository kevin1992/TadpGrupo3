require 'rspec'
require_relative '../src/estategias'

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

  it 'puede usar metodos con parametros' do
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

  it 'ejecuta todos los metodos en orden' do
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

  it 'retorna el resultado del ultimo metodo' do
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

  it 'puede usar variables de instancia y metodos' do
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
    instancia.dos.should == 2
    instancia.metodo
    instancia.uno.should == 123
    instancia.dos.should == 3
  end

end

describe 'Estrategia Por Corte' do

  m5 = lambda{5}
  m7 = lambda{7}
  m12 = lambda{12}
  m15 = lambda{15}

  it 'ejecuta el 1er metodo que devuelve lo especificado' do
    estrategia = EstrategiaPorCorte.new {|n| n > 10}
    r = estrategia.resolver('mets', [m5,m7,m12,m15])

    class N; end
    N.send(:define_method, 'm', r)

    N.new.m.should == 12

  end

  it 'tira excepcion si ninguno cumple' do

    estrategia = EstrategiaPorCorte.new {|n| n > 15}
    r = estrategia.resolver('mets', [m5,m7,m12,m15])
    class N; end
    N.send(:define_method, 'metodo', r)

    expect {
      N.new.metodo
    }.to raise_error TraitConditionalEval

  end

end

describe 'Estrategia Por Funcion' do

  estrategia = EstrategiaPorFuncion.new { |x, y| x*y }

  it 'le mando 4 metodos que devuelven 1,2,3,4' do
    m1 = lambda{1}
    m2 = lambda{2}
    m3 = lambda{3}
    m4 = lambda{4}


    r = estrategia.resolver('metodo', [m1,m2,m3,m4])

    class N; end
    N.send(:define_method, 'm', r)

    N.new.m.should == 24


  end

end