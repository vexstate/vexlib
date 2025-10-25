Locales = Locales or {}
Locales['en'] = {
    ['welcome'] = 'Welcome to Vexstate!',
    ['goodbye'] = 'See you later!',
    ['Exception'] = 'An unknown error occurred.',
    ['InvalidType'] = 'Invalid type provided.',
    ['InvalidValue'] = 'Invalid value provided.',
    ['OK'] = 'Everything is right',
    ['InvalidArgument'] = 'Invalid argument provided.'
}

if Vex and Vex.Locale and Vex.Locale.register then
    Vex.Locale.register('en', Locales['en'])
end
