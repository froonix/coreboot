/* SPDX-License-Identifier: GPL-2.0-only */

/*
#define START_THRESH_ARG 0
#define STOP_THRESH_ARG 1
*/

/* EC Registers */
/*
Field (ERAM, ByteAcc, NoLock, Preserve)
{
	Offset(0xa0),
			    , 15,
			BAMA,  1,
}
*/

// Quote from thinkpad_acpi.c:
//	static int tpacpi_battery_set(int what, int battery, int value)
//	{
//		int param, ret;
//		/* The first 8 bits are the value of the threshold */
//		param = value;
//		/* The battery ID is in bits 8-9, 2 bits */
//		param |= battery << 8;

// Set discharge status
Method (BDSS, 1, NotSerialized)
{
	// Quote from thinkpad_acpi.c:
	//	case FORCE_DISCHARGE:
	//		/* Force discharge is in bit 0,
	//		 * break on AC attach is in bit 1 (won't work on some ThinkPads),
	//		 * battery ID is in bits 8-9, 2 bits.
	//		 */
	//		if (ACPI_FAILURE(tpacpi_battery_acpi_eval(SET_DISCHARGE, &ret, param))) {
	//			pr_err("failed to set force discharge on %d", battery);
	//			return -ENODEV;
	//		}
	//		return 0;

	// FIXME: Implement BDSS!
	//
	//        BAT0 = send 0x04 (or 0x06) to register 0xb4
	//        BAT1 = send 0x04 (or 0x06) to register 0xb5
	// ...

	Return (1 << 31)
}

// Set inhabit charge status
Method (BICS, 1, NotSerialized)
{
	// Quote from thinkpad_acpi.c:
	//	case INHIBIT_CHARGE:
	//		/* When setting inhibit charge, we set a default value of
	//		 * always breaking on AC detach and the effective time is set to
	//		 * be permanent.
	//		 * The battery ID is in bits 4-5, 2 bits,
	//		 * the effective time is in bits 8-23, 2 bytes.
	//		 * A time of FFFF indicates forever.
	//		 */
	//		param = value;
	//		param |= battery << 4;
	//		param |= 0xFFFF << 8;
	//		if (ACPI_FAILURE(tpacpi_battery_acpi_eval(SET_INHIBIT, &ret, param))) {
	//			pr_err("failed to set inhibit charge on %d", battery);
	//			return -ENODEV;
	//		}
	//		return 0;

	// FIXME: Implement BICS!
	//
	//        BAT0 = send 0x02 to register 0xb4
	//        BAT1 = send 0x02 to register 0xb5
	//
	//        send 0x01 to clear it! (auto mode?)
	// ...

	Return (1 << 31)
}

// Get discharge status
Method (BDSG, 1, NotSerialized)
{
	// Battery 1
	If (Arg0 == 1)
	{
		// Quote from thinkpad_acpi.c: Support is marked in bit 8
		// Currently the purpose of all other bits is unknown!
		// Bit 0 is set if forced discharging is active?
		Return 0x700
	}

	// Battery 2
	If (Arg0 == 2)
	{
		// FIXME: Implement 2nd battery
		Return 0x00
	}

	Return (1 << 31)
}

// Get inhabit charging status
Method (BICG, 1, NotSerialized)
{
	// Battery 1
	If (Arg0 == 1)
	{
		// Quote from thinkpad_acpi.c: Support is marked in bit 5
		// Currently the purpose of all other bits is unknown!
		// Bit 0 is set if inhabit charging is active?
		// Bits 23-8 are permanently set if inhabit charging is/was active?
		Return 0x70
	}

	// Battery 2
	If (Arg0 == 2)
	{
		// FIXME: Implement 2nd battery
		Return 0x00
	}

	Return (1 << 31)
}
