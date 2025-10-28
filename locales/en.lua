Locales = Locales or {}

Locales['en'] = {
    ['welcome'] = 'Welcome to Vexstate!',
    ['goodbye'] = 'See you later!',
    ['Exception'] = 'An unknown error occurred.',
    ['InvalidType'] = 'Invalid type provided.',
    ['InvalidValue'] = 'Invalid value provided.',
    ['OK_CAPS'] = 'Everything is right',
    ['OK'] = 'ok',
    ['ERROR'] = 'error',
    ['InvalidArgument'] = 'Invalid argument provided.'
}

if Vex and Vex.Locale and Vex.Locale.register then
    Vex.Locale.register('en', Locales['en'])
end
