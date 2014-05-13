class Class

  attr_accessor :trait

  def uses(trt)
    trait = trt
    self.send :include, trt.definicion
  end
end
#"Por ejemplo, los traits podran denirse directamente como modules de Ruby,
# y luego en el momento de la composicion hacer los ajustes necesarios
# para que se aplique el algebra."  El bloque que recibe Trait.new es un module
# que al hacer uses, lo incluye a la clase