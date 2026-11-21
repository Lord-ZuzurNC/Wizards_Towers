extends TestCase
## The seven wizard endings, named and ordered as GLOSSARY.md's Wizard endings table.


func test_the_seven_endings_carry_the_glossary_names_in_its_order() -> void:
	var expected: Array[String] = [
		"Crowned",
		"Cast from the Roof",
		"Murdered by its Own Kin",
		"Devoured by the Wilds",
		"Lost Below",
		"Claimed by …",
		"Outlived the World",
	]
	assert_eq(WizardEnding.Kind.size(), expected.size())
	assert_eq(WizardEnding.NAMES, expected)


func test_each_kind_reads_as_its_name() -> void:
	assert_eq(WizardEnding.label(WizardEnding.Kind.CROWNED), "Crowned")
	assert_eq(WizardEnding.label(WizardEnding.Kind.DEVOURED_WILDS), "Devoured by the Wilds")
	assert_eq(WizardEnding.label(WizardEnding.Kind.OUTLIVED), "Outlived the World")
