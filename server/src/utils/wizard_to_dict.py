from typing import Any

from dataclass_wizard import JSONWizard


def wizard_to_dict(wizard_list: list[JSONWizard]) -> list[dict[str, Any]]:
    return list(map(lambda x: x.to_dict(), wizard_list))
