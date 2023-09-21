from datetime import datetime
from dataclasses import dataclass

from dataclass_wizard import JSONWizard

from src.utils.default_wizard_meta import DefaultWizardMeta


@dataclass
class EmployeesFilters(JSONWizard):

    class _(DefaultWizardMeta):
        pass

    hours_per_month_from: int
    hours_per_month_to: int
    birthday_from: datetime
    birthday_to: datetime
    gender: str
    sort_column: str
    asc: str