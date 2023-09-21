from src.database import Db
from src.modules.employees.entities.diary_entry import DiaryEntry


def get_all_diary_entries() -> list[DiaryEntry]:
    cur = Db.cur()

    cur.execute(f"""
        SELECT d.d_id, 
            d.date_, 
            d.emp_id, 
            d.start_time, 
            d.end_time, 
            d.gone, 
            CONCAT(e.emp_lname, ' ', e.emp_fname) as emp_name
        FROM diary d JOIN employees e USING(emp_id)
        ORDER BY 
            date_ DESC, 
            start_time DESC, 
            end_time DESC 
    """)

    diary = Db.fetch(cur)

    cur.close()
    return DiaryEntry.from_list(diary)
