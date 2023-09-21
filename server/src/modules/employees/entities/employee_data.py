from dataclasses import dataclass,
from dataclass_wizard import JSONWizard, json_field,
from dataclass_wizard.enums import LetterCase

from src.modules.employees.entities.employee import Employee


@dataclass
class EmployeeData(JSONWizard):

    class _(JSONWizard.Meta):
        key_transform_with_dump = LetterCase.SNAKE

    employees: list[Employee]
    filter_sort_data: