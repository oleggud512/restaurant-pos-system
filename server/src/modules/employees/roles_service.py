from src.database import Db
from src.modules.employees.entities.role import Role


def get_all_roles() -> list[Role]:
    cur = Db.cur()

    cur.execute(f"""
        SELECT r.role_id, r.role_name, r.salary_per_hour
        FROM roles r
    """)

    roles = Db.fetch(cur)

    cur.close()
    return Role.from_list(roles)
