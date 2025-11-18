import sqlite3, csv, os
from datetime import datetime

def export_db_to_csv(db_path='inventory.db', out_dir=None):
    if out_dir is None:
        out_dir = os.path.join(os.path.expanduser('~'), 'Documents')

    conn = sqlite3.connect(db_path)
    cur = conn.cursor()
    cur.execute('SELECT username, stock_code, quantity, depot, shelf, timestamp FROM products ORDER BY timestamp DESC')
    rows = cur.fetchall()
    conn.close()

    ts = datetime.now().strftime('%Y%m%d_%H%M%S')
    filename = f'inventory_{ts}.csv'
    out_path = os.path.join(out_dir, filename)
    os.makedirs(out_dir, exist_ok=True)

    with open(out_path, 'w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        writer.writerow(['Kullanıcı Adı', 'Stok Kodu', 'Stok Adedi', 'Depo No', 'Raf No', 'Tarih'])
        writer.writerows(rows)

    return out_path