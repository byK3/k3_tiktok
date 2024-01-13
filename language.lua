Config.Locales = {
    ['en'] = {
        ['rewardVehicle'] = "You got a new vehicle: %s",
        ['rewardMoney'] = "You got %s $",
        ['rewardItem'] = "You got x%s %s",
        ['rewardWeapon'] = "You got weapon: %s",
        ['alreadyClaimed'] = "You have already claimed your reward!",
        ['error'] = "An error occurred, please contact an admin!",
    },
    ['de'] = {
        ['rewardVehicle'] = "Du hast ein neues Fahrzeug erhalten: %s",
        ['rewardMoney'] = "Du hast %s $ erhalten",
        ['rewardItem'] = "Du hast x%s %s erhalten",
        ['rewardWeapon'] = "Du hast eine Waffe erhalten: %s",
        ['alreadyClaimed'] = "Du hast deinen Reward bereits erhalten!",
        ['error'] = "Ein Fehler ist aufgetreten, bitte kontaktiere einen Admin!",
    },
    ['tr'] = {
        ['rewardVehicle'] = "Yeni bir aracınız var: %s",
        ['rewardMoney'] = "%s $ kazandınız",
        ['rewardItem'] = "x%s %s kazandınız",
        ['rewardWeapon'] = "Yeni silah kazandınız: %s",
        ['alreadyClaimed'] = "Ödülünüzü zaten aldınız!",
        ['error'] = "Bir hata oluştu, lütfen admin iletişime geçin!",
    }
}



-- DONT TOUCH !!!!!! --
function Translate(key, ...)
    local lang = Config.Language or 'en'
    local translation = Config.Locales[lang][key] or 'Translation not found'
    if select("#", ...) > 0 then
        return string.format(translation, ...)
    else
        return translation
    end
end
