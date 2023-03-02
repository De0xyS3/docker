# -*- coding: utf-8 -*-
# Part of Softhealer Technologies.
from odoo import api, fields, models, _

class sh_message_wizard(models.TransientModel):
    _name="sh.message.wizard"
    _description = "Message wizard to display warnings, alert ,success messages"      
    
    def get_default(self):
        if self.env.context.get("message",False):
            return self.env.context.get("message")
        return False 

    name=fields.Html(string="Message",readonly=True,default=get_default)
    title = fields.Char(string='Titulo')
    type_message = fields.Selection(string='Tipo', selection=[('info', 'Informacion'),('error', 'Error')])

    def create_message(self, message, title=False, type_message='info'):        
        return {
            'name': title if title != False else 'Mensaje',
            'type': 'ir.actions.act_window',
            'view_mode': 'form',
            'res_model': 'sh.message.wizard',
            'target': 'new',
            'context' : {'default_name' : message, 'default_title': title, 'default_type_message': type_message}
        }
    