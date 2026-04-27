/* SPDX-License-Identifier: GPL-2.0-only */

#define DISABLE_INHIBITCHARGE_VALUE  0x01
#define ENABLE_INHIBITCHARGE_VALUE   0x02
#define DISABLE_FORCEDISCHARGE_VALUE 0x03
#define ENABLE_FORCEDISCHARGE_VALUE  0x04

Scope(\_SB.PCI0.LPCB.EC.HKEY)
{
	/* EC Registers */
	Field (ERAM, ByteAcc, NoLock, Preserve)
	{
		Offset(0x0f),
				BACB,  8,	/* Battery charge behaviour */
		Offset (0x38),
				BAST, 16,	/* Battery state */
		Offset (0xb4),
				B0CC,  8,	/* BAT0 charge control */
		Offset (0xb5),
				B1CC,  8,	/* BAT1 charge control */
	}

	/*
	 * Set state for force-discharge:
	 *  Bit 8-9: Battery ID (0x1=BAT0; 0x2=BAT1)
	 *  Bit 1: Break on AC attach
	 *  Bit 0: Enable or disable
	 */
	Method (BDSS, 1, NotSerialized)
	{
		Local0 = Arg0 & 0x1        // New state
		Local1 = (Arg0 >> 8) & 0x3 // Battery ID
		Local2 = (Arg0 >> 1) & 0x1 // Break on AC attach
		Local3 = 0x00              // EC RAM value

		If (Local0)
		{
			Local3 = ENABLE_FORCEDISCHARGE_VALUE
		}
		Else
		{
			Local3 = DISABLE_FORCEDISCHARGE_VALUE
		}

		// FIXME: Implement break on AC attach!
		If (!Local2)
		{
			// BAT0
			If (Local1 == 1)
			{
				B0CC = Local3
				Return (0x0)
			}

			// BAT1
			If (Local1 == 2)
			{
				B1CC = Local3
				Return (0x0)
			}
		}

		Return (1 << 31)
	}

	/*
	 * Argument: 1 for BAT0; 2 for BAT1
	 * Returns the current state for force-discharge:
	 *  Bit 8: Feature supported
	 *  Bit 0: Currently active
	 */
	Method (BDSG, 1, NotSerialized)
	{
		If (Arg0 & 0x3)
		{
			// BAT0 present is in bit 7.
			// BAT1 present is in bit 15.
			If (BAST >> (8 * Arg0 - 1))
			{
				// FIXME: Find support-bit in EC RAM!
				Local0 = 0x100

				// BAT0 is in bit 2. BAT1 is in bit 3.
				Local0 |= (BACB >> (Arg0 + 1)) & 0x1

				Return (Local0)
			}
		}

		Return (1 << 31)
	}

	/*
	 * Set state for inhibit-charge:
	 *  Bit 8-23: Effective time (0xffff indicates forever)
	 *  Bit 4-5: Battery ID (0x1=BAT0; 0x2=BAT1)
	 *  Bit 0: Enable or disable
	 */
	Method (BICS, 1, NotSerialized)
	{
		Local0 = Arg0 & 0x1           // New state
		Local1 = (Arg0 >> 4) & 0x3    // Battery ID
		Local2 = (Arg0 >> 8) & 0xffff // Effective time
		Local3 = 0x00                 // EC RAM value

		// FIXME: Implement effective time!
		If (Local2 == 0xffff)
		{
			If (Local0)
			{
				Local3 = ENABLE_INHIBITCHARGE_VALUE
			}
			Else
			{
				Local3 = DISABLE_INHIBITCHARGE_VALUE
			}

			// BAT0
			If (Local1 == 1)
			{
				B0CC = Local3
				Return (0x0)
			}

			// BAT1
			If (Local1 == 2)
			{
				B1CC = Local3
				Return (0x0)
			}
		}

		Return (1 << 31)
	}

	/*
	 * Argument: 0x1 for BAT0; 0x2 for BAT1
	 * Returns the current state for inhibit-charge:
	 *  Bit 5: Feature supported
	 *  Bit 0: Currently active
	 */
	Method (BICG, 1, NotSerialized)
	{
		If (Arg0 & 0x3)
		{
			// BAT0 present is in bit 7.
			// BAT1 present is in bit 15.
			If (BAST >> (8 * Arg0 - 1))
			{
				// FIXME: Find support-bit in EC RAM!
				Local0 = 0x20

				// BAT0 status is in bit 0.
				// BAT1 status is in bit 1.
				Local0 |= (BACB >> (Arg0 - 1)) & 0x1

				Return (Local0)
			}
		}

		Return (1 << 31)
	}
}
