from dataclasses import dataclass
from dataclass_wizard import JSONWizard, json_field
from dataclass_wizard.enums import LetterCase
from datetime import timedelta, date


@dataclass
class DiaryEntry(JSONWizard):

    class _(JSONWizard.Meta):
        key_transform_with_dump = LetterCase.SNAKE

    d_id: int
    emp_id: int
    start_time: timedelta
    end_time: timedelta
    gone: bool
    emp_name: str
    date: date = json_field('date_', all=True)
