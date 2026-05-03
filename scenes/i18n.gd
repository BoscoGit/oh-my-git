extends Node

const LOCALES = ["en", "pt_BR"]
const LOCALE_NAMES = {
	"en": "English",
	"pt_BR": "Português (BR)"
}

func _ready():
	for locale in LOCALES:
		_load_locale(locale)

func _load_locale(locale):
	var path = "res://translations/%s.json" % locale
	var file = File.new()
	if not file.file_exists(path):
		return
	file.open(path, File.READ)
	var data = parse_json(file.get_as_text())
	file.close()

	var t = Translation.new()
	t.locale = locale
	for key in data:
		t.add_message(key, data[key])
	TranslationServer.add_translation(t)
