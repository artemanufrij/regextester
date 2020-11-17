/*-
 * Copyright (c) 2017-2017 Artem Anufrij <artem.anufrij@live.de>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 * The Noise authors hereby grant permission for non-GPL compatible
 * GStreamer plugins to be used and distributed together with GStreamer
 * and Noise. This permission is above and beyond the permissions granted
 * by the GPL license by which Noise is covered. If you modify this code
 * you may extend this exception to your version of the code, but you are not
 * obligated to do so. If you do not wish to do so, delete this exception
 * statement from your version.
 *
 * Authored by: Artem Anufrij <artem.anufrij@live.de>
 */

namespace RegexTester.Widgets {
    public class MatchItem : Gtk.ListBoxRow {

        public int start { get; set; }
        public int end { get; set; }

        public MatchItem (int count, GLib.List<RegexTester.GroupItem> group_items) {
            this.start = group_items.first ().data.pos_start;
            this.end = group_items.first ().data.pos_end;
            var content = new Gtk.Grid ();
            content.margin = 6;
            content.row_spacing = 6;

            var match_count = new Gtk.Label (_("Match %d").printf (count));
            match_count.hexpand = true;
            match_count.halign = Gtk.Align.START;

            var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            int group_counter = 0;
            foreach (var item in group_items) {

                var row = new Gtk.Grid ();
                row.column_spacing = 4;
                var menu = new Gtk.Menu ();
                var menu_copy = new Gtk.MenuItem.with_label (_("Copy match…"));
                menu_copy.activate.connect (() => {
                    Gtk.Clipboard.get_default (Gdk.Display.get_default ()).set_text (item.text, -1);
                });

                var match_text = new Gtk.Label ("");
                match_text.use_markup = true;
                if (item == group_items.first ().data) {
                    match_text.label = "<b>%s</b>".printf (item.text);
                } else {
                    match_text.label = _("<small>Group %d:</small> %s").printf (group_counter, item.text);
                }
                match_text.tooltip_text = item.text;
                match_text.ellipsize = Pango.EllipsizeMode.MIDDLE;
                match_text.hexpand = true;
                match_text.halign = Gtk.Align.START;

                var event_box = new Gtk.EventBox ();
                event_box.button_press_event.connect ((sender, evt) => {
                    if (evt.type == Gdk.EventType.BUTTON_PRESS && evt.button == 3) {
                        menu.popup_at_pointer();
                        return true;
                    }
                    return false;
                });
                event_box.add (match_text);

                var pos = new Gtk.Label (("<small>%d - %d</small>").printf (item.pos_start, item.pos_end));
                pos.use_markup = true;
                pos.halign = Gtk.Align.END;

                menu.append (menu_copy);
                menu.show_all ();

                row.attach (event_box, 0, 0);
                row.attach (pos, 1, 0);
                box.pack_start (row, true, true, 0);

                group_counter ++;
            }

            string pkgdir = "/usr/share/" + GLib.Environment.get_application_name ();

            Gtk.Image icon;
            if (count % 2 == 0) {
                icon = new Gtk.Image.from_file(pkgdir + "/icons/regex-match-second.svg");
            } else {
                icon = new Gtk.Image.from_file(pkgdir + "/icons/regex-match-first.svg");
            }

            content.attach (icon, 0, 0);
            content.attach (match_count, 1, 0);
            content.attach (box, 0, 1, 2, 1);
            this.add (content);
        }

    }
}
