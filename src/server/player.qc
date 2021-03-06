/*
 * Copyright (c) 2016-2021 Marco Hladik <marco@icculus.org>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF MIND, USE, DATA OR PROFITS, WHETHER
 * IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING
 * OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

/*
====================
UseWorkaround
====================
*/
void
UseWorkaround(entity eTarget)
{
	eActivator = self;
	entity eOldSelf = self;
	self = eTarget;
	self.PlayerUse();
	self = eOldSelf;
}

/*
====================
Player_UseDown
====================
*/
void
Player_UseDown(void)
{
	if (self.health <= 0) {
		return;
	} else if (!(self.flags & FL_USE_RELEASED)) {
		return;
	}
	
	vector vSource;

	makevectors(self.v_angle);
	vSource = self.origin + self.view_ofs;
	traceline (vSource, vSource + (v_forward * 64), MOVE_EVERYTHING, self);

	if (trace_ent.PlayerUse) {
		self.flags &= ~FL_USE_RELEASED;
		
		UseWorkaround(trace_ent);

		/* Some entities want to support Use spamming */
		if (!(self.flags & FL_USE_RELEASED)) {
			sound(self, CHAN_ITEM, "common/wpn_select.wav", 0.25, ATTN_IDLE);
		}
	} else {
		sound(self, CHAN_ITEM, "common/wpn_denyselect.wav", 0.25, ATTN_IDLE);
		self.flags &= ~FL_USE_RELEASED;
	}
}

/*
====================
Player_UseUp
====================
*/
void
Player_UseUp(void)
{
	if (!(self.flags & FL_USE_RELEASED)) {
		self.flags |= FL_USE_RELEASED;
	}
}

void Weapons_Draw(void);

void
CSEv_PlayerSwitchWeapon_i(int w)
{
	player pl = (player)self;
	pl.activeweapon = w;
	Weapons_Draw();
}

void
Player_Precache(void)
{
	searchhandle pm;
	pm = search_begin("models/player/*/*.mdl", TRUE, TRUE);
	for (int i = 0; i < search_getsize(pm); i++) {
		precache_model(search_getfilename(pm, i));
	}
	search_end(pm);
}
