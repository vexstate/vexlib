Locales = Locales or {}
Locales['es'] = {
    ['welcome'] = '¡Bienvenido a Vexstate!',
    ['goodbye'] = '¡Hasta luego!',
    ['Exception'] = 'Ocurrió un error desconocido.',
    ['InvalidTypeException'] = 'Tipo inválido proporcionado.',
    ['InvalidValueError'] = 'Valor inválido proporcionado.'
}

if Vex and Vex.Locale and Vex.Locale.register then
    Vex.Locale.register('es', Locales['es'])
end
