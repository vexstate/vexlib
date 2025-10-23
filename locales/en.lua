Locales = Locales or {}
Locales['en'] = {
    ['welcome'] = 'Welcome to Vexstate!',
    ['goodbye'] = 'See you later!',
    ['Exception'] = 'An unknown error occurred.',
    ['InvalidTypeException'] = 'Invalid type provided.',
    ['InvalidValueError'] = 'Invalid value provided.'
}

if Vex and Vex.Locale and Vex.Locale.register then
    Vex.Locale.register('en', Locales['en'])
end
