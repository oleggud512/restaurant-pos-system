from dataclasses import dataclass
from typing import Annotated

from dataclass_wizard import json_field, JSONWizard, Pattern
from dataclass_wizard.enums import LetterCase

from datetime import date


@dataclass
class Employee(JSONWizard):

    class _(JSONWizard.Meta):
        key_transform_with_dump = LetterCase.SNAKE

    emp_id: int
    role_id: int
    is_waiter: bool
    emp_fname: str
    emp_lname: str
    birthday: date
    phone: str
    email: str
    hours_per_month: int
    gender: str
