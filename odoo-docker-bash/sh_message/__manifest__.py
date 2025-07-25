# -*- coding: utf-8 -*-
# Part of Softhealer Technologies.
{
    "name" : "Popup Message",
    "author" : "Softhealer Technologies",
    "website": "https://www.softhealer.com",
    "support": "info@softhealer.com",        
    "category": "Extra Tools",
    "summary": """
create Success, warnings, alert message box wizard,success popup message app, alert popup module, email popup module odoo
        
                    """,
    "description": """
        This module is useful to crate custom message/pop up wizard.
        You can create Success, warnings, alert message box wizard by the few line of code.
        
                    """,    
    "version":"12.0.1",
    "depends" : ["base","web"],
    "application" : True,
    "data" : [
        'wizard/sh_message_wizard.xml',        
        'security/ir.model.access.csv',
            ],            
    "images": ["static/description/background.png",],              
    "auto_install":False,
    "installable" : True,      
}
