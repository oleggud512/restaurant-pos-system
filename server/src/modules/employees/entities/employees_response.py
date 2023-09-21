from dataclasses import dataclass, field
from dataclass_wizard import JSONWizard, json_field

from src.modules.employees.entities.employee import Employee
from src.modules.employees.entities.employees_filter_data import \
    EmployeesFilters
from src.utils.default_wizard_meta import DefaultWizardMeta


@dataclass(kw_only=True)
class EmployeesResponse(JSONWizard):
    class _(DefaultWizardMeta):
        pass

    employees: list[Employee]
    filter_sort_data: EmployeesFilters
