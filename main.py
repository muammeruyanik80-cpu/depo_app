from kivy.app import App
from kivy.lang import Builder
from kivy.uix.boxlayout import BoxLayout
import openpyxl
import os
from datetime import datetime

KV = '''
BoxLayout:
    orientation: 'vertical'
    padding: 20
    spacing: 10

    BoxLayout:
        id: login_box
        orientation: 'vertical'
        size_hint_y: None
        height: self.minimum_height
        spacing: 10

        TextInput:
            id: username_input
            hint_text: 'Kullanıcı Adı'
            multiline: False
            size_hint_y: None
            height: '40dp'

        Button:
            text: 'Başla'
            size_hint_y: None
            height: '40dp'
            on_release: app.set_username()

    BoxLayout:
        id: form_box
        orientation: 'vertical'
        spacing: 10
        opacity: 0
        disabled: True

        TextInput:
            id: stock_code
            hint_text: 'Stok Kodu'
            multiline: False
            size_hint_y: None
            height: '40dp'

        TextInput:
            id: quantity
            hint_text: 'Stok Adedi'
            multiline: False
            input_filter: 'int'
            size_hint_y: None
            height: '40dp'

        TextInput:
            id: depot
            hint_text: 'Depo No'
            multiline: False
            size_hint_y: None
            height: '40dp'

        TextInput:
            id: shelf
            hint_text: 'Raf No'
            multiline: False
            size_hint_y: None
            height: '40dp'

        Button:
            text: 'Kaydet'
            size_hint_y: None
            height: '50dp'
            on_release: app.save_to_excel()
'''

class DepoApp(App):
    def build(self):
        self.username = None
        return Builder.load_string(KV)

    def set_username(self):
        name = self.root.ids.username_input.text.strip()
        if name:
            self.username = name
            self.root.ids.login_box.opacity = 0
            self.root.ids.login_box.disabled = True
            self.root.ids.form_box.opacity = 1
            self.root.ids.form_box.disabled = False

    def save_to_excel(self):
        stock_code = self.root.ids.stock_code.text.strip()
        quantity = self.root.ids.quantity.text.strip()
        depot = self.root.ids.depot.text.strip()
        shelf = self.root.ids.shelf.text.strip()

        if not stock_code or not quantity or not depot or not shelf or not self.username:
            return

        filename = "stok_kayitlari.xlsx"
        if not os.path.exists(filename):
            from openpyxl import Workbook
            wb = Workbook()
            ws = wb.active
            ws.append(["Tarih", "Kullanıcı", "Stok Kodu", "Stok Adedi", "Depo No", "Raf No"])
        else:
            wb = openpyxl.load_workbook(filename)
            ws = wb.active

        now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        ws.append([now, self.username, stock_code, quantity, depot, shelf])
        wb.save(filename)

        self.root.ids.stock_code.text = ''
        self.root.ids.quantity.text = ''
        self.root.ids.depot.text = ''
        self.root.ids.shelf.text = ''

if __name__ == '__main__':
    DepoApp().run()# tetikleme testi 2
