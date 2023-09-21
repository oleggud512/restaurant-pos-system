from dataclasses import dataclass
from dataclass_wizard import JSONWizard, json_field
from dataclass_wizard.enums import LetterCase


@dataclass
class Role(JSONWizard):

    class _(JSONWizard.Meta):
        key_transform_with_dump = LetterCase.SNAKE

    role_id: int
    role_name: str
    salary_per_hour: float
