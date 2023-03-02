from odoo import api, fields, models


class ResConfigSettings(models.TransientModel):
    _inherit = 'res.config.settings'

    checklist_allow_reset_after_completed = fields.Boolean("Allow Reset Activity After Completed", help="User can reset activity from Done To TODO", config_parameter='checklist_allow_reset_after_completed')
    checklist_allow_reset_after_canceled = fields.Boolean("Allow Reset Activity After Canceled", help="User can reset activity from Canceled To TODO", config_parameter='checklist_allow_reset_after_canceled')
    group_checklist_task_progress_restrictions = fields.Boolean(string="Task Progress Restriction", implied_group='task_subtask_checklist.group_checklist_task_progress_restrictions',
        help="Restrict Task Progress Before All Checklist Either Canceled Or Completed.")