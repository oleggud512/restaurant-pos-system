from dataclass_wizard import JSONWizard
from dataclass_wizard.enums import LetterCase


class DefaultWizardMeta(JSONWizard.Meta):
    key_transform_with_dump = LetterCase.SNAKE
