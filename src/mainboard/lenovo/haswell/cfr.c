/* SPDX-License-Identifier: GPL-2.0-only */

#include <boot/coreboot_tables.h>
#include <drivers/option/cfr_frontend.h>
#include <ec/lenovo/h8/cfr.h>
#include <ec/lenovo/pmh7/cfr.h>
#include <southbridge/intel/lynxpoint/cfr.h>

/*
 * FIXME: Hide dGPU CFR entry if dGPU isn't present?
 * See code at SKL/KBL with GPIO detection for dGPU.
 * Maybe that's also possible for Haswell ThinkPads?
 */
static const struct sm_object dgpu = SM_DECLARE_BOOL({
	.opt_name	= "enable_dual_graphics",
	.ui_name	= "dGPU",
	.ui_helptext	= "Enable or disable the dGPU",
	.default_value	= false,
});

static struct sm_obj_form system = {
	.ui_name = "System",
	.obj_list = (const struct sm_object *[]) {
		&dgpu,
		&nmi,
		NULL
	},
};

static struct sm_obj_form power = {
	.ui_name = "Power",
	.obj_list = (const struct sm_object *[]) {
		&power_on_after_fail,
		&usb_always_on,
		NULL
	},
};

static struct sm_obj_form devices = {
	.ui_name = "Devices",
	.obj_list = (const struct sm_object *[]) {
		&wlan,
		NULL
	},
};

static struct sm_obj_form hid = {
	.ui_name = "Keyboard/Mouse",
	.obj_list = (const struct sm_object *[]) {
		&trackpoint,
		&keyboard_backlight,
		&fn_ctrl_swap,
		&sticky_fn,
		&f1_to_f12_as_primary,
		NULL
	},
};

static struct sm_obj_form misc = {
	.ui_name = "Other",
	.obj_list = (const struct sm_object *[]) {
		&volume,
		NULL
	},
};

static struct sm_obj_form *sm_root[] = {
	&system,
	&power,
	&devices,
	&hid,
	&misc,
	NULL
};

void mb_cfr_setup_menu(struct lb_cfr *cfr_root)
{
	cfr_write_setup_menu(cfr_root, sm_root);
}
