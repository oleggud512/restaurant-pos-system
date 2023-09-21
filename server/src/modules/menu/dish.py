from dataclass_wizard import JSONWizard, json_field
from dataclass_wizard.enums import LetterCase
from dataclasses import dataclass

from typing import Any


@dataclass
class DishGrocery(JSONWizard):

    class _(JSONWizard.Meta):
        key_transform_with_dump = LetterCase.SNAKE

    groc_id: int
    groc_count: float
    dish_id: int | None = None
    groc_name: str = json_field('groc_name', default='')


@dataclass
class Dish(JSONWizard):

    class _(JSONWizard.Meta):
        key_transform_with_dump = LetterCase.SNAKE

    dish_id: int
    dish_name: str
    dish_photo_url: str = ''
    dish_descr: str = ''
    dish_price: float = 0
    dish_gr_id: int | None = None  # TODO: make filters handle cases where there is no dish_group
    dish_groceries: list[DishGrocery] = json_field('dish_groceries', default_factory=list)
